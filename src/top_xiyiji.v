module top_xiyiji   (select,ledzheng,ledfan,ledstop,ledinlet,leddrain,leddry,clk,zheng,fan,start,alarm,emergency,
                    mode_c,inlet,drain,dry,c_s,time_c,tmp,rst,discode,enable_xiyiji,enable_shumaguan,clk_1hz,select_qudou,
                    start_qudou,emergency_qudou,rst_qudou,count);
    output wire [7:0] discode;
    output [1:0] mode_c;
    output [3:0] time_c,c_s;
    output [2:0] tmp;
    input clk,start,emergency,select,rst;
    output wire [5:0] count;
    output ledzheng,ledfan,ledstop,ledinlet,leddrain,leddry,zheng,fan,alarm;
    output inlet,drain,dry,enable_xiyiji;
    output [1:0] enable_shumaguan;
    output clk_1hz,select_qudou,start_qudou,emergency_qudou,rst_qudou;

    wire [3:0] num0,num1;
    
    assign num0 = count % 4'd10; // 个位数
    assign num1 = count / 4'd10 % 4'd10 ; // 十位数

    xiyiji M0(.select(select_qudou), .ledzheng(ledzheng), .ledfan(ledfan), .ledstop(ledstop), .ledinlet(ledinlet), .leddrain(leddrain), .leddry(leddry), .clk(clk_1hz), .zheng(zheng), .fan(fan), .mode_c(mode_c), .inlet(inlet), .drain(drain), .dry(dry), .start(start_qudou), .alarm(alarm), .emergency(emergency_qudou), .count(count), .rst(rst), .c_s(c_s), .time_c(time_c), .enable(enable_xiyiji), .tmp(tmp));

    fdiv100 M1(.clockin(clk), .clockout(clk_1hz));

    qudou M2(.keyin(select), .keyout(select_qudou), .clock(clk));
    qudou M3(.keyin(start), .keyout(start_qudou), .clock(clk));
    qudou M4(.keyin(emergency), .keyout(emergency_qudou), .clock(clk));
    qudou M5(.keyin(rst), .keyout(rst_qudou), .clock(clk));
    
    shumaguan M6(.qclock(clk), .code1(num1), .code2(num0), .discode(discode), .enable(enable_shumaguan));
endmodule