`timescale 1ns/100ps

module UART_Tx_tb ();

    /***************Testbench signals***************/
    reg     [7:0]   P_DATA_tb       ;
    reg             PAR_EN_tb       ;
    reg             Data_valid_tb   ;
    reg             rst_tb          ;
    reg             CLK_tb          ;
    reg             PAR_TYP_tb      ;

    wire            TX_OUT_tb       ;
    wire            busy_tb         ;
    
    /***************Clock Variables***************/
    localparam  CLK_PERIOD = 5                  ;
    always #(0.5*CLK_PERIOD) CLK_tb = ~CLK_tb   ;

    /**************Desgin under test**************/
    UART_Tx DUT
    (
        .P_DATA         (P_DATA_tb)         ,
        .PAR_EN         (PAR_EN_tb)         ,
        .Data_valid     (Data_valid_tb)     ,
        .rst            (rst_tb)            ,
        .CLK            (CLK_tb)            ,
        .PAR_TYP        (PAR_TYP_tb)        ,

        .TX_OUT         (TX_OUT_tb)         ,
        .busy           (busy_tb)
    );

    initial 
        begin
            $dumpfile ("UART_Tx_tb.vcd")    ;
            $dumpvars                       ;

            rst_tb          =   1'b1    ;
            CLK_tb          =   1'b0    ;
            Data_valid_tb   =   1'b0    ;   

            #(0.2*CLK_PERIOD)
            rst_tb          =   1'b0    ;

            #(0.5*CLK_PERIOD)
            rst_tb          =   1'b1    ;

            #CLK_PERIOD
            P_DATA_tb       =   8'b11010101 ;
            PAR_EN_tb       =   1'b0        ;
            Data_valid_tb   =   1'b1        ;

            #CLK_PERIOD
            if (TX_OUT_tb == 1'b0)
                begin
                    $display ("Test1: PASSED : Start bit works fine");
                end
            else
                begin
                    $display ("Test1: FAILED : There is a problem in the start bit");
                end

            #CLK_PERIOD
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test2: PASSED : LSB works fine");
                end
            else
                begin
                    $display ("Test2: FAILED : There is a problem in the LSB");
                end

            #(CLK_PERIOD*5)
            if (TX_OUT_tb == 1'b0)
                begin
                    $display ("Test3: PASSED : sixth bit works fine");
                end
            else
                begin
                    $display ("Test3: FAILED : There is a problem in the sixth bit");
                end

            #(CLK_PERIOD*3)
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test4: PASSED : stop bit works fine");
                end
            else
                begin
                    $display ("Test4: FAILED : There is a problem in the stop bit");
                end

            P_DATA_tb       =   8'b00000001 ;
            PAR_EN_tb       =   1'b1        ;
            PAR_TYP_tb      =   1'b0        ; // even parity

            #(CLK_PERIOD)
            if (TX_OUT_tb == 1'b0)
                begin
                    $display ("Test5: PASSED : start bit for second trial works fine");
                end
            else
                begin
                    $display ("Test5: FAILED : There is a problem in the start bit of the second trial");
                end
            
            #(CLK_PERIOD)
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test5: PASSED : first bit for second trial works fine");
                end
            else
                begin
                    $display ("Test5: FAILED : There is a problem in the first bit of the second trial");
                end

            #(CLK_PERIOD*7)
            if (TX_OUT_tb == 1'b0)
                begin
                    $display ("Test6: PASSED : MSB bit for second trial works fine");
                end
            else
                begin
                    $display ("Test6: FAILED : There is a problem in the MSB of the second trial");
                end

            Data_valid_tb   = 1'b0  ;

            #(CLK_PERIOD)
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test7: PASSED : parity bit for second trial works fine");
                end
            else
                begin
                    $display ("Test7: FAILED : There is a problem in the parity bit of the second trial");
                end

            #(CLK_PERIOD)
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test8: PASSED : stop bit for second trial works fine");
                end
            else
                begin
                    $display ("Test8: FAILED : There is a problem in the stop bit of the second trial");
                end

            #(CLK_PERIOD)
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test9: PASSED : IDLE bit after second trial works fine");
                end
            else
                begin
                    $display ("Test9: FAILED : There is a problem in the IDLE bit after the second trial");
                end

            #(CLK_PERIOD*5)
            if (TX_OUT_tb == 1'b1)
                begin
                    $display ("Test10: PASSED : IDLE bit still works fine");
                end
            else
                begin
                    $display ("Test10: FAILED : There is a problem in the IDLE bit after a while");
                end


            #(CLK_PERIOD*10)
            $finish     ;

        end

endmodule