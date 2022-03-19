module AD2(
input           reset,          //系统复位
input           BCLK,           //采样时钟，不超过65MHz
input           BTR,            //通道二，超出量程标志
input   [11:0]  BD,             //12位AD数据

output  reg [11:0]  Bdata           //AD1采集的数据
);

always@(posedge BCLK or negedge reset)
begin
    if(!reset)
        Bdata<=12'd0;
    else 
        Bdata<=BD;
end

endmodule