module xiyiji(select,ledzheng,ledfan,ledstop,clk,zheng,fan,start,alarm,emergency,count,rst);
input select,clk,start,emergency,rst;  //#select：选择工作模式，#clk：秒时钟，#start：启动洗衣机，#emergency：急停模式，#rst：复位
output ledfan,ledzheng,ledstop,ledinlet,leddrain,zheng,fan,alarm; //#ledfan：反转指示灯 #ledzheng：正转指示灯 #ledinlet：进水指示灯 #leddrain：排水指示灯 #ledstop：待机指示灯    #zheng/fan：正/反转输出 #alarm：警报    #count：计数剩余值
output count,mode,inlet,drain;//循环计数器，工作模式（洗、漂洗、脱水），进水，排水

reg ledfan,ledstop,ledzheng,ledinlet,leddrain,zheng,fan,alarm;
reg [1:0] mode; //mode[0]：未指定，mode[1]：洗，mode[2]：漂洗，mode[3]：脱水
reg [1:0] c_s,n_s; //电机状态机
reg [3:0] time_t,time_c;
reg [5:0] count;

parameter S0 = 2'b00;   //待机状态
parameter S1 = 2'b01;   //正转状态
parameter S2 = 2'b10;   //待机状态
parameter S3 = 2'b11;   //反转状态


always @(negedge select) begin
    if (!select) begin
        mode <= mode + 2'b01;
        
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
        mode <= 2'b01;
        count <= 6'b000000;
        time_c <= time_t;
        alarm  <= 0;
    end
    else if (time_c == 0) begin //洗衣流程结束
        n_s <= S0;
        mode <= 2'b01;
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