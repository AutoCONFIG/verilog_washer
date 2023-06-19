module qudou(keyin,keyout,clock);
    input clock,keyin;
    output reg keyout =0;

    reg [1:0] count = 0;

    always @(posedge clock) begin
        if (keyin == 1) begin
            count <= count + 1;
            if (count >= 2) begin
                keyout <= 1;
                count <= 3;
            end
            else keyout <= 0;
        end
        else begin
            keyout <= 0;
            count <= 0;
        end
    end
endmodule