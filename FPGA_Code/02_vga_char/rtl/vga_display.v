module vga_display(
    input             vga_clk,                  //VGA驱动时钟
    input             sys_rst_n,                //复位信号
    
    input      [ 9:0] pixel_xpos,               //像素点横坐标
    input      [ 9:0] pixel_ypos,               //像素点纵坐标    
    output     [23:0] pixel_data                //像素点数据
    ); 

parameter  H_DISP = 10'd640;                    //分辨率——行
parameter  V_DISP = 10'd480;                    //分辨率——列
localparam WHITE  = 24'b11111111_11111111_11111111;     //RGB565 白色
localparam BLACK  = 24'b00000000_00000000_00000000;     //RGB565 黑色
localparam RED    = 24'b11111111_00000000_00000000;     //RGB565 红色
localparam GREEN  = 24'b00000000_11111111_00000000;     //RGB565 绿色
localparam BLUE   = 24'b00000000_00000000_11111111;     //RGB565 蓝色
    
//*****************************************************
//**                    main code
//*****************************************************

wire [23:0] data;
wire        out_en;

assign  pixel_data = out_en ? data:BLACK ;

char_show u_char_show(
    .clk                (vga_clk),
    .rst_n              (sys_rst_n),

    .pixel_xpos         (pixel_xpos),               //像素点横坐标
    .pixel_ypos         (pixel_ypos),               //像素点纵坐标    
    .pixel_data         (data),               //像素点数据
    .out_en             (out_en)
);

endmodule 