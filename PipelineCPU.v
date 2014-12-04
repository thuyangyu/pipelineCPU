module PipelineCPU(
    input CLK;
    input RST;
	
	output ram1OE,
	output ram1WE
	output ram1EN,
	output ram1Addr,
	inout    ram1Data,
    //16 bit address bus
	//16 bit 
)
	//wires before PC
	wire [15:0] next_PC;
	
	//wires after PC
	//1 + 2 + 2 wires
	wire [15:0] PCValue;
	
	wire [15:0] PCPlus;
	wire [15:0] instruction_a_IM;

	wire [15:0] instruction_b_IFID;
	wire [15:0] PC_b_IFID;
	
	//wires after IFID
	//2+3+14+2+3 wires
	wire [15:0] PC_a_IFID;
	wire [15:0] instruction_a_IFID;

	wire PCWrite;
	wire IFIDWrite;
	wire addBubble;
	
	wire [1:0] writeSpecReg_a_Decoder;
	wire memToReg_a_Decoder;
	wire regWrite_a_Decoder;
	wire [1:0] memRead_a_Decoder;
	wire [1:0] memWrite_a_Decoder;
	wire jump_a_Decoder;
	wire RxToMem_a_Decoder;
	wire [3:0] ALUOp_a_Decoder;
	wire [1:0] ALUSrc1_a_Decoder;
	wire [1:0] ALUSrc2_a_Decoder;
	wire [1:0] regDst_a_Decoder;
	wire branch_a_Decoder;
	wire [1:0] readSpecReg_a_Decoder;
	wire [3:0] imSrcSelect;
	
	wire [1:0] memWrite_b_IDEX;
	wire regWrite_b_IDEX;
	
	wire [15:0] outData1_a_Registers;
	wire [15:0] outData2_a_Registers;
	wire [15:0] ExtendedImmediate_a_SE;


	//wires after ID/EX
	//13 + 7 + 2 + 2 + 7
	wire [1:0] writeSpecReg_a_IDEX;
	wire memToReg_a_IDEX;
	wire regWrite_a_IDEX;
	wire [1:0] memRead_a_IDEX;
	wire [1:0] memWrite_a_IDEX;
	wire jump_a_IDEX;
	wire RxToMem_a_IDEX;
	wire [3:0] ALUOp_a_IDEX;
	wire [1:0] ALUSrc1_a_IDEX;
	wire [1:0] ALUSrc2_a_IDEX;
	wire [1:0] regDst_a_IDEX;
	wire branch_a_IDEX;
	wire [1:0] readSpecReg_a_IDEX;
	
	wire [15:0] PC_a_IDEX;
	wire [15:0] outData1_a_IDEX;
	wire [15:0] outData2_a_IDEX;
	wire [15:0] ExtendedImmediate_a_IDEX;
	wire [2:0] Rx_a_IDEX;
	wire [2:0] Ry_a_IDEX;
	wire [2:0] Rz_a_IDEX;
	
	wire [15:0] outData1Decided;
	wire [15:0] outData2Decided;
	wire [15:0] Data1_b_ALU;
	wire [15:0] Data2_b_ALU;
	
	wire regWrite_b_EXMEM;
	wire [1:0] memWrite_b_EXMEM;
	wire [15:0] PC_b_EXMEM;
	wire [15:0] data_b_EXMEM;
	wire [15:0] ALUResult_b_EXMEM;
	wire zerobit_b_EXMEM;
	wire [2:0] registerToWriteId_b_EXMEM;
	
	//wires after EX/MEM
	//5 + 6 + 1 + 1 wires
	wire [1:0] writeSpecReg_a_EXMEM;
	wire memToReg_a_EXMEM;
	wire regWrite_a_EXMEM;
	wire [1:0] memRead_a_EXMEM;
	wire [1:0] memWrite_a_EXMEM;
	
	wire branch_a_EXMEM;
	wire [15:0] PC_a_EXMEM;
	wire zerobit_a_EXMEM;
	wire [15:0] ALUResult_a_EXMEM;
	wire [15:0] data_a_EXMEM;
	wire [2:0] registerToWriteId_a_EXMEM;
	
	wire PCSrc;
	
	wire data_a_MemController;
	
	//wires after MEM/WB
	//3 + 3 + 1 wires
	wire [1:0] writeSpecReg_a_MEMWB;
	wire memToReg_a_MEMWB;
	wire regWrite_a_MEMWB;
	
	wire [15:0] dataOut_a_MEMWB;
	wire [15:0] ALUResult_a_MEMWB;
	wire [3:0] registerToWriteId_a_MEMWB;
	
	wire [15:0] dataToWriteBack;

	//************************************* start attachment
	
	//modules in PC stage
	//PC module
    reg [15:0] PC;
	assign PCValue[15:0] = PC[15:0];
	assign PCPlus[15:0] = PCValue[15:0] + 16'b1;        //temp add 1;
	assign PC_b_IFID[15:0]               = IFIDWrite ? PC_a_IFID[15:0] : PCPlus[15:0];  //mux
	assign instruction_b_IFID[15:0] = IFIDWrite ? instruction_a_IFID[15:0] : ((jump || PCSrc) ? 16b0000_1000_0000_0000 : instruction_a_IM[15:0]);
	
	//Instruction_Memory module
    Instruction_Memory im(
        .CLK(CLK),
        .RST(RST),
        .address(PCValue),
        .instruction(instruction_a_IM)
        ); 
	
	//modules in IFID stage
	//IF_ID
	IF_ID if_id(
		.CLK(CLK),
		.PCIn(PC_b_IFID), 									//input
		.instructionIn(instruction_b_IFID),      //input
		.PCOut(PC_a_IFID),			   				   //output
		.instructionOut(instruction_a_IFID)   //output
		);
	
	//HazardDetector
	module HazardDetector(
    .HD_instruction(instruction_a_IFID),
    .HD_memRead_a_IDEX(memRead_a_IDEX),
    .HD_Rx_a_IDEX(Rx_a_IDEX),
    .HD_Ry_a_IDEX(Ry_a_IDEX),
    .HD_PCWrite(PCWrite),
    .HD_IFIDWrite(IFIDWrite),
    .HD_addBubble(addBubble)
    );
    
	//Instruction Decoder
	InstructionDecoder id(
	//rx express 10 to 8 bit in instruction, ry express 7 to 5 bit, rz express 4 to 2;
	//1 + 14   
    .instruction(instruction_a_IFID),	
	
	//insert muxes before two signal
    .imSelector(imSrcSelect),
    .ALUSrc2(ALUSrc2_a_Decoder),
    .memWrite(memWrite_a_Decoder),   //mux inserted
    .memRead(memRead_a_Decoder),
    .regDst(regDst_a_Decoder),   
	.branch(branch_a_Decoder), 
	.regWrite(regWrite_a_Decoder),    //mux inserted
	.memToReg(memToReg_a_Decoder),
	.op(ALUOp_a_Decoder),
	.readSpecReg(readSpecReg_a_Decoder),
	.writeSpecReg(writeSpecReg_a_Decoder),
	.jump(jump_a_Decoder),     
	.ALUSrc1(ALUSrc1_a_Decoder),
	.rxToMem(RxToMem_a_Decoder)
    );
	
	assign memWrite_b_IDEX = (jump_a_IDEX || addBubble || PCSrc) ? 2'b0 : memWrite_a_Decoder;
	assign regWrite_b_IDEX = (jump_a_IDEX || addBubble || PCSrc) ? 1'b0 : regWrite_a_Decoder;
	
	//Registers
	Registers registers(
		.CLK(CLK),
		.regWrite(regWrite_a_MEMWB),   //RegWrite == 1 express write, == 0 express read;
		.writeSpecReg(writeSpecReg_a_MEMWB),
		.readSpecReg(readSpecReg_a_Decoder),
		.R1(instruction_a_IFID[10:8]),
		.R2(instruction_a_IFID[7:5]),
		.R3(instruction_a_IFID[4:2]),
		.inData3(dataToWriteBack),
		.outData1(outData1_a_Registers),
		.outData2(outData2_a_Registers)
		//input
		);
		

	SignExtender se(
		//input
		.CLK(CLK),
		.imSrcSelect(imSrcSelect), //select which part of the instruction is immediate
		.instruction(instruction_a_IFID),
		//output
		.ExtendedImmediateOut(ExtendedImmediate_a_SE)
	);
	
	//modules in ID/EX stage
	//ID_EX
	ID_EX id_ex(
		.CLK(CLK),
		.PCIn(PC_a_IFID), 					//input
		.inData1(outData1_a_Registers),    //input
		.inData2(outData2_a_Registers),
		.inRx(instruction_a_IFID[10:8]),
		.inRy(instruction_a_IFID[7:5]),
		.inRz(instruction_a_IFID[4:2]),
		.inExtendedImmediate(ExtendedImmediate_a_SE),
		
		.writeSpecRegIn(writeSpecReg_a_Decoder),
		.memtoRegIn(memtoReg_a_Decoder),
		.regWriteIn(regWrite_b_IDEX),  //mux before it
		.memReadIn(memRead_a_Decoder),
		.memWriteIn(memWrite_b_IDEX),  //mux before it
		.jumpIn(jump_a_Decoder),
		.RxToMemIn(RxToMem_a_Decoder),
		.ALUOpIn(ALUOp_a_Decoder),
		.ALUSrc1In(ALUSrc1_a_Decoder),
		.ALUSrc2In(ALUSrc2_a_Decoder)
		.regDstIn(regDst_a_Decoder),
		.branchIn(branch_a_Decoder),
		.readSpecRegIn(readSpecReg_a_Decoder),
		
		.writeSpecRegOut(writeSpecReg_a_IDEX),
		.memtoRegOut(  	memtoReg_a_IDEX),
		.regWriteOut(      	regWrite_a_IDEX),
		.memReadOut( 		memRead_a_IDEX),
		.memWriteOut(		memWrite_a_IDEX),
		.jumpOut(				jump_a_IDEX),
		RxToMemOut(      RxToMem_a_IDEX),
		.ALUOpOut(           ALUOp_a_IDEX ),
		.ALUSrc1Out(           ALUSrc1_a_IDEX ),
		.ALUSrc2Out(           ALUSrc2_a_IDEX ),
		.regDstOut(            regDst_a_IDEX ),
		.branchOut(       		branch_a_IDEX ),
		.readSpecRegOut(  readSpecReg_a_IDEX),
		
		.PCOut(PC_a_IDEX),				//output
		.outData1(outData1_a_IDEX),
		.outData2(outData2_a_IDEX),
		.outExtendedImmediate(ExtendedImmediate_a_IDEX),
		.outRx(Rx_a_IDEX),
		.outRy(Ry_a_IDEX),
		.outRz(Rz_a_IDEX)
	);
	
	assign regWrite_b_EXMEM = PCSrc ? 1'b0 : regWrite_a_IDEX;
	assign memWrite_b_EXMEM = PCSrc ? 2'b0 : memWrite_a_IDEX;
	assign PC_b_EXMEM = PC_a_IDEX + ExtendedImmediate_a_IDEX;
	assign outData1Decided = forward1[1] ? dataToWriteBack : (forward1[0] ? ALUResult_a_EXMEM : outData1_a_IDEX);
	assign outData2Decided = forward2[1] ? dataToWriteBack : (forward2[0] ? ALUResult_a_EXMEM : outData2_a_IDEX);
	assign Data1_b_ALU = ALUSrc1[1] ? outData2Decided : (ALUSrc1[0] ? PC_a_IDEX : outData1Decided);
	assign Data2_b_ALU = ALUSrc2[1] ? outData1Decided : (ALUSrc2[0] ? ExtendedImmediate_a_IDEX : outData2Decided);
	assign data_b_EXMEM = RxToMem_a_IDEX ? outData1Decided : outData2Decided;
	assign registerToWriteId_b_EXMEM = regDst[1] ? Rz_a_IDEX : (regDst[0] ? Ry_a_IDEX : Rx_a_IDEX);
	
	
	ALU alu(  //central alu
	//input
	.first(Data1_b_ALU),
	.second(Data2_b_ALU),
	.op(ALUOp_a_IDEX),
	//output
	.result(ALUResult_b_EXMEM),
	.zeroFlag(zerobit_b_EXMEM)
	);
	
	
	
	//modules in EX/MEM stage
	//EX_MEM
	EX_MEM ex_mem(
		.CLK(CLK),
		//input
		.writeSpecRegIn(writeSpecReg_a_IDEX),
		.memtoRegIn(memtoReg_a_IDEX),
		.regWriteIn(regWrite_a_IDEX),
		.memReadIn(memRead_a_IDEX),
		.memWriteIn(memWrite_a_IDEX),
		.branchIn(branch_a_IDEX),
		.PCIn(PC_b_EXMEM),
		
		.zerobitIn(zerobit_b_EXMEM),
		.ALUResultIn(ALUResult_b_EXMEM),
		.dataIn(data_b_EXMEM),
		.registerToWriteIdIn(registerToWriteId_b_EXMEM),
		
		//output
		.writeSpecRegOut(writeSpecReg_a_EXMEM),
		.memtoRegOut(  	memtoReg_a_EXMEM),
		.regWriteOut(      	regWrite_a_EXMEM),
		.memReadOut( 	    memRead_a_EXMEM),
		.memWriteOut(	    memWrite_a_EXMEM),
		.branchOut(       	    branch_a_EXMEM ),
		.PCOut( PC_a_EXMEM),
		
		.ALUResultOut(ALUResult_a_EXMEM),
		.zerobitOut(zerobit_a_EXMEM),
		.dataOut(data_a_EXMEM),
		.registerToWriteId(registerToWriteId_a_EXMEM)
	);
	
	assign PCSrc = branch_a_EXMEM && zerobit_a_EXMEM;
	
	MemoryController mc(
		//mem control signal
		.memRead(memRead_a_EXMEM),
		.memWrite(memWrite_a_EXMEM),
		//physical connection
		.ram1OE(ram1OE),
		.ram1WE(ram1WE),
		.ram1EN(ram1EN),
		.ram1Addr(ram1Addr),
		.ram1Data(ram1Data),
		
		//input
		.CLK(CLK),
		.RST(RST),
		
		.address(ALUResult_a_EXMEM),
		.dataIn(data_a_EXMEM),
		
		//output
		.dataOut(data_a_MemController)
	);
	
	//modules in MEM/WB stage
	//MEM_WB
	MEM_WB mem_wb(
		.CLK(CLK),
		//input
		.writeSpecRegIn(writeSpecReg_a_EXMEM),
		.memtoRegIn(memtoReg_a_EXMEM),
		.regWriteIn(regWrite_a_EXMEM),
		.dataIn(data_a_MemController),
		.ALUResultIn(ALUResult_a_EXMEM),
		.registerToWriteIdIn(registerToWriteId_a_EXMEM),
		//output
		.writeSpecRegOut(writeSpecReg_a_MEMWB),
		.memtoRegOut(  	memtoReg_a_MEMWB),
		.regWriteOut(      	regWrite_a_MEMWB),
		.dataOut(data_a_MEMWB),
		.ALUResultOut(ALUResult_a_MEMWB),
		.outRegisterToWriteId(registerToWriteId_a_MEMWB)
	);
	
	assign dataToWriteBack = memToReg_a_MEMWB ? data_a_MEMWB : ALUResult_a_MEMWB;
	
	ForwardUnit  fu1(
	//input
    .Rx_a_IDEX(Rx_a_IDEX),
    .Ry_a_IDEX(Ry_a_IDEX),
    .Rz_a_IDEX(Rz_a_IDEX),
    .regWrite_a_EXMEM(regWrite_a_EXMEM),
    .regWrite_a_MEMWB(regWrite_a_MEMWB),
    .registerToWriteId_a_EXMEM(registerToWriteId_a_EXMEM),
    .registerToWriteId_a_MEMWB(registerToWriteId_a_MEMWB),
    .writeSpecReg_a_EXMEM(writeSpecReg_a_EXMEM),
    .writeSpecReg_a_MEMWB(writeSpecReg_a_MEMWB),
    .readSpecReg_a_IDEX(readSpecReg_a_IDEX),
	
	//output
    .forward1(forward1),
    .forward2(forward2)
	);

	assign next_PC = PCWrite ? PCValue : (jump_a_IDEX ? outData1Decided : (PCSrc ? PC_a_EXMEM : PCPlus))
	always @ (posedge CLK)
		PC <= next_PC;
	
endmodule