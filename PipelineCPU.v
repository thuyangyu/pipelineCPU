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
	
	//control signal defination
	wire regDst;   //select write to ry or rz
	wire jump;     //select PC or jump to immediate
	wire branch; //
	wire memRead;//
	wire memToReg;
	wire ALUOp;
	wire memWrite;
	wire ALUSrc1;
	wire ALUSrc2;
	wire regWrite;
	
	
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
	
	wire writeSpecReg_a_Decoder;
	wire memToReg_a_Decoder;
	wire regWrite_a_Decoder;
	wire memRead_a_Decoder;
	wire memWrite_a_Decoder;
	wire jump_a_Decoder;
	wire RxToMem_a_Decoder;
	wire ALUOp_a_Decoder;
	wire ALUSrc1_a_Decoder;
	wire ALUSrc2_a_Decoder;
	wire regDst_a_Decoder;
	wire branch_a_Decoder;
	wire readSpecReg_a_Decoder;
	wire imSrcSelect;
	
	wire memWrite_b_IDEX;
	wire regWrite_b_IDEX;
	
	wire outData1_a_Registers;
	wire outData2_a_Registers;
	wire ExtendedImmediate_a_SE;


	//wires after ID/EX
	//13 + 7 + 2 + 2 + 7
	wire writeSpecReg_a_IDEX;
	wire memToReg_a_IDEX;
	wire regWrite_a_IDEX;
	wire memRead_a_IDEX;
	wire memWrite_a_IDEX;
	wire jump_a_IDEX;
	wire RxToMem_a_IDEX;
	wire ALUOp_a_IDEX;
	wire ALUSrc1_a_IDEX;
	wire ALUSrc2_a_IDEX;
	wire regDst_a_IDEX;
	wire branch_a_IDEX;
	wire readSpecReg_a_IDEX;
	
	wire PC_a_IDEX;
	wire outData1_a_IDEX;
	wire outData2_a_IDEX;
	wire ExtendedImmediate_a_IDEX;
	wire Rx_a_IDEX;
	wire Ry_a_IDEX;
	wire Rz_a_IDEX;
	
	wire outData1Decided;
	wire outData2Decided;
	wire Data1_b_ALU;
	wire Data2_b_ALU;
	
	wire regWrite_b_EXMEM;
	wire memWrite_b_EXMEM;
	wire PC_b_EXMEM;
	wire data_b_EXMEM;
	wire ALUResult_b_EXMEM;
	wire Zerobit_b_EXMEM;
	wire registerToWriteId_b_EXMEM;
	
	//wires after EX/MEM
	//5 + 6 + 1 + 1 wires
	wire writeSpecReg_a_EXMEM;
	wire memToReg_a_EXMEM;
	wire regWrite_a_EXMEM;
	wire memRead_a_EXMEM;
	wire memWrite_a_EXMEM;
	
	wire branch_a_EXMEM;
	wire PC_a_EXMEM;
	wire Zerobit_a_EXMEM;
	wire ALUResult_a_EXMEM;
	wire dataIn_a_EXMEM;
	wire registerToWriteId_a_EXMEM;
	
	wire PCSrc;
	
	wire dataOut_a_MemController;
	
	//wires after MEM/WB
	//3 + 3 + 1 wires
	wire writeSpecReg_a_MEMWB;
	wire memToReg_a_MEMWB;
	wire regWrite_a_MEMWB;
	
	wire dataOut_a_MEMWB;
	wire ALUResult_a_MEMWB;
	wire registerToWriteId_a_MEMWB;
	
	wire dataToWriteBack;

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
	
	//insert muxs before two signal
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
		.inRx(instructionAfterIFID[10:8]),
		.inRy(instructionAfterIFID[7:5]),
		.inRz(instructionAfterIFID[4:2]),
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
		
		.PCOut(PCAfterIDEX),				//output
		.outData1(outData1_a_IDEX),
		.outData2(outData2_a_IDEX),
		.outExtendedImmediate(ExtendedImmediate_a_IDEX),
		.outRx(Rx_a_IDEX),
		.outRy(Ry_a_IDEX),
		.outRz(Rz_a_IDEX)
	);
	
	assign regWrite_b_EXMEM = PCSrc ? 1'b0 : regWrite_a_IDEX;
	assign memWrite_b_EXMEM = PCSrc ? 1'b0 : memWrite_a_IDEX;
	assign PC_b_EXMEM = PC_a_IDEX + ExtendedImmediate_a_IDEX;
	assign outData1Decided = forward1[1] ? dataToWriteBack : (forward1[0] ? ALUResult_a_EXMEM : outData1_a_IDEX);
	assign outData2Decided = forward2[1] ? dataToWriteBack : (forward2[0] ? ALUResult_a_EXMEM : outData2_a_IDEX);
	assign Data1_b_ALU = ALUSrc1[1] ? outData2Decided : (ALUSrc1[0] ? PC_a_IDEX : outData1Decided);
	assign Data2_b_ALU = ALUSrc2[1] ? outData1Decided : (ALUSrc2[0] ? ExtendedImmediate_a_IDEX : outData2_a_IDEX);
	assign data_b_EXMEM = RxToMem_a_IDEX ? outData1Decided : outData2Decided;
	assign registerToWriteId_b_EXMEM = regDst[1] ? Rz_a_IDEX : (regDst[0] ? Ry_a_IDEX : Rx_a_IDEX);
	
	
	ALU alu(  //central alu
	//input
	.first(Data1_b_ALU),
	.second(Data2_b_ALU),
	.op(ALUOp_a_IDEX),
	//output
	.result(ALUResult_b_EXMEM),
	.zeroFlag(Zerobit_b_EXMEM)
	);
	
	
	
	//modules in EX/MEM
	//EX_MEM
	EX_MEM ex_mem(
		.CLK(CLK),
		//input
		.c_WB_regWriteIn(c_WB_regWrite_a_IDEX),
		.c_WB_memtoRegIn(c_WB_memtoReg_a_IDEX),
		.c_MEM_memReadIn(c_MEM_memRead_a_IDEX),
		.c_MEM_memWriteIn(c_MEM_memWrite_a_IDEX),
		.c_MEM_branchIn(c_MEM_branch_a_IDEX),
		.branchDstIn(branchDstBeforeEXMEM),
		.TValueIn(TValueBeforeEXMEM),
		.ALUResultIn(ALUResultBeforeEXMEM),
		.inData2(outData2AfterIDEX),
		.inRegisterToWriteId(registerToWriteIdBeforeEXMEM),
		
		//output
		.c_WB_regWriteOut(      	c_WB_regWrite_a_EXMEM),
		.c_WB_memtoRegOut(  	c_WB_memtoReg_a_EXMEM),
		.c_MEM_memReadOut( 	c_MEM_memRead_a_EXMEM),
		.c_MEM_memWriteOut(	c_MEM_memWrite_a_EXMEM),
		.c_MEM_branchOut(       	c_MEM_branch_a_EXMEM ),
		.branchDstOut(branchDstAfterEXMEM),
		.TValueOut(TValueAfterEXMEM),
		.ALUResultOut(ALUResultAfterEXMEM),
		.outData2(outData2AfterEXMEM),
		.outRegisterToWriteId(registerToWriteIdAfterEXMEM)
	);
	
	MemoryController mc(
		//mem control signal
		.memRead(c_MEM_memRead_a_EXMEM),
		.memWrite(c_MEM_memWrite_a_EXMEM),
		//physical connection
		.ram1OE(ram1OE),
		.ram1WE(ram1WE),
		.ram1EN(ram1EN),
		.ram1Addr(ram1Addr),
		.ram1Data(ram1Data),
		
		//input
		.CLK(CLK),
		.RST(RST),
		
		.address(ALUResultAfterEXMEM),
		.dataIn(outData2AfterEXMEM),
		
		//output
		.dataOut(dataAfterMC)
	);
	
	MEM_WB mem_wb(
		//input
		.c_WB_regWriteIn(c_WB_regWrite_a_EXMEM),
		.c_WB_memtoRegIn(c_WB_memtoReg_a_EXMEM),
		.dataIn(dataAfterMC),
		.ALUResultIn(ALUResultAfterEXMEM),
		.inRegisterToWriteId(registerToWriteIdAfterEXMEM)
		//output
		.c_WB_regWriteOut(      	c_WB_regWrite_a_MEMWB),
		.c_WB_memtoRegOut(  	c_WB_memtoReg_a_MEMWB),
		.dataOut(dataAfterMEMWB),
		.ALUResultOut(ALUResultAfterMEMWB),
		.outRegisterToWriteId(registerToWriteIdAfterMEMWB)
	);
	
endmodule