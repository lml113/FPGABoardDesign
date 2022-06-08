module uart_top(
input           sys_clk,
input           rst_n,
//UART
input           uart_rx,
output          uart_tx
);

wire        uart_tx_en;         //发送使能信号
wire [7:0]  uart_tx_data;       //发送数据
wire        uart_rx_done;       //接收完成标示
wire [7:0]  uart_rx_data;       //接收数据

uart_send u_uart_send(
    .clk        (sys_clk),      //系统时钟
    .rst_n      (rst_n),        //系统复位，低电平有效

    .uart_en    (uart_tx_en),   //UART发送使能信号
    .uart_data  (uart_tx_data), //待发送数据
    .uart_tx    (uart_tx)       //UART发送端口
);

uart_recv u_uart_recv(
    .clk        (sys_clk),      //系统时钟
    .rst_n      (rst_n),        //系统复位，低电平有效
    
    .uart_rx    (uart_rx),      //UART接收端口
    .uart_done  (uart_rx_done), //接收一帧数据完成标志信号
    .uart_data  (uart_rx_data)     //接收的数据
);
//uart接收数据，发送接受的数据
uart_test u_uart_test(
    .clk         (sys_clk),
    .rst_n       (rst_n),

    .uart_rx_done(uart_rx_done),
    .uart_rx_data(uart_rx_data),
 
    .uart_tx_en  (uart_tx_en),
    .uart_tx_data(uart_tx_data)
);


endmodule
