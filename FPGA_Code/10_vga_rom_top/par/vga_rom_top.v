module vga_rom_top(
    input           sys_rst,
    input           sys_clk,

    //VGA接口
    output          vga_clk,    //VGA驱动时钟
    
    output          vga_hs,     //行同步信号
    output          vga_vs,     //场同步信号
    output          vga_blk,    //消影信号
    output  [23:0]  vga_rgb     //红绿蓝三原色输出
);
//wire define
wire                vga_clk_100MHz;
wire    [23:0]      pixel_data;
wire    [10:0]      pixel_xpos;
wire    [10:0]      pixel_ypos;

wire                locked_w;
wire                sys_rst_n;

//*****************************************************
//**                    main code
//***************************************************** 
//待PLL输出稳定之后，停止复位
assign sys_rst_n = sys_rst && locked_w;
assign vga_clk = vga_clk_100MHz;

PLL u_PLL(
	.areset     (~sys_rst),
	.inclk0     (sys_clk),
	.c0         (vga_clk_100MHz),
	.locked     (locked_w)
    );
    
vga_diver u_vga_diver(
    .vga_clk        (vga_clk_100MHz),    //VGA驱动时钟
    .sys_rst_n      (sys_rst_n),        //复位信号
    //VGA接口
    .vga_hs         (vga_hs),           //行同步信号
    .vga_vs         (vga_vs),           //场同步信号
    .vga_blk        (vga_blk),          //消影信号
    .vga_rgb        (vga_rgb),          //红绿蓝三原色输出
    
    .pixel_data     (pixel_data),       //像素点数据
    .pixel_xpos     (pixel_xpos),       //像素点横坐标
    .pixel_ypos     (pixel_ypos)        //像素点纵坐标
);
vga_display u_vga_display(
    .vga_clk        (vga_clk_100MHz),    //VGA驱动时钟
    .sys_rst_n      (sys_rst_n),        //复位信号

    .pixel_data     (pixel_data),       //像素点数据
    .pixel_xpos     (pixel_xpos),       //像素点横坐标
    .pixel_ypos     (pixel_ypos)        //像素点纵坐标
);

endmodule
