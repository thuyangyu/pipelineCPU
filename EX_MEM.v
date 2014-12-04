//EX_MEM
module EX_MEM(
		input CLK,
		//input
		input [1:0] writeSpecRegIn,
		input memtoRegIn,
		input regWriteIn,
		input [1:0] memReadIn,
		input [1:0] memWriteIn,
		input branchIn,
		input [15:0] PCIn,
		
		input zerobitIn,
		input [15:0] ALUResultIn,
		input [15:0] dataIn,
		input [2:0] registerToWriteIdIn,

		//output
		output [1:0] writeSpecRegOut,
		output memtoRegOut,
		output regWriteOut,
		output [1:0] memReadOut,
		output [1:0] memWriteOut,
		output branchOut,
		output [15:0] PCOut,

		output [15:0] ALUResultOut,
		output zerobitOut,
		output [15:0] dataOut,
		output [2:0] registerToWriteId
	);
	
	always @ (CLK)
		begin
			writeSpecRegOut <= writeSpecRegIn;
			memtoRegOut <= memtoRegIn;
			regWriteOut <= regWriteIn;
			memReadOut <= memReadIn;
			memWriteOut <= memWriteIn;
			branchOut <= branchIn;
			PCOut <= PCIn;
			
			ALUResultOut <= ALUResultIn;
			zerobitOut <= zerobitIn;
			dataOut <= dataIn;
			registerToWriteId <= registerToWriteIdIn;
		
		end
	endmodule