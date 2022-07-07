module Serializer 
(
    input   wire    [7:0]   P_DATA      ,
    input   wire            ser_en      ,
    input   wire            rst         ,
    input   wire            CLK         ,

    output  wire            ser_data    ,
    output  wire            ser_done     
);

reg     [3:0]   counter     ;
reg     [7:0]   data        ;

always @(posedge CLK, negedge rst) 
    begin
        if (!rst)
            begin
                counter <= 4'd0     ;
                data    <= 7'd0     ;
            end
        else if (ser_en)
            begin
                if (counter == 4'b0000)
                    begin
                        data        <= P_DATA           ;
                        counter     <= counter + 4'b1   ;
                    end
                else if (counter[3] == 1'b0 ) // counter is less than 8
                    begin
                        data        <= data >> 4'b1     ;
                        counter     <= counter + 4'b1   ;
                    end
                else
                    begin
                        counter     <= 4'b0000          ;
                    end
                end  
    end

assign  ser_done = counter[3]   ;
assign  ser_data = data [0]     ;
    
endmodule