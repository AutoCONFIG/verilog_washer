`timescale 1ms/1ms

module qudou_tb(add);
    output reg add;
    reg clk;

    initial begin
        clk=0;
        add=0;
        #100 add=1;
    end

    always #10 clk=~clk;

qudou M10(.keyin(add), .keyout(add_qudou), .clock(clk));

endmodule