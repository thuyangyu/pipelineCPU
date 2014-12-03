//ID_EX
module ID_EX (
		input CLK,
		input PCIn, 								//input
		input inData1,    						//input
		input inData2,
		input inRx,
		input inRy,
		input inRz,
		input inExtendedImmediate,
		
		input writeSpecRegIn,
		input memtoRegIn,
		input regWriteIn, 
		input memReadIn,
		input memWriteIn,  //mux before it
		input jumpIn,
		input RxToMemIn,
		input ALUOpIn,
		input ALUSrc1In,
		input ALUSrc2In,
		input regDstIn,
		input branchIn,
		input readSpecRegIn,
		
		output reg writeSpecRegOut,
		output reg memtoRegOut,
		output reg regWriteOut,
		output reg memReadOut,
		output reg memWriteOut,
		output reg jumpOut,
		output reg RxToMemOut,
		output reg ALUOpOut,
		output reg ALUSrc1Out,
		output reg ALUSrc2Out,
		output reg regDstOut,
		output reg branchOut,
		output reg readSpecRegOut,
		
		output reg PCOut,				//output
		output reg outData1,
		output reg outData2,
		output reg outExtendedImmediate,
		output reg outRx,
		output reg outRy,
		output reg outRz
	); 
	
	always @ (CLK)
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
	    ALUSrc1Out,
	    ALUSrc2Out,
	    regDstOut,
	    branchOut,
	    readSpecRegOut,
	
	end
	
endmodule