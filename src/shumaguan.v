module shumaguan(qclock,code1,code2,discode,enable);
    input qclock;
    input [3:0] code1,code2;
    output reg [6:0] discode;
    output reg [1:0] enable;
    
    reg count = 1;
    reg [3:0] code;

    always @(posedge qclock) begin
        if (count == 1)
            count <= 0; //个位
        else
            count <= count + 1; //十位
            case (count)
                1'b0:begin
                    code<=code2;
                    enable <= 2'b10;
                end
                1'b1:begin
                    code<=code1;
                    enable <= 2'b01;
                end
            endcase
            case (code)
                /*
                4'b0000:discode <= 7'b1111110;
                4'b0001:discode <= 7'b0110000;
                4'b0010:discode <= 7'b1101101;
                4'b0011:discode <= 7'b1111001;
                4'b0100:discode <= 7'b0110011;
                4'b0101:discode <= 7'b1011011;
                4'b0110:discode <= 7'b1011111;
                4'b0111:discode <= 7'b1110000;
                4'b1000:discode <= 7'b1111111;
                4'b1001:discode <= 7'b1111011;
                default:discode <= 7'b0000000;*/
                1:discode <= 1;
                2:discode <= 2;
                3:discode <= 3;
                4:discode <= 4;
                5:discode <= 5;
                6:discode <= 6;
                7:discode <= 7;
                8:discode <= 8;
                9:discode <= 9;
                0:discode <= 0;
            endcase
    end
endmodule