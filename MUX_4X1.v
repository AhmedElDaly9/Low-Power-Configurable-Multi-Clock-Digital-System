module MUX_4X1 
(
    input   wire    [1:0]   Sel     ,
    input   wire            In0     ,
    input   wire            In1     ,
    input   wire            In2     ,
    input   wire            In3     ,

    output  reg             MUX_OUT     
);

always @(*) 
    begin
        case (Sel)
            2'b00: MUX_OUT <= In0   ;
            2'b01: MUX_OUT <= In1   ;
            2'b10: MUX_OUT <= In2   ;
            2'b11: MUX_OUT <= In3   ;
            
            default: MUX_OUT <= In0   ;
        endcase    
    end
    
endmodule