module vga_char(
    input           sys_clk     ,   //系统时钟
    input           sys_rst_n   ,   //复位信号
    //VGA接口                          
    output          vga_clk     ,   //vga时钟
    output          vga_blk     ,   //消影信号
    output          vga_hs      ,   //行同步信号
    output          vga_vs      ,   //场同步信号
    output  [23:0]  vga_rgb         //红绿蓝三原色输出 
    ); 

//wire define
wire         vga_clk_25M;         //PLL分频得到25Mhz时钟
wire         locked;              //PLL输出稳定信号
wire         rst_n;               //内部复位信号
wire [23:0]  pixel_data;          //像素点数据
wire [ 9:0]  pixel_xpos;          //像素点横坐标
wire [ 9:0]  pixel_ypos;          //像素点纵坐标    
    
//*****************************************************
//**                    main code
//***************************************************** 
//待PLL输出稳定之后，停止复位
assign rst_n = sys_rst_n && locked;
assign vga_clk = vga_clk_25M;
   
//时钟分频模块
pll u_pll(
	.areset         (~sys_rst_n),
	.inclk0         (sys_clk),
	.c0             (vga_clk_25M),
	.locked         (locked)
    );

vga_driver u_vga_driver(
    .vga_clk        (vga_clk_25M),    
    .sys_rst_n      (rst_n),    

    .vga_blk        (vga_blk),
    .vga_hs         (vga_hs),       
    .vga_vs         (vga_vs),       
    .vga_rgb        (vga_rgb),      
    
    .pixel_data     (pixel_data), 
    .pixel_xpos     (pixel_xpos), 
    .pixel_ypos     (pixel_ypos)
    ); 
    
vga_display u_vga_display(
    .vga_clk        (vga_clk_25M),
    .sys_rst_n      (rst_n),
    
    .pixel_xpos     (pixel_xpos),
    .pixel_ypos     (pixel_ypos),
    .pixel_data     (pixel_data)
    );   
    
endmodule 