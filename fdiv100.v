module fdiv100(clockin,clockout);
    input clockin;
    output clockout;

    reg clockout = 0;
    reg [7:0] count = 0;

    always @(posedge clockin) begin
        if (count == 50) begin
            clockout = ~clockout;
            count <= 0;
        end
        else count <= count + 1;
    end
endmodule