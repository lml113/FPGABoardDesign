module AD_FFT_top(
input       sys_clk,        //系统时钟50MHz
input       sys_rst,        //系统复位

//AD9266接口，采样延迟7ns
input           BTR,        //通道二，超出量程标志
input   [11:0]  BD,         //12位AD数据
output          BCLK,       //采样时钟，不超过65MHz

input           ATR,        //通道一，超出量程标志
input   [11:0]  AD,         //数据
output          ACLK       //时钟

);
//define reg

//define wire
wire            locked;     //PLL标示位，高电平为已完成
wire    [11:0]  Adata;      //读取出来的AD1数据
wire    [11:0]  Bdata;      //读取出来的AD2数据
wire            rst_n;      //PLL配置好后，为高
wire            clk;        //相位与ACLK、BCLK相差7ns，读AD数据时钟

assign rst_n = sys_rst & locked;


PLL u_Pll(
	.areset         (~sys_rst),
	.inclk0         (sys_clk),
	.c0             (ACLK),
	.c1             (BCLK),
	.c2             (clk),
	.locked         (locked)
);

AD1 u_AD1(
    .reset          (rst_n),        //系统复位
    .ACLK           (clk),          //采样时钟，不超过65MHz
    .ATR            (ATR),          //通道二，超出量程标志
    .AD             (AD),           //12位AD数据

    .Adata          (Adata)         //输出AD1采集的数据
);

AD2 u_AD2(
    .reset          (rst_n),        //系统复位
    .BCLK           (clk),          //采样时钟，不超过65MHz
    .BTR            (BTR),          //通道二，超出量程标志
    .BD             (BD),           //12位AD数据

    .Bdata          (Bdata)         //输出AD1采集的数据
);

endmodule
