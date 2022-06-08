module data_top(
input           sys_clk,
input           sys_rst_n,

output reg [7:0]   data_out
);

reg [7:0] data_f [0:9] = {8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7,8'd8,8'd9,8'd10};

reg [7:0] cnt=0;

always@(posedge sys_clk)begin
    if(!sys_rst_n)begin
        cnt<=0;
    end
    else if(cnt==10)
        cnt<=0;
    else 
        cnt<=cnt+1'b1;
end
always@(posedge sys_clk)begin
    if(!sys_rst_n)
        data_out<=8'd0;
    else 
        data_out<=data_f[cnt];
end


endmodule
