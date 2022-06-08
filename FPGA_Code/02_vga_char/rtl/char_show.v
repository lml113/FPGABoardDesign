module char_show(
    input             clk,
    input             rst_n,

    input      [ 9:0] pixel_xpos,               //像素点横坐标
    input      [ 9:0] pixel_ypos,               //像素点纵坐标    
    output     [23:0] pixel_data,               //像素点数据
    output            out_en
);

//显示hello world   18,15,22,22,25,0,33,25,28,22,14
parameter  length = 11;                          //默认显示的字符串长度
parameter  char_x = 320;                        //默认显示x起点
parameter  char_y = 240;                        //默认显示y起点
parameter  char_color  = 24'b11111111_00000000_00000000;     //默认红色
parameter  char_color_b  = 24'b11111111_11111111_11111111;   //默认背景 白色
////显示hello world   18,15,
reg  [5:0] char_dis[0:length-1];
initial begin
    $readmemh("ram.txt",char_dis);
end

wire [5:0]      address;
wire [127:0]    q;

reg [2:0]   cnt=0;
reg [7:0]   char_b=0;
wire[7:0]   char_b_x;
wire[3:0]   char_b_y;

assign out_en = (pixel_ypos>=char_y&&pixel_ypos<(char_y+16)&&pixel_xpos>=char_x&&(pixel_xpos<char_x+length*8)) ? 1'b1:1'b0;

assign char_b_y = out_en ?(pixel_ypos-char_y):4'd0 ;
assign address = char_dis[char_b];
assign char_b_x = out_en ? (8'd127-(char_b_y*8+pixel_xpos-char_x-char_b*8)) : 8'd0 ;
assign pixel_data = q[char_b_x]? char_color:char_color_b;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt<=3'b0;
    else begin
        if(out_en)begin
            if(cnt==3'd7)begin
                cnt<=3'd0;
                if(char_b==length-1'b1)
                    char_b<=8'd0;
                else
                    char_b<=char_b+1'b1;
            end
            else
                cnt<=cnt+1'b1;
        end
        else begin
            cnt<=4'b0;
        end
    end
end

char u_char(
	.address        (address),
	.clock          (clk),
	.q              (q) 
    );

endmodule
