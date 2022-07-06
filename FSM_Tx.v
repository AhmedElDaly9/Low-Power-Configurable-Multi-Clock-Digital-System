module FSM_Tx 
(
    input   wire            Data_valid  ,
    input   wire            PAR_EN      ,
    input   wire            ser_done    ,
    input   wire            rst         ,
    input   wire            CLK         ,

    output  reg     [1:0]   mux_sel     ,
    output  reg             ser_en      ,
    output  reg             busy    
);

localparam  start_bit_sel   =   2'b00   ,
            stop_bit_sel    =   2'b01   ,
            ser_data_sel    =   2'b10   ,
            par_bit_sel     =   2'b11   ;

localparam  IDLE    = 3'b000 ,
            S0      = 3'b001 ,
            S1      = 3'b010 ,
            S2      = 3'b011 ,
            S3      = 3'b100 ;
            
reg     [2:0]   current_state   ;
reg     [2:0]   next_state      ;

always @(posedge CLK,negedge rst) 
    begin
        if (!rst)
            begin
                current_state   <= IDLE         ;   
            end
        else
            begin
                current_state   <= next_state   ;
            end
    end

always @(*) 
    begin
        case (current_state)
            IDLE :
                begin
                    if (Data_valid)
                        begin
                            next_state <= S0    ;
                        end
                    else
                        begin
                            next_state <= IDLE  ;
                        end
                end 

            S0      :
                begin
                    begin
                    next_state  <= S1   ;
                    end
                end

            S1      :
                begin
                    if (ser_done)
                        begin
                            if (PAR_EN)
                                begin
                                    next_state  <= S2   ;
                                end
                            else
                                begin
                                    next_state  <= S3   ;
                                end
                        end
                    else
                        begin
                            next_state  <= S1   ; 
                        end
                end

            S2 :
                begin
                    next_state  <= S3   ;
                end

            S3 :
                begin
                    if (Data_valid)
                        begin
                            next_state  <= S0   ; 
                        end
                    else
                        begin
                            next_state  <= IDLE ;
                        end
                end

            default: next_state <= IDLE ;
        endcase
    end

always @(*) 
    begin
        case (current_state)
            IDLE    :
                begin
                    mux_sel     <= stop_bit_sel     ;
                    ser_en      <= 1'b0             ;
                    busy        <= 1'b0             ;
                end

            S0      :
                begin
                    mux_sel     <= start_bit_sel    ;
                    ser_en      <= 1'b1             ;
                    busy        <= 1'b1             ;
                end

            S1      :
                begin
                    mux_sel     <= ser_data_sel     ;
                    ser_en      <= 1'b1             ;
                    busy        <= 1'b1             ;
                end

            S2      :
                begin
                    mux_sel     <= par_bit_sel      ;
                    ser_en      <= 1'b0             ;
                    busy        <= 1'b1             ;
                end

            S3      :
                begin
                    mux_sel     <= stop_bit_sel     ;
                    ser_en      <= 1'b0             ;
                    busy        <= 1'b1             ;
                end

            default :
                begin
                    mux_sel     <= stop_bit_sel     ;
                    ser_en      <= 1'b0             ;
                    busy        <= 1'b0             ;
                end 
        endcase        
    end

endmodule
