`timescale 1ms/1ms

module fdiv100_tb(clockout);    
    reg clk = 0;
    output clockout;

    always #10 clk=~clk;

fdiv100 M9(.clockin(clk), .clockout(clockout));

endmodule