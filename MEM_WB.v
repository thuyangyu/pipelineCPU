//MEM_WB
module MEM_WB(
	input CLK,
	input RST,
	input freeze,
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

always @ (posedge CLK, negedge RST)
	if(!RST)
	begin
		if(freeze == 1'b0)
		begin
		writeSpecRegOut <= 2'b0;
		memtoRegOut <= 1'b0;
		regWriteOut <= 1'b0;
		dataOut <= 16'b0;
		ALUResultOut <= 16'b0;
		outRegisterToWriteId <= 3'b0;
		end
	end
	else
	begin
	if(freeze == 1'b0)
		begin
		writeSpecRegOut <= writeSpecRegIn;
		memtoRegOut <= memtoRegIn;
		regWriteOut <= regWriteIn;
		dataOut <= dataIn;
		ALUResultOut <= ALUResultIn;
		outRegisterToWriteId <= registerToWriteIdIn;
		end
	end
endmodule
