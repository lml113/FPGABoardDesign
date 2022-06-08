module uart_recv(
input               clk        ,    //系统时钟
input               rst_n      ,    //系统复位，低电平有效

input               uart_rx    ,    //UART接收端口
output reg          uart_done  ,    //接收一帧数据完成标志信号
output reg [7:0]    uart_data       //接收的数据
);

//parameter define
parameter  CLK_FREQ = 50000000;     //系统的时钟频率
parameter  UART_BPS = 9600;         //串口波特率
//为得到指定波特率，对系统时钟计数BPS_CNT次
localparam BPS_CNT = CLK_FREQ/UART_BPS;

//reg define
reg         uart_rx_0,uart_rx_1;
reg         rx_flag=0;          //接收过程标志信号
reg [15:0]  clk_cnt;            //系统时钟计数器
reg [4:0]   rx_cnt;             //接收数据计数器
reg [7:0]   rx_data;            //接收数据寄存器
//wire define
wire        start_flag;

//********************main code********************
//捕获接收端口下降沿(起始位)，得到一个时钟周期的脉冲信号
assign  start_flag = uart_rx_1 & (~uart_rx_0);  

//对UART接收端口的数据延迟两个时钟周期
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        uart_rx_0<=0;
        uart_rx_1<=0;
    end
    else begin
        uart_rx_0<=uart_rx;
        uart_rx_1<=uart_rx_0;
    end
end
//当脉冲信号start_flag到达时，进入接收过程 
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rx_flag<=0;
    end
    else begin
        if(start_flag)
            rx_flag<=1;
        else if((rx_cnt == 4'd9)&&(clk_cnt == BPS_CNT/2))
            rx_flag<=0;
        else 
            rx_flag<=rx_flag;
    end
end
//进入接收过程后，启动系统时钟计数器与接收数据计数器
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        clk_cnt<=16'd0;
        rx_cnt<=4'd0;
    end
    else begin
        if(rx_flag)begin
            if(clk_cnt==BPS_CNT-1)begin
                clk_cnt<=16'd0;
                rx_cnt<=rx_cnt+1'b1;
            end
            else begin
                clk_cnt<=clk_cnt+1'b1;
                rx_cnt<=rx_cnt;
            end
        end
        else begin
            clk_cnt<=16'd0;
            rx_cnt<=4'd0;
        end
    end
end
//根据接收数据计数器来寄存uart接收端口数据
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rx_data<=8'd0;
    end
    else begin
        if(rx_flag)begin
            if(clk_cnt==BPS_CNT/2)begin
                case(rx_cnt)
                    4'd1:rx_data[0]<=uart_rx;
                    4'd2:rx_data[1]<=uart_rx;
                    4'd3:rx_data[2]<=uart_rx;
                    4'd4:rx_data[3]<=uart_rx;
                    4'd5:rx_data[4]<=uart_rx;
                    4'd6:rx_data[5]<=uart_rx;
                    4'd7:rx_data[6]<=uart_rx;
                    4'd8:rx_data[7]<=uart_rx;
                    default:;
                endcase
            end
            else 
                rx_data<=rx_data;
        end
        else
            rx_data<=8'd0;
    end
end

//数据接收完毕后给出标志信号并寄存输出接收到的数据
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        uart_done <= 1'b0;
        uart_data <= 8'd0;
    end
    else begin
        if(rx_cnt==4'd9)begin
            uart_done <= 1'b1;
            uart_data <= rx_data;
        end
        else begin
            uart_done <= 1'b0;
            uart_data <= 8'd0;
        end
    end
end

endmodule
