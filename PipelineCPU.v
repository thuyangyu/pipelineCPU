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
	wire MemWrite;
	wire ALUSrc;
	wire RegWrite;
	
	//PC module
    reg [15:0] PC;
	wire [15:0] PCValue;
	assign PCValue[15:0] = PC[15:0];
	
	//Instruction_Memory module
    wire [15:0] instruction;
    Instruction_Memory im(
        .CLK(CLK),
        .RST(RST),
        .address(PCValue),
        .instruction(instruction)
        ); 
	
	//Add  1 to PC
	wire [15:0] PCPlus;
	assign PCPlus[15:0] = PCValue[15:0] + 16'b1;        //temp add 1;
	
	
	wire [15:0] instructionAfterIFID;
	wire [15:0] PCAfterIFID;
	
	//IF_ID
	IF_ID if_id(
		.CLK(CLK),
        .RST(RST),
		.IF_ID_PCIn(PCPlus), 					//input
		.IF_ID_instructionIn(instruction),    //input
		.IF_ID_PCOut(PCAfterIFID),				//output
		.IF_ID_instructionOut(instructionAfterIFID)  //output
		);
		
		wire c_WB_regWrite_a_Decoder;
		wire c_WB_memtoReg_a_Decoder;
		wire c_MEM_memRead_a_Decoder;
		wire c_MEM_memWrite_a_Decoder;
		wire c_MEM_branch_a_Decoder;
		wire c_EX_ALUSrc_a_Decoder;
		wire c_EX_ALUOp_a_Decoder;
		wire c_EX_regDst_a_Decoder;
		
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
		
	//reg [15:0] regs [7:0]
	wire outData1AfterRegisters;
	wire outData2AfterRegisters;
	wire outData1AfterIDEX;
	wire outData2AfterIDEX;
	wire PCAfterIDEX;
	
	wire c_WB_regWrite_a_IDEX;
	wire c_WB_memtoReg_a_IDEX;
	wire c_MEM_memRead_a_IDEX;
	wire c_MEM_memWrite_a_IDEX;
	wire c_MEM_branch_a_IDEX;
	wire c_EX_ALUSrc_a_IDEX;
	wire c_EX_ALUOp_a_IDEX;
	wire c_EX_regDst_a_IDEX;
	
	
	wire ExtendedImmediateAfterSE;
	SignExtender se(
	//input
	.CLK(CLK),
	.RST(RST),
	.imSrc(), //select which part of the instruction is immediate
	.instruction(instructionAfterIFID),
	//output
	.ExtendedImmediateOut(ExtendedImmediateAfterSE)
	);
	
	wire ExtendedImmediateAfterIDEX;
	wire RxAfterIDEX;
	wire RyAfterIDEX;
	wire RzAfterIDEX;
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
	
	
	wire inData2BeforeALU;
	//mux for ALUSrc
	assign inData2BeforeALU = c_EX_ALUSrc_a_IDEX ?  ExtendedImmediateAfterIDEX : outData2AfterIDEX; 
	//mux for rx, ry, rz
	assign 
	
	
	wire ALUResultBeforeEXMEM;
	wire TValueBeforeEXMEM;
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
	
	wire c_WB_regWrite_a_EXMEM;
	wire c_WB_memtoReg_a_EXMEM;
	wire c_MEM_memRead_a_EXMEM;
	wire c_MEM_memWrite_a_EXMEM;
	wire c_MEM_branch_a_EXMEM;

	//branch ALU
	wire branchDstBeforeEXMEM;
	assign branchDstBeforeEXMEM = ExtendedImmediateAfterIDEX + PCAfterIDEX;
	wire branchDstAfterEXMEM;
	
	wire TValueAfterEXMEM;
	wire ALUResultAfterEXMEM;
	wire outData2AfterEXMEM;
	
	wire registerToWriteIdBeforeEXMEM;
	wire registerToWriteIdAfterEXMEM;
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
	
	wire dataToWriteBack;
	wire dataAfterMC;
	
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
	
	
	wire c_WB_regWrite_a_MEMWB;
	wire c_WB_memtoReg_a_MEMWB;
	wire dataAfterMEMWB;
	wire ALUResultAfterMEMWB;
	wire registerToWriteIdAfterMEMWB;
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