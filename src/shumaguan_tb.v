`timescale 1ms/1ms

module shumaguan_tb();
    wire [6:0] discode;
    wire [1:0] enable;

    wire [3:0] num0,num1;

    reg clk;
    reg [7:0] count; //输入数值

    initial begin
        clk=0;
        count = 0;

        #100 count = 7'd13;
        #1000 count = 7'd14;
        #1000 count = 7'd23;
        #1000 count = 7'd26;
        #1000 count = 7'd52;
        #1000 count = 7'd00;

    end

    always #5 clk=~clk;

assign num0 = count % 4'd10; // 个位数
assign num1 = count / 4'd10 % 4'd10 ; // 十位数


shumaguan M10(.qclock(clk), .code1(num1), .code2(num0), .discode(discode), .enable(enable));

endmodule