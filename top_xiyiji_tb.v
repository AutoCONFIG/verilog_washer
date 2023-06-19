`timescale 100us/100us

module top_xiyiji_tb (clk,start,emergency,add,rst);
    output reg clk,start,emergency,add,rst;
    wire ledzheng,ledfan,ledstop,zheng,fan,alarm;
    wire [6:0] discode;
    wire [1:0] enable;
    wire [5:0] count;
    wire clk_1hz,add_qudou,start_qudou,emergency_qudou,rst_qudou;

    initial begin
        clk=0;
        add=0;
        start=0;
        rst=0;
        emergency=0;
        #1000 rst=1;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 add=1;
        #1000 add=0;
        #1000 start=1;
    end

    always #50 clk=~clk;

top_xiyiji M7 (.add(add), .ledzheng(ledzheng), .ledfan(ledfan), .ledstop(ledstop), .clk(clk), .zheng(zheng), .fan(fan), .start(start), .alarm(alarm), .emergency(emergency), .rst(rst), .discode(discode), .enable(enable), .clk_1hz(clk_1hz), .add_qudou(add_qudou), .start_qudou(start_qudou), .emergency_qudou(emergency_qudou), .rst_qudou(rst_qudou), .count1(count));

endmodule