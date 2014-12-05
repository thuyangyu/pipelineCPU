//ID_EX
module ID_EX (
		input CLK,
		input RST,
		input [15:0] PCIn, 								//input
		input [15:0] inData1,    						//input
		input [15:0] inData2,
		input [2:0] inRx,
		input [2:0] inRy,
		input [2:0] inRz,
		input [15:0] inExtendedImmediate,
		
		input [1:0]writeSpecRegIn,
		input memtoRegIn,
		input regWriteIn, 
		input [1:0] memReadIn,
		input [1:0] memWriteIn,  //mux before it
		input jumpIn,
		input RxToMemIn,
		input [3:0] ALUOpIn,
		input [1:0] ALUSrc1In,
		input [1:0] ALUSrc2In,
		input [1:0] regDstIn,
		input branchIn,
		input [1:0] readSpecRegIn,
		
		output reg [1:0] writeSpecRegOut,
		output reg memtoRegOut,
		output reg regWriteOut,
		output reg [1:0] memReadOut,
		output reg [1:0] memWriteOut,
		output reg jumpOut,
		output reg RxToMemOut,
		output reg [3:0] ALUOpOut,
		output reg [1:0] ALUSrc1Out,
		output reg [1:0] ALUSrc2Out,
		output reg [1:0] regDstOut,
		output reg branchOut,
		output reg [1:0]readSpecRegOut,
		
		output reg [15:0] PCOut,				//output
		output reg [15:0] outData1,
		output reg [15:0] outData2,
		output reg [15:0] outExtendedImmediate,
		output reg [2:0] outRx,
		output reg [2:0] outRy,
		output reg [2:0] outRz
	); 
	
	always @ (posedge CLK, negedge RST)
	if(!RST)
	begin
		PCOut <= 16'b0;
		outData1 <= 16'b0;
		outData2 <= 16'b0;
		outExtendedImmediate <= 16'b0;
		outRx <= 3'b0;
		outRy <= 3'b0;
		outRz <= 3'b0;
		
		writeSpecRegOut <= 2'b0;
		memtoRegOut <= 1'b0;
		regWriteOut <= 1'b0;
		memReadOut <= 2'b0;
		memWriteOut <= 2'b0;
		jumpOut <= 1'b0;
		RxToMemOut <= 1'b0;
	    ALUOpOut <= 4'b0;
	    ALUSrc1Out <= 2'b0;
	    ALUSrc2Out <= 2'b0;
	    regDstOut <= 2'b0;
	    branchOut <= 1'b0;
	    readSpecRegOut <= 2'b0;
	end
	else
	begin
		PCOut <= PCIn;
		outData1 <= inData1;
		outData2 <= inData2;
		outExtendedImmediate <= inExtendedImmediate;
		outRx <= inRx;
		outRy <= inRy;
		outRz <= inRz;
		
		writeSpecRegOut <= writeSpecRegIn;
		memtoRegOut <= memtoRegIn;
		regWriteOut <= regWriteIn;
		memReadOut <= memReadIn;
		memWriteOut <= memWriteIn;
		jumpOut <= jumpIn;
		RxToMemOut <= RxToMemIn;
	    ALUOpOut <= ALUOpIn;
	    ALUSrc1Out <= ALUSrc1In;
	    ALUSrc2Out <= ALUSrc2In;
	    regDstOut <= regDstIn;
	    branchOut <= branchIn;
	    readSpecRegOut <= readSpecRegIn;
	end
endmodule