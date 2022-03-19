module DA_8b(
//AD9708接口——8位高速DA转换芯片，最大转换速度为125MSPS
//数据在时钟的上升沿锁存，因此我们可以在时钟的下降沿发送数据
input           DACLK,      //DA时钟，上升沿触发锁存
input           reset,      //
input   [7:0]   data,       //

output  reg [7:0]   DA           //8位DA数据
);

always@(negedge DACLK or negedge reset)
begin
    if(!reset)
        DA<=8'd0;
    else
        DA<=data;
end

endmodule
