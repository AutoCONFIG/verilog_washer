`timescale 100ms/1ms

module xiyiji_tb(select,clk,start,emergency,rst);
    output reg clk,start,emergency,select,rst;

    wire ledzheng,ledfan,ledstop,ledinlet,leddrain,leddry,zheng,fan,inlet,drain,dry,alarm;
    
    wire [1:0] mode_c;
    wire [5:0] count;

    wire enable;
    wire [1:0] tmp;
    wire [3:0] c_s,time_c; //Debug

    initial begin
        clk=0;
        select=0;
        start=0;
        rst=1;
        emergency=0;
        #100 select=1;
        #100 select=0;
        #100 select=1;
        #100 select=0;

        #100 start=1;
    end

    always #5 clk=~clk;

xiyiji M8(.select(select), .ledzheng(ledzheng), .ledfan(ledfan), .ledstop(ledstop), .ledinlet(ledinlet), .leddrain(leddrain), .leddry(leddry), .clk(clk), .zheng(zheng), .fan(fan), .mode_c(mode_c), .inlet(inlet), .drain(drain), .dry(dry), .start(start), .alarm(alarm), .emergency(emergency), .count(count), .rst(rst), .c_s(c_s), .time_c(time_c), .enable(enable), .tmp(tmp));

endmodule