module vga_display(
    input               vga_clk,    //VGA驱动时钟
    input               sys_rst_n,  //复位信号
    
    output  [23:0]      pixel_data, //像素点数据
    input   [10:0]      pixel_xpos, //像素点横坐标
    input   [10:0]      pixel_ypos  //像素点纵坐标
);
//wire define
wire                rom_rd_en;      //读ROM使能信号
wire    [23:0]      rom_data;       //ROM输出数据
//reg define
reg  [13:0] rom_addr;                       //读ROM地址
reg         rom_valid;                      //读ROM数据有效信号



//采用1280x1024@60显示器
//parameter define
parameter H_DISP = 11'd1280;    //行有效数据
parameter V_DISP = 11'd1024;     //场有效数据

localparam POS_X  = 10'd590;                //图片区域起始点横坐标
localparam POS_Y  = 10'd462;                //图片区域起始点纵坐标
localparam WIDTH  = 10'd100;                //图片区域宽度
localparam HEIGHT = 10'd100;                //图片区域高度
localparam TOTAL  = 14'd10000;              //图案区域总像素数
//RGB888
localparam WHITE = 24'b11111111_11111111_11111111;      //RGB565 白色
localparam BLACK = 24'b00000000_00000000_00000000;      //RGB565 黑色
localparam REG   = 24'b11111111_00000000_00000000;      //RGB565 红色
localparam GREEN = 24'b00000000_11111111_00000000;      //RGB565 绿色
localparam BLUE  = 24'b00000000_00000000_11111111;      //RGB565 蓝色

//*****************************************************
//**                    main code
//***************************************************** 
//从ROM中读出的图像数据有效时，将其输出显示
assign pixel_data = rom_valid ? rom_data : BLACK; 
//当前像素点坐标位于图案显示区域内时，读ROM使能信号拉高
assign rom_rd_en = (pixel_xpos >= POS_X) && (pixel_xpos < POS_X + WIDTH)
                    && (pixel_ypos >= POS_Y) && (pixel_ypos < POS_Y + HEIGHT)
                     ? 1'b1 : 1'b0;

//控制读地址
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        rom_addr   <= 14'd0;
    end
    else if(rom_rd_en) begin
        if(rom_addr < TOTAL - 1'b1)
            rom_addr <= rom_addr + 1'b1;    //每次读ROM操作后，读地址加1
        else
            rom_addr <= 1'b0;               //读到ROM末地址后，从首地址重新开始读操作
    end
    else
        rom_addr <= rom_addr;
end

//从发出读使能到ROM输出有效数据存在一个时钟周期的延时
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) 
        rom_valid <= 1'b0;
    else
        rom_valid <= rom_rd_en;
end

rom u_rom(
	.address     (rom_addr),
	.clock       (vga_clk),
    .rden        (rom_rd_en),
	.q           (rom_data)
    );



endmodule
