module uart_test(
input               clk,
input               rst_n,
//uart_rx
input               uart_rx_done,
input      [7:0]    uart_rx_data,
//uart_tx
output              uart_tx_en,
output     [7:0]    uart_tx_data
);

//reg define

//wire define


//********************main code********************

assign  uart_tx_en = uart_rx_done;
assign  uart_tx_data = uart_rx_data;

endmodule
