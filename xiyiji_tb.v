`timescale 1ms/1ms

module xiyiji_tb(add,clk,start,emergency,rst);
    output reg clk,start,emergency,add,rst;

    wire ledzheng,ledfan,ledstop,zheng,fan,alarm;
    
    wire [5:0] count;

    initial begin
        clk=0;
        add=0;
        start=0;
        rst=1;
        emergency=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 add=1;
        #100 add=0;
        #100 start=1;
    end

    always #10 clk=~clk;

xiyiji M8(.add(add), .ledzheng(ledzheng), .ledfan(ledfan), .ledstop(ledstop), .clk(clk), .zheng(zheng), .fan(fan), .start(start), .alarm(alarm), .emergency(emergency), .count(count), .rst(rst));

endmodule