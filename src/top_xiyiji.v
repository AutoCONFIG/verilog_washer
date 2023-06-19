module top_xiyiji(add,ledzheng,ledfan,ledstop,clk,zheng,fan,start,alarm,emergency,rst,discode,enable,clk_1hz,add_qudou,start_qudou,emergency_qudou,rst_qudou,count1);
    output [7:0] discode;
    output [1:0] enable;
    input clk,start,emergency,add,rst;
    input [5:0] count1;
    output ledzheng,ledfan,ledstop,zheng,fan,alarm;

    output clk_1hz,add_qudou,start_qudou,emergency_qudou,rst_qudou;
    reg[7:0] count;

    xiyiji M0(.add(add_qudou), .ledzheng(ledzheng), .ledfan(ledfan), .ledstop(ledstop), .clk(clk_1hz), .zheng(zheng), .fan(fan), .start(start_qudou), .alarm(alarm), .emergency(emergency_qudou), .count(count1), .rst(rst_qudou));
    
    fdiv100 M1(.clockin(clk), .clockout(clk_1hz));

    qudou M2(.keyin(add), .keyout(add_qudou), .clock(clk));
    qudou M3(.keyin(start), .keyout(start_qudou), .clock(clk));
    qudou M4(.keyin(emergency), .keyout(emergency_qudou), .clock(clk));
    qudou M5(.keyin(rst), .keyout(rst_qudou), .clock(clk));
    
    shumaguan M6(.qclock(clk), .code1(count[7:4]), .code2(count[3:0]), .discode(discode), .enable(enable));
endmodule