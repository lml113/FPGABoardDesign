module AD1(
input           reset,          //系统复位
input           ACLK,           //采样时钟，不超过65MHz
input           ATR,            //通道一，超出量程标志
input   [11:0]  AD,             //12位AD数据

output  reg [11:0]  Adata           //AD1采集的数据
);

always@(posedge ACLK or negedge reset)
begin
    if(!reset)
        Adata<=12'd0;
    else 
        Adata<=AD;
end

endmodule
