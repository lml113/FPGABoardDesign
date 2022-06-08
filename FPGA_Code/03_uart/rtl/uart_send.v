module uart_send(
input               clk        ,    //系统时钟
input               rst_n      ,    //系统复位，低电平有效

input               uart_en    ,    //UART发送使能信号
input      [7:0]    uart_data  ,    //待发送数据
output reg          uart_tx         //UART发送端口
);
//parameter define
parameter  CLK_FREQ = 50000000;     //系统的时钟频率
parameter  UART_BPS = 9600;         //串口波特率
//为得到指定波特率，对系统时钟计数BPS_CNT次
localparam BPS_CNT = CLK_FREQ/UART_BPS;

//reg define
reg         uart_en_0,uart_en_1;
reg [15:0]  clk_cnt;                //系统时钟计数器
reg [4:0]   tx_cnt;                 //发送数据计数器
reg         tx_flag=0;              //发送标志信号
reg [7:0]   tx_data;                //发送过程的数据

//wire define
wire        uart_en_flag;

//********************main code********************
//捕捉发送使能上升沿
assign uart_en_flag = (~uart_en_1)&uart_en_0;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        uart_en_0<=0;
        uart_en_1<=0;
    end
    else begin
        uart_en_0<=uart_en;
        uart_en_1<=uart_en_0;
    end
end
//当脉冲信号en_flag到达时,寄存待发送的数据，并进入发送过程
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        tx_flag<=0;
        tx_data<=8'd0;
    end
    else begin
        if(uart_en_flag)begin
            tx_flag<=1;
            tx_data<=uart_data;
        end
        else if((tx_cnt == 4'd9)&&(clk_cnt == BPS_CNT/2))begin
            tx_flag<=0;
            tx_data<=8'd0;
        end
        else begin
            tx_flag<=tx_flag;
            tx_data<=tx_data;
        end
    end
end
//进入发送过程后，启动系统时钟计数器与发送数据计数器
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        tx_cnt<=4'd0;
        clk_cnt<=16'd0;
    end
    else begin
        if(tx_flag)begin
            if(clk_cnt<BPS_CNT-1)begin
                clk_cnt<=clk_cnt+1'b1;
                tx_cnt<=tx_cnt;
            end
            else begin
                clk_cnt<=16'd0;
                tx_cnt<=tx_cnt+1'b1;
            end
        end
        else begin
            tx_cnt<=4'd0;
            clk_cnt<=16'd0;
        end
    end
end

//根据发送数据计数器来给uart发送端口赋值
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        uart_tx<=1'b1;
    else begin
        if(tx_flag)begin
            case(tx_cnt)
                4'd0: uart_tx <= 1'b0;         //起始位 
                4'd1: uart_tx <= tx_data[0];   //数据位最低位
                4'd2: uart_tx <= tx_data[1];
                4'd3: uart_tx <= tx_data[2];
                4'd4: uart_tx <= tx_data[3];
                4'd5: uart_tx <= tx_data[4];
                4'd6: uart_tx <= tx_data[5];
                4'd7: uart_tx <= tx_data[6];
                4'd8: uart_tx <= tx_data[7];   //数据位最高位
                4'd9: uart_tx <= 1'b1;         //停止位
                default:;
            endcase
        end
        else
            uart_tx<=1'b1;              //空闲时发送端口为高电平
    end
end


endmodule
