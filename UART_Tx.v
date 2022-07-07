module UART_Tx 
(
    input   wire  [7:0] P_DATA      ,
    input   wire        PAR_EN      ,
    input   wire        Data_valid  ,
    input   wire        rst         ,
    input   wire        CLK         ,
    input   wire        PAR_TYP     ,

    output  wire        TX_OUT      ,
    output  wire        busy
);

localparam  start_bit   =   1'b0    ,
            stop_bit    =   1'b1    ;

/****************INTERNAL SIGNALS****************/
wire            ser_data    ;
wire            ser_en      ;
wire            ser_done    ;
wire    [1:0]   mux_sel     ;
wire            par_bit     ;


/************************************************/
/******************_SERIALIZER_******************/
/************************************************/
/*    
    input   wire    [7:0]   P_DATA      ,
    input   wire            ser_en      ,
    input   wire            rst         ,
    input   wire            CLK         ,

    output  wire            ser_data    ,
    output  wire            ser_done     
*/
Serializer SerializerTX
(
    .P_DATA     (P_DATA)        ,
    .ser_en     (ser_en)        ,
    .rst        (rst)           ,
    .CLK        (CLK)           ,

    .ser_data   (ser_data)      ,
    .ser_done   (ser_done)
);


/************************************************/
/*********************_FSM_**********************/
/************************************************/
/*
    input   wire            Data_valid  ,
    input   wire            PAR_EN      ,
    input   wire            ser_done    ,
    input   wire            rst         ,
    input   wire            CLK         ,

    output  reg     [1:0]   mux_sel     ,
    output  reg             ser_en      ,
    output  reg             busy    
*/
FSM_Tx FSMTX
(
    .Data_valid (Data_valid)    ,
    .PAR_EN     (PAR_EN)        ,
    .ser_done   (ser_done)      ,
    .rst        (rst)           ,
    .CLK        (CLK)           ,

    .mux_sel    (mux_sel)       ,
    .ser_en     (ser_en)        ,
    .busy       (busy)      
);


/************************************************/
/***************_ParityCalculator_***************/
/************************************************/
/*
    input   wire [7:0]  P_DATA      ,
    input   wire        PAR_TYP     ,

    output  wire        par_bit
*/
ParityCalc ParCalcTX
(
    .P_DATA     (P_DATA)    ,
    .PAR_TYP    (PAR_TYP)   ,

    .par_bit    (par_bit)   
);

/************************************************/
/*********************_MUX_**********************/
/************************************************/
/*
    input   wire    [1:0]   Sel     ,
    input   wire            In0     ,
    input   wire            In1     ,
    input   wire            In2     ,
    input   wire            In3     ,

    output  reg             MUX_OUT    
*/
MUX_4X1 MUX_TX
(
    .Sel    (mux_sel)   ,
    .In0    (start_bit) ,
    .In1    (stop_bit)  ,
    .In2    (ser_data)  ,
    .In3    (par_bit)   ,

    .MUX_OUT    (TX_OUT)
);

endmodule