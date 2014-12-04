//MEM_WB
module MEM_WB(
	input CLK,
	//input
	input [1:0] writeSpecRegIn,
	input memtoRegIn,
	input regWriteIn,
	input [15:0] dataIn,
	input [15:0] ALUResultIn,
	input [2:0] registerToWriteIdIn,
	//output
	output reg [1:0] writeSpecRegOut,
	output reg memtoRegOut,
	output reg regWriteOut,
	output reg [15:0] dataOut,
	output reg [15:0] ALUResultOut,
	output reg [2:0] outRegisterToWriteId
);

always @ (posedge CLK)
	begin
		writeSpecRegOut <= writeSpecRegIn;
		memtoRegOut <= memtoRegIn;
		regWriteOut <= regWriteIn;
		dataOut <= dataIn;
		ALUResultOut <= ALUResultIn;
		outRegisterToWriteId <= registerToWriteIdIn;
	
	
	end
	
endmodule