`timescale 100us/100us

module top_xiyiji_tb (clk,start,emergency,count,select,rst);
    output reg clk,start,emergency,select,rst;
    wire ledzheng,ledfan,ledstop,zheng,fan,alarm,enable_xiyiji;
    wire [6:0] discode;
    wire [1:0] enable_shumaguan;
    output wire [5:0] count;
    wire [1:0] mode_c;
    wire [3:0] time_c,c_s;
    wire [2:0] tmp;
    wire clk_1hz,select_qudou,start_qudou,emergency_qudou,rst_qudou;

    initial begin
        clk=0;
        select=0;
        start=0;
        rst=1;
        emergency=0;
        #4000 select=1;
        #4000 select=0;
        #8000 ;
        #4000 select=1;
        #4000 select=0;
        #8000 ;
        #4000 select=1;
        #4000 select=0;

        #1000 start=1;
    end

    always #50 clk=~clk;

top_xiyiji M7 (.select(select), .ledzheng(ledzheng), .ledfan(ledfan), .ledstop(ledstop), .ledinlet(ledinlet), .leddrain(leddrain), .leddry(leddry),
             .clk(clk), .zheng(zheng), .fan(fan), .start(start), .alarm(alarm), .emergency(emergency), .mode_c(mode_c), .inlet(inlet), .drain(drain),
             .dry(dry), .c_s(c_s), .time_c(time_c), .tmp(tmp), .rst(rst), .discode(discode), .enable_xiyiji(enable_xiyiji), .enable_shumaguan(enable_shumaguan), .clk_1hz(clk_1hz), .select_qudou(select_qudou),
            .start_qudou(start_qudou), .emergency_qudou(emergency_qudou), .rst_qudou(rst_qudou), .count(count));
endmodule
