module vga_display(
    input             vga_clk,                  //VGA驱动时钟
    input             sys_rst_n,                //复位信号
    
    input      [ 9:0] pixel_xpos,               //像素点横坐标
    input      [ 9:0] pixel_ypos,               //像素点纵坐标    
    output reg [23:0] pixel_data                //像素点数据
    );    
    
parameter  H_DISP = 10'd640;                    //分辨率——行
parameter  V_DISP = 10'd480;                    //分辨率——列
localparam WHITE  = 23'b11111111_11111111_11111111;     //RGB565 白色
localparam BLACK  = 23'b00000000_00000000_00000000;     //RGB565 黑色
localparam RED    = 23'b11111111_00000000_00000000;     //RGB565 红色
localparam GREEN  = 23'b00000000_11111111_00000000;     //RGB565 绿色
localparam BLUE   = 23'b00000000_00000000_11111111;     //RGB565 蓝色
    
//*****************************************************
//**                    main code
//*****************************************************
//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)
        pixel_data <= 23'd0;                                  
    else begin
        if((pixel_xpos >= 0) && (pixel_xpos <= (H_DISP/5)*1))                                              
            pixel_data <= WHITE;                               
        else if((pixel_xpos >= (H_DISP/5)*1) && (pixel_xpos < (H_DISP/5)*2))
            pixel_data <= BLACK;  
        else if((pixel_xpos >= (H_DISP/5)*2) && (pixel_xpos < (H_DISP/5)*3))
            pixel_data <= RED;  
        else if((pixel_xpos >= (H_DISP/5)*3) && (pixel_xpos < (H_DISP/5)*4))
            pixel_data <= GREEN;  
        else 
            pixel_data <= BLUE;  
    end
end

endmodule 