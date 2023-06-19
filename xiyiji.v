module xiyiji(add,ledzheng,ledfan,ledstop,clk,zheng,fan,start,alarm,emergency,count,rst);
input add,clk,start,emergency,rst;  //#add：增加循环次数 #clk：秒时钟   #start：启动洗衣机  #emergency  启动紧急模式,类似rst复位到初始化状态
output ledfan,ledzheng,ledstop,zheng,fan,alarm;//,count; //#ledfan：反转指示灯 #ledzheng：正转指示灯   #ledstop：待机指示灯    #zheng/fan：正/反转输出 #alarm：警报    #count：计数剩余值

reg ledfan,ledstop,ledzheng,zheng,fan,alarm;
reg [3:0] time_t,time_c;
output reg [5:0] count;
reg [1:0] c_s,n_s;

parameter S0 = 2'b00;   //待机状态
parameter S1 = 2'b01;   //正转状态
parameter S2 = 2'b10;   //待机状态
parameter S3 = 2'b11;   //反转状态

always @(posedge add) begin //增加循环次数
    while (add && (time_t < 15)) begin    //最大循环15次
            time_t = time_t + 4'b0001;
    end
end

always@(negedge emergency) begin
    if (!emergency) begin //紧急状态
        zheng <= 0;
        fan <= 0;
        ledstop <= 1;
        ledzheng <= 0;
        ledfan <= 0;
    end
end

always@(posedge clk or negedge rst) begin   //D触发器模块
    if (!rst)
        c_s <= S0;
    else
        c_s <= n_s;
end

always @ (count or c_s) begin    //n_s模块
        case (c_s)
        S0:begin
            if (count == 6'b000101) begin   //维持5秒
                time_c <= time_c - 4'b0001;
                count <= 6'b000000;    //计数器清零
                n_s <= S1;
            end
        end
        S1:begin
            if (count == 6'b111100) begin  //维持60秒
                time_c <= time_c - 4'b0001;
                count <= 6'b000000;    //计数器清零
                n_s <= S2;
            end
        end
        S2:begin
            if (count == 6'b000101) begin   //维持5秒
                time_c <= time_c - 4'b0001;
                count <= 6'b000000;    //计数器清零
                n_s <= S3;
            end
        end
        S3:begin
            if (count == 6'b111100 ) begin  //维持60秒
                time_c <= time_c - 4'b0001;
                count <= 6'b000000;    //计数器清零
                n_s <= S0;
            end
        end
        default:begin
            n_s <= S0;
            time_t <= 4'b0000;
        end
        endcase
end

always@(posedge clk) begin   //c_s模块
    if (!start) begin   //未按下启动建，始终保持初始化状态
        n_s <= S0;
        count <= 6'b000000;
        time_c <= time_t;
        alarm  <= 0;
    end
    else if (time_c == 0) begin //洗衣流程结束
        n_s <= S0;
        count <= 6'b000000;
        alarm <= 1;
    end
    else count <= count + 6'b000001; //计数器秒加一

    case (c_s)
        S0:begin
            zheng <= 0;
            fan <=0;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 1;
        end
        S1:begin
            zheng <= 1;
            fan <= 0;
            ledzheng <= 1;
            ledfan <= 0;
            ledstop <= 0;
        end
        S2:begin
            zheng <= 0;
            fan <=0;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 1;
        end
        S3:begin
            zheng <= 0;
            fan <= 1;
            ledzheng <= 0;
            ledfan <= 1;
            ledstop <= 0;
        end
    endcase
end

endmodule