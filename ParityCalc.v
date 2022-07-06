module ParityCalc 
(
    input   wire [7:0]  P_DATA      ,
    input   wire        PAR_TYP     ,

    output  wire        par_bit
);

assign  par_bit = ^P_DATA ^ PAR_TYP     ;
    
endmodule