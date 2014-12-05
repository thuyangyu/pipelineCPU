//IF_ID
module IF_ID(
	input CLK,
	input RST,
	input [15:0] PCIn, 									//input
	input [15:0] instructionIn,      				//input
	output reg [15:0] PCOut,			   			//output
	output reg [15:0] instructionOut  		//output
	);
	
	always @ (posedge CLK, negedge RST)
		if(!RST)
			begin
				PCOut[15:0] <= 16'b0;
				instructionOut[15:0] <= 16'b0;
			end
		else
			begin
				PCOut[15:0] <= PCIn[15:0];
				instructionOut[15:0] <= instructionIn[15:0];
			end
endmodule
		
		