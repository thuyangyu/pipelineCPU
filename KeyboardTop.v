
module KeyboardTop(
	input CLK,
	input RST,
	output reg [2:0] state,
	inout PS2_CLK,
	inout PS2_DAT
);


wire forward;
wire backward;
wire left;
wire right;
wire up;
wire down;

wire AllSignals;
assign AllSignals = forward | backward | left | right | up | down;

always @ (posedge AllSignals)
begin
	/*if (!RST)
		state[2:0] <= 3'b001;
	else*/
	begin
		
		 if(forward)
		 begin
			  state[2:0] <= 3'b000;
		 end
		 
		 if(backward)
		 begin
			  state[2:0] <= 3'b001;
		 end
		 
		 if(left)
		 begin
			  state[2:0] <= 3'b010;
		 end
		 
		 if(right)
		 begin
			  state[2:0] <= 3'b011;
		 end
		 
		 if(up)
		 begin
			  state[2:0] <= 3'b100;
		 end
		 
		 if(down)
		 begin
			  state[2:0] <= 3'b101;
		 end
	end

end




KeyboardDecoder kd(
	.CLOCK_50(CLK),
	.KEYS(4'b1111),
	
	.forward(forward),
	.backward(backward),
	.left(left),
	.right(right),
	.up(up),
	.down(down),

	//////// PS2 //////////
	.PS2_CLK(PS2_CLK),
	.PS2_DAT(PS2_DAT)
);


endmodule 