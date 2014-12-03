//IF_ID
module IF_ID(
	input CLK,
	input [15:0] PCIn, 									//input
	input [15:0] instructionIn,      				//input
	output reg [15:0] PCOut,			   			//output
	output reg [15:0] instructionOut  		//output
	);
	
	always @ (posedge CLK)
	begin
		PCOut[15:0] <= PCIn[15:0];
		instructionOut[15:0] <= instructionIn[15:0];
	end
	
endmodule
		
		