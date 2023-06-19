module xiyiji(select,ledzheng,ledfan,ledstop,ledinlet,leddrain,leddry,clk,zheng,fan,mode_c,inlet,drain,dry,start,alarm,emergency,count,rst,     c_s,time_c,enable,tmp);
input select,clk,start,emergency,rst;  //#select：选择工作模式，#clk：秒时钟，#start：启动洗衣机，#emergency：急停模式，#rst：复位
output ledfan,ledzheng,ledstop,ledinlet,leddrain,leddry,zheng,fan,alarm; //#ledfan：反转指示灯 #ledzheng：正转指示灯 #ledinlet：进水指示灯 #leddrain：排水指示灯 #ledstop：待机指示灯 #zheng/fan：正/反转输出 #alarm：警报    #count：计数剩余值
output count,mode_c,inlet,drain,dry;//循环计数器，工作模式（洗、漂洗、脱水），进水，排水
output c_s,time_c,enable,tmp; //调试用

reg ledfan,ledstop,ledzheng,ledinlet,leddrain,leddry,zheng,fan,inlet,drain,dry,alarm;
reg enable;
reg [1:0] tmp;
reg [1:0] mode_t,mode_c; //mode[0]：未指定，mode[1]：洗，mode[2]：漂洗，mode[3]：脱水
reg [3:0] c_s,n_s; //模式状态机，电机状态机
reg [3:0] time_t,time_c;
reg [5:0] count;

parameter S0 = 4'b0000;   //待机状态
parameter S1 = 4'b0001;   //正转状态
parameter S2 = 4'b0010;   //待机状态
parameter S3 = 4'b0011;   //反转状态
parameter S4 = 4'b0100;   //进水状态
parameter S5 = 4'b0101;   //排水状态
parameter S6 = 4'b0110;   //脱水状态

parameter M0 = 2'b00;   //模式0，待机
parameter M1 = 2'b01;   //模式1，漂洗
parameter M2 = 2'b10;   //模式2，洗涤
parameter M3 = 2'b11;   //模式3，脱水

always @(negedge select) begin
    if(!select && mode_t == M3) begin
        mode_t <= M0;
    end
    if (!select) begin
        mode_t <= mode_t + 2'b01;
    end
end

always@(negedge emergency) begin
    if (emergency == 0) begin //紧急状态
        inlet <= 0;
        drain <= 0;
        dry <= 0;
        zheng <= 0;
        fan <= 0;
        ledinlet <= 0;
        leddrain <= 0;
        leddry <= 0;
        ledzheng <= 0;
        ledfan <= 0;
        ledstop <= 1;
    end
end

always@(posedge clk or negedge rst) begin   //D触发器模块
    if (!rst)
        c_s <= S0;
    else
        c_s <= n_s;
end

always @(mode_c or time_c) begin
    case (mode_c)
        M0:begin //未指定，意味待机状态
            time_t <= 4'b0000;
        end
        M1:begin //漂洗，电机状态循环15次
            time_t <= 4'b1111;
        end
        M2:begin //洗涤（洗，漂洗，脱水）
            time_t <= 4'b0111;  //洗，电机状态循环7次
            if (time_c == 4'b0000 && tmp == 0) begin
                time_t <= 4'b1111;
                enable <= 0;
                tmp <= 1;
            end
            if (time_c == 4'b0000 && tmp == 1) begin
                n_s <= S5;
                time_t <= 4'b0000; //洗循环清零
                enable <= 0;
                tmp <= 2;
            end
            if (tmp == 2) begin
                time_t <= 4'b0000; //洗循环清零
                enable <= 0;
                tmp <=3;
            end
        end
        M3:begin    //脱水
            n_s <= S5;
            time_t <= 4'b0000; //洗循环清零
            enable <= 0;
            tmp <=3;
        end
    endcase
end

always @(count or c_s) begin    //n_s模块
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
        S4:begin    //进水
            if (count == 6'b111100) begin //持续60秒
                count <= 6'b000000;    //计数器清零
                n_s <= S0;
            end
        end
        S5:begin    //排水
            if (count == 6'b111100) begin //持续60秒
                count <= 6'b000000;    //计数器清零
                n_s <= S6;
            end
        end
        S6:begin    //脱水
            if (count == 6'b111100) begin //持续60秒
                count <= 6'b000000;    //计数器清零
                n_s <= S0;
            end
        end
        default:begin
            n_s <= S0;
            mode_t <= 2'b00;
            time_t <= 4'b0000;
        end
    endcase
end

always@(posedge clk or negedge enable) begin
    if (!enable) begin   //刷新状态使能
        time_c <= time_t;
        mode_c <= mode_t;
        enable <= 1;
    end
end

always@(posedge clk) begin   //c_s模块
    if (start == 0) begin   //未按下启动建，始终保持初始化状态
        n_s <= S0;
        count <= 6'b000000;
        tmp <= 0;
        time_c <= time_t;
        mode_c <= mode_t;
        alarm  <= 0;
        enable <= 1;
    end
    else if (time_c == 0 && tmp == 3) begin //洗衣流程结束
        n_s <= S0;
        mode_t <= 2'b00;
        count <= 6'b000000;
        alarm <= 1;
    end
    else count <= count + 6'b000001; //计数器秒加一

    case (c_s)
        S0:begin
            inlet <= 0;
            drain <= 0;
            dry <= 0;
            zheng <= 0;
            fan <=0;
            ledinlet <= 0;
            leddrain <= 0;
            leddry <= 0;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 1;
        end
        S1:begin
            inlet <= 0;
            drain <= 0;
            dry <=0;
            zheng <= 1;
            fan <= 0;
            ledinlet <= 0;
            leddrain <= 0;
            leddry <= 0;
            ledzheng <= 1;
            ledfan <= 0;
            ledstop <= 0;
        end
        S2:begin
            inlet <= 0;
            drain <= 0;
            dry <=0;
            zheng <= 0;
            fan <=0;
            ledinlet <= 0;
            leddrain <= 0;
            leddry <= 0;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 1;
        end
        S3:begin
            inlet <= 0;
            drain <= 0;
            dry <=0;
            zheng <= 0;
            fan <= 1;
            ledinlet <= 0;
            leddrain <= 0;
            leddry <= 0;
            ledzheng <= 0;
            ledfan <= 1;
            ledstop <= 0;
        end
        S4:begin
            inlet <= 1;
            drain <= 0;
            dry <=0;
            zheng <= 0;
            fan <=0;
            ledinlet <= 1;
            leddrain <= 0;
            leddry <= 0;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 0;
        end
        S5:begin
            inlet <= 0;
            drain <= 1;
            dry <=0;
            zheng <= 0;
            fan <=0;
            ledinlet <= 0;
            leddrain <= 1;
            leddry <=0;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 0;
        end
        S6:begin
            inlet <= 0;
            drain <= 1;
            dry <=1;
            zheng <= 0;
            fan <=0;
            ledinlet <= 0;
            leddrain <= 1;
            leddry <=1;
            ledzheng <= 0;
            ledfan <= 0;
            ledstop <= 0;
        end
    endcase
end

endmodule