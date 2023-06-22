`timescale 1ms/1ms

module qudou_tb(add);
    output reg add;
    reg clk;

    initial begin
        clk=0;
        add=0;
        #50 add=1;
        #100 add=0;
        #10 add=1;
        #5 add=0;
        #10 add=1;
        #5 add=0;
        #10 add=1;
        #5 add=0;
        #10 add=1;
        #5 add=0;
        #10 add=1;
        #5 add=0;
    end

    always #5 clk=~clk;

qudou M10(.keyin(add), .keyout(add_qudou), .clock(clk));

endmodule