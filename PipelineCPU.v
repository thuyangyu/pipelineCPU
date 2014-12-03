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
	//2+3+14+3 wires
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
	
	wire outData1_a_Registers;
	wire outData2_a_Registers;
	wire ExtendedImmediate_a_SE;


	//wires after ID/EX
	//13 + 7 + 2 + 7
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
	
	wire inData1_b_ALU;
	wire inData2_b_ALU;
	
	wire regWrite_b_EXMEM;
	wire memWrite_b_EXMEM;
	wire PC_b_EXMEM;
	wire dataIn_b_EXMEM;
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
	
	//modules in IFID
	
	//IF_ID
	IF_ID if_id(
		.CLK(CLK),
        .RST(RST),
		.IF_ID_PCIn(PCPlus), 					//input
		.IF_ID_instructionIn(instruction),    //input
		.IF_ID_PCOut(PCAfterIFID),				//output
		.IF_ID_instructionOut(instructionAfterIFID)  //output
		);
	
		
	//Instruction Decoder
	InstructionDecoder id(
		instruction(instructionAfterIFID),
		regDst(regDst),   //select write R3 from ry or rz;   0 is from ry, 1 is from rz;
		jump(jump),  		//select PC or jump to immediate
		branch(branch),
		memRead(memRead),
		memToReg(memToReg),
		ALUOp(ALUOp),
		memWrite(memWrite),
		ALUSrc(ALUSrc),
		regWrite(regWrite)
	);
	
	//Registers
	Registers registers(
		.RegWrite(RegWrite),   //RegWrite == 1 express write, == 0 express read;
		.CLK(CLK),
		.RST(RST),
		.R1(instructionAfterIFID[10:8]),
		.R2(instructionAfterIFID[7:5]),
		.R3(),
		.inData3(),
		.outData1(outData1AfterRegisters),
		.outData2(outData2AfterRegisters)
		//input
		);
		

	SignExtender se(
		//input
		.CLK(CLK),
		.RST(RST),
		.imSrc(), //select which part of the instruction is immediate
		.instruction(instructionAfterIFID),
		//output
		.ExtendedImmediateOut(ExtendedImmediateAfterSE)
	);
	
	//ID_EX
	ID_EX id_ex(
		.CLK(CLK),
		.RST(RST),
		.ID_EX_PCIn(PCAfterIFID), 					//input
		.inData1(outData1AfterRegisters),    //input
		.inData2(outData2AfterRegisters),
		.inRx(instructionAfterIFID[10:8]),
		.inRy(instructionAfterIFID[7:5]),
		.inRz(instructionAfterIFID[4:2]),
		.inExtendedImmediate(ExtendedImmediateAfterSE),
		.c_WB_regWriteIn(c_WB_regWrite_a_Decoder),
		.c_WB_memtoRegIn(c_WB_memtoReg_a_Decoder),
		.c_MEM_memReadIn(c_MEM_memRead_a_Decoder),
		.c_MEM_memWriteIn(c_MEM_memWrite_a_Decoder),
		.c_MEM_branchIn(c_MEM_branch_a_Decoder),
		.c_EX_ALUOpIn(c_EX_ALUOp_a_Decoder),
		.c_EX_ALUSrcIn(c_EX_ALUSrc_a_Decoder),
		.c_EX_regDstIn(c_EX_regDst_a_Decoder),
		.c_WB_regWriteOut(      	c_WB_regWrite_a_IDEX),
		.c_WB_memtoRegOut(  	c_WB_memtoReg_a_IDEX),
		.c_MEM_memReadOut( 	c_MEM_memRead_a_IDEX),
		.c_MEM_memWriteOut(	c_MEM_memWrite_a_IDEX),
		.c_MEM_branchOut(       	c_MEM_branch_a_IDEX ),
		.c_EX_ALUOpOut(           	c_EX_ALUOp_a_IDEX ),
		.c_EX_ALUSrcOut(           	c_EX_ALUSrc_a_IDEX ),
		.c_EX_regDstOut(            	c_EX_regDst_a_IDEX ),
		.ID_EX_PCOut(PCAfterIDEX),				//output
		.outData1(outData1AfterIDEX),
		.outData2(outData2AfterIDEX),
		.outExtendedImmediate(ExtendedImmediateAfterIDEX),
		.outRx(RxAfterIDEX),
		.outRy(RyAfterIDEX),
		.outRz(RzAfterIDEX)
	
	);
	
	//mux for ALUSrc
	assign inData2BeforeALU = c_EX_ALUSrc_a_IDEX ?  ExtendedImmediateAfterIDEX : outData2AfterIDEX; 
	//mux for rx, ry, rz
	
	ALU alu(  //central alu
	.CLK(CLK),
	.RST(RST),
	//input
	.first(outData1AfterIDEX),
	.second(outData2AfterIDEX),
	.op(c_EX_ALUOp_a_IDEX),
	//output
	.result(ALUResultBeforeEXMEM),
	.T(TValueBeforeEXMEM)
	);
	
	//branch ALU
	
	assign branchDstBeforeEXMEM = ExtendedImmediateAfterIDEX + PCAfterIDEX;
	
	EX_MEM ex_mem(
		.CLK(CLK),
		.RST(RST),
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