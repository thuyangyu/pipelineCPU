//EX_MEM
module EX_MEM(
		input CLK,
		input RST,
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
		output reg [1:0] writeSpecRegOut,
		output reg memtoRegOut,
		output reg regWriteOut,
		output reg [1:0] memReadOut,
		output reg [1:0] memWriteOut,
		output reg branchOut,
		output reg [15:0] PCOut,
              
		output reg [15:0] ALUResultOut,
		output reg zerobitOut,
		output reg [15:0] dataOut,
		output reg [2:0] registerToWriteId
	);
	
	always @ (posedge CLK, negedge RST)
		if(!RST)
		begin
			writeSpecRegOut <= 2'b0;
			memtoRegOut <= 1'b0;
			regWriteOut <= 1'b0;
			memReadOut <= 2'b0;
			memWriteOut <= 2'b0;
			branchOut <= 1'b0;
			PCOut <= 16'b0;
			
			ALUResultOut <= 16'b0;
			zerobitOut <= 1'b0;
			dataOut <= 16'b0;
			registerToWriteId <= 3'b0;
		
		end
		else
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