module rgb2hsv(
input [7:0] R,
input [7:0] G,
input [7:0] B,

output  reg [7:0] H,
output  reg  [7:0] S,
output  wire [7:0] V
    );

wire [7:0] max;
wire [7:0] min;
wire [7:0] max_z;
wire [7:0] min_z;
wire [7:0] dif;
assign max = max_z>B ? max_z:B;
assign min = min_z<B ? min_z:B;
assign max_z = R>G ? R:G;
assign min_z = R<G ? R:G;
assign V = max;
assign dif = max-min;
always@(*)begin
	if(max == 0)
		S = 8'd0;
	else
		S = (16'd255*dif)/max;
end

reg [15:0] H1;
reg [15:0] H1_1;
reg [15:0] H1_2;
reg sag=0;
always@(*)begin
	if(max == min) begin
		H1 = 16'd0;
		sag = 1'b0;
	end
	else if(max == R) begin
		if(G<B)begin
			H1 = (16'd60*(B-G))/dif;
			sag = 1'b1;
			end
		else begin
			H1 = (16'd60*(G-B))/dif;
			sag = 1'b0;
			end
	end
	else if(max == G) begin
		if(B<R) begin
			H1_1 = (16'd60*(R-B))/dif;
			H1 =  H1_1< 16'd120 ? (16'd120-H1_1):(H1_1-16'd120);
			sag = H1_1< 16'd120 ? 1'b0:1'b1;
			end
		else begin
			H1 = 16'd120+(16'd60*(B-R))/dif;
			sag = 1'b0;
			end
	end
	else begin
		if(R<G)begin
			H1_2 = (16'd60*(G-R))/dif;
			H1 = H1_2< 16'd240 ? (16'd240-H1_2):(H1_2-16'd240);
			sag = H1_2< 16'd240 ? 1'b0:1'b1;
			end
		else begin
			H1 = 16'd240+(16'd60*(R-G))/dif;
			sag = 1'b0;
			end
	end
end

always@(H1)begin
	if(sag)
		H = (16'd360-H1)/2;
	else 
		H = H1/2;
end

endmodule
