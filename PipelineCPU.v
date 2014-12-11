module PipelineCPU(
    input CLK,//this is the 50HZ clk
    input RST,
	
	output ram1OE,
	output ram1WE,
	output ram1EN,
	output [17:0] ram1Addr,
	inout  [15:0] ram1Data,
    
    output ram2OE,
	output ram2WE,
	output ram2EN,
	output [17:0] ram2Addr,
	inout  [15:0] ram2Data,
    
    input data_ready,
	input tbre,
    input tsre,
    output rdn,
    output wrn,
    
    //for the VGA
    output hs_topLevelOutForVGA,
    output vs_topLevelOutForVGA,
    output [2:0] r_topLevelOutForVGA, 
    output [2:0] g_topLevelOutForVGA, 
    output [2:0] b_topLevelOutForVGA,
    
    //for the button
    input button,
    
    //for SW control 
    input [5:0] SW,
	 
	 //for output keyboard state
	 output [2:0]LED,
	 
	 //for the ps2 keyboard
	 inout PS2_CLK,
	 inout PS2_DAT
    
);
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
	wire jump_b_IDEX;
	wire RxToMem_a_Decoder;
	wire [3:0] ALUOp_a_Decoder;
	wire [1:0] ALUSrc1_a_Decoder;
	wire [1:0] ALUSrc2_a_Decoder;
	wire [1:0] regDst_a_Decoder;
	wire branch_a_Decoder;
    wire branch_b_IDEX;
	wire [1:0] readSpecReg_a_Decoder;
	wire [3:0] imSrcSelect;
	
	wire [1:0] memWrite_b_IDEX;
	wire regWrite_b_IDEX;
	
	wire [15:0] outData1_a_Registers;
	wire [15:0] outData2_a_Registers;
	wire [15:0] ExtendedImmediate_a_SE;


	//wires after ID/EX
	//13 + 7 + 2 + 2 + 7
    //add the forward1 and forward2 declaration
    wire [1:0] forward1;
    wire [1:0] forward2;
	wire [1:0] writeSpecReg_a_IDEX;
	wire memToReg_a_IDEX;
	wire regWrite_a_IDEX;
	wire [1:0] memRead_a_IDEX;
	wire [1:0] memWrite_a_IDEX;
	wire jump;
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
	
	wire [15:0] data_a_MemController;
	
	//wires after MEM/WB
	//3 + 3 + 1 wires
	wire [1:0] writeSpecReg_a_MEMWB;
	wire memToReg_a_MEMWB;
	wire regWrite_a_MEMWB;
	
	wire [15:0] data_a_MEMWB;
	wire [15:0] ALUResult_a_MEMWB;
	wire [2:0] registerToWriteId_a_MEMWB;
	
	wire [15:0] dataToWriteBack;
    
    //added to show the registers data
    wire [175:0] allRegistersDataLine;
    
    
	reg prefreeze;
    wire freeze;
	//assign LED = freeze;
	//this is the keyborad state
	wire[2:0] keyBoardState;
	//************************************* start attachment
    
    // deal with the frequency division,added code

    reg [63:0]CLKCounter;
    always @ (posedge CLK)
    begin
        CLKCounter[63:0] = CLKCounter[63:0] + 64'b1; 
    end
    

    //add to deal with the button triggered
    reg buttonTriggered;//this is the signal that a button is pushed by the user
    reg formerButton;// the register to remember the last button value
    reg buttonTriggered_half;//half the frequency of the buttonTriggered
    
    always @(posedge CLK)
    begin
            formerButton <= button;
    end

    always @ (posedge CLK, negedge RST)
    begin
        if(!RST)
            buttonTriggered <= 1'b0;
        else
            begin
                if({formerButton,button} == 2'b10)
                    buttonTriggered <= 1'b1;
                else 
                    buttonTriggered <= 1'b0;
            end
        
    end
    
    always @ (posedge buttonTriggered or negedge RST)
      if (!RST)
        buttonTriggered_half = 0;
      else
        buttonTriggered_half = ~ buttonTriggered_half;
        
    
            
    //this is the real CPU CLK sent into all the module
    //here the defination of the CPU_CLK_double is: 
    //2'b011:buttonDownToPosedge
    //2'b010:CLK12
    //2'b001:CLK25
    //2'b000:CLK
    wire highFre;
    wire lowFre;
    wire CPU_CLK_double = keyBoardState[2] ? highFre : lowFre;
    assign highFre = keyBoardState[0] ? CLKCounter[0]: CLK;
    assign lowFre = keyBoardState[1] ? (keyBoardState[0] ? CLKCounter[24]: CLKCounter[5]):(keyBoardState[0] ? CLKCounter[15]: button);
    
	
	//button get reverse, press the button is posedge
	wire buttonDownToPosedge;
	assign buttonDownToPosedge = ~CPU_CLK_double;  //previous is button
    reg button_half;
	always @ (posedge buttonDownToPosedge, negedge RST)
		if(!RST)
			button_half <= 1'b0;
		else
			button_half <= ~button_half;
    
    
    //-------------------------------------------------------
	//-----------------------begin the modules---------------------
    //-------------------------------------------------------
	 
	 //for the ps2 keyboard
	 KeyboardTop kt(
		.CLK(CLK),//this is the 50MHz clk
		.RST(RST),
		.state(keyBoardState),
		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT)
	);
	
	assign LED[2:0] = keyBoardState[2:0];
   
 
    //this is the display module, I place it at the beginning
    GraphicCard gc(
      .clk(CLKCounter[0]),//this should be a really quick CLK even using single step, should always be clk25
      .rst(RST),
      .registerVGA(allRegistersDataLine),
      .IfPC(PCValue), 
      .IfIR(instruction_a_IM),
      .registerS({2'b0, forward1}), 
      .registerM({2'b0, forward2}), 
      .IdRegisterT({2'b0, ALUSrc1_a_IDEX}), 
      .MeRegisterT({2'b0, ALUSrc2_a_IDEX}),
      .ExCalResult(ALUResult_b_EXMEM), 
      .MeCalResult(dataToWriteBack),
      .hs(hs_topLevelOutForVGA), //output for physical
      .vs(vs_topLevelOutForVGA), //output for physical
      .r(r_topLevelOutForVGA),   //output for physical
      .g(g_topLevelOutForVGA),   //output for physical
      .b(b_topLevelOutForVGA)    //output for physical
    );
	
	//modules in PC stage
	//PC module
    reg [15:0] PC;
	assign PCValue[15:0] = PC[15:0];
	assign PCPlus[15:0] = PCValue[15:0] + 16'b1;        //temp add 1;
	assign PC_b_IFID[15:0]               = IFIDWrite ? PC_a_IFID[15:0] : PCPlus[15:0];  //mux
	assign instruction_b_IFID[15:0] = IFIDWrite ? instruction_a_IFID[15:0] : ((jump || PCSrc) ? 16'b0000_1000_0000_0000 : instruction_a_IM[15:0]);
	
	//Instruction_Memory module
    /*Instruction_Memory im(
        .CLK(buttonDownToPosedge),
        .CLK_half(button_half),
        .RST(RST),
        .address(PCValue),
        .instruction(instruction_a_IM),
        
        //add some physical lines
        .RAM2OE(ram2OE),
        .RAM2WE(ram2WE),
        .RAM2EN(ram2EN),
        .RAM2ADDR(ram2Addr),
        .RAM2DATA(ram2Data)
    );*/     
	
	//modules in IFID stage
	//IF_ID
	IF_ID if_id(
		.CLK(button_half),
		.RST(RST),
		.freeze(freeze),
		.PCIn(PC_b_IFID), 									//input
		.instructionIn(instruction_b_IFID),      //input
		.PCOut(PC_a_IFID),			   				   //output
		.instructionOut(instruction_a_IFID)   //output
		);
	
	//HazardDetector
	HazardDetector hd(
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
	
	assign memWrite_b_IDEX = (jump || addBubble || PCSrc) ? 2'b0 : memWrite_a_Decoder;
	assign regWrite_b_IDEX = (jump || addBubble || PCSrc) ? 1'b0 : regWrite_a_Decoder;
	assign jump_b_IDEX = ( addBubble || PCSrc) ? 1'b0: jump_a_Decoder;
    assign branch_b_IDEX = (jump || addBubble || PCSrc) ? 1'b0 : branch_a_Decoder;
	//Registers
	Registers registers(
		.CLK(buttonDownToPosedge),
      .CLK_half(button_half),
	  .freeze(freeze),
		.regWrite(regWrite_a_MEMWB),   //RegWrite == 1 express write, == 0 express read;
		.writeSpecReg(writeSpecReg_a_MEMWB),
		.readSpecReg(readSpecReg_a_Decoder),
		.R1(instruction_a_IFID[10:8]),
		.R2(instruction_a_IFID[7:5]),
		.R3(registerToWriteId_a_MEMWB),
		.inData3(dataToWriteBack),
		.outData1(outData1_a_Registers),
		.outData2(outData2_a_Registers),
        .allRegistersDataToShow(allRegistersDataLine)
		
		);
		

	SignExtender se(
		//input
		.imSrcSelect(imSrcSelect), //select which part of the instruction is immediate
		.instruction(instruction_a_IFID),
		//output
		.ExtendedImmediateOut(ExtendedImmediate_a_SE)
	);
	
	//modules in ID/EX stage
	//ID_EX
	ID_EX id_ex(
		.CLK(button_half),
		.RST(RST),
		.PCIn(PC_a_IFID), 					//input
		.freeze(freeze),
		.inData1(outData1_a_Registers),    //input
		.inData2(outData2_a_Registers),
		.inRx(instruction_a_IFID[10:8]),
		.inRy(instruction_a_IFID[7:5]),
		.inRz(instruction_a_IFID[4:2]),
		.inExtendedImmediate(ExtendedImmediate_a_SE),
		
		.writeSpecRegIn(writeSpecReg_a_Decoder),
		.memtoRegIn(memToReg_a_Decoder),
		.regWriteIn(regWrite_b_IDEX),  //mux before it
		.memReadIn(memRead_a_Decoder),
		.memWriteIn(memWrite_b_IDEX),  //mux before it
		.jumpIn(jump_b_IDEX),
		.RxToMemIn(RxToMem_a_Decoder),
		.ALUOpIn(ALUOp_a_Decoder),
		.ALUSrc1In(ALUSrc1_a_Decoder),
		.ALUSrc2In(ALUSrc2_a_Decoder),
		.regDstIn(regDst_a_Decoder),
		.branchIn(branch_b_IDEX),
		.readSpecRegIn(readSpecReg_a_Decoder),
		
		.writeSpecRegOut(writeSpecReg_a_IDEX),
		.memtoRegOut(  	memToReg_a_IDEX),
		.regWriteOut(      	regWrite_a_IDEX),
		.memReadOut( 		memRead_a_IDEX),
		.memWriteOut(		memWrite_a_IDEX),
		.jumpOut(				jump_a_IDEX),
		.RxToMemOut(      RxToMem_a_IDEX),
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
	
    //we want to enable the delay slot, so that we disable these lines
	//assign regWrite_b_EXMEM = PCSrc ? 1'b0 : regWrite_a_IDEX;
	//assign memWrite_b_EXMEM = PCSrc ? 2'b0 : memWrite_a_IDEX;
	//assign jump = PCSrc ? 1'b0: jump_a_IDEX;
	assign regWrite_b_EXMEM = regWrite_a_IDEX;//we want to enable the delay slot, so that I add these lines
	assign memWrite_b_EXMEM = memWrite_a_IDEX;//we want to enable the delay slot, so that I add these lines
	assign jump = jump_a_IDEX;//we want to enable the delay slot, so that I add these lines
    
	assign PC_b_EXMEM = PC_a_IDEX + ExtendedImmediate_a_IDEX;
	assign outData1Decided = forward1[1] ? dataToWriteBack : (forward1[0] ? ALUResult_a_EXMEM : outData1_a_IDEX);
	assign outData2Decided = forward2[1] ? dataToWriteBack : (forward2[0] ? ALUResult_a_EXMEM : outData2_a_IDEX);
	assign Data1_b_ALU = ALUSrc1_a_IDEX[1] ? outData2Decided : (ALUSrc1_a_IDEX[0] ? PC_a_IDEX : outData1Decided);
	assign Data2_b_ALU = ALUSrc2_a_IDEX[1] ? outData1Decided : (ALUSrc2_a_IDEX[0] ? ExtendedImmediate_a_IDEX : outData2Decided);
	assign data_b_EXMEM = RxToMem_a_IDEX ? outData1Decided : outData2Decided;
	assign registerToWriteId_b_EXMEM = regDst_a_IDEX[1] ? Rz_a_IDEX : (regDst_a_IDEX[0] ? Ry_a_IDEX : Rx_a_IDEX);
	
	
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
		.CLK(button_half),
		.RST(RST),
		.freeze(freeze),
		//input
		.writeSpecRegIn(writeSpecReg_a_IDEX),
		.memtoRegIn(memToReg_a_IDEX),
		.regWriteIn(regWrite_b_EXMEM), //mux
		.memReadIn(memRead_a_IDEX),
		.memWriteIn(memWrite_b_EXMEM), //mux
		.branchIn(branch_a_IDEX),
		.PCIn(PC_b_EXMEM),
		
		.zerobitIn(zerobit_b_EXMEM),
		.ALUResultIn(ALUResult_b_EXMEM),
		.dataIn(data_b_EXMEM),
		.registerToWriteIdIn(registerToWriteId_b_EXMEM),
		
		//output
		.writeSpecRegOut(writeSpecReg_a_EXMEM),
		.memtoRegOut(  	memToReg_a_EXMEM),
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
	
	/*MemoryController mc(//this is the instruction memory
        //input
		.CLK(buttonDownToPosedge),
        .CLK_half(button_half),
		.RST(RST),
        
		//memory control signal
		.memRead(memRead_a_EXMEM),
		.memWrite(memWrite_a_EXMEM),
		//physical connection
		.ram1OE(ram1OE),
		.ram1WE(ram1WE),
		.ram1EN(ram1EN),
		.ram1Addr(ram1Addr),
		.ram1Data(ram1Data),
        
        .data_ready(data_ready),
        .rdn(rdn),
        .tbre(tbre),
        .tsre(tsre),
        .wrn(wrn),
	
		.address(ALUResult_a_EXMEM),
		.dataIn(data_a_EXMEM),
		
		//output
		.dataOut(data_a_MemController)
	);*/
    
    
    AllInOneRamController mc(//this is the instruction memory
        //input
		.CLK(buttonDownToPosedge),
        .CLK_half(button_half),
		.freeze(freeze),
		.RST(RST),
        
        //--------for ram1
		.memRead(memRead_a_EXMEM),
		.memWrite(memWrite_a_EXMEM),
		//physical connection
		.ram1OE(ram1OE),
		.ram1WE(ram1WE),
		.ram1EN(ram1EN),
		.ram1Addr(ram1Addr),
		.ram1Data(ram1Data),
        
        .data_ready(data_ready),
        .rdn(rdn),
        .tbre(tbre),
        .tsre(tsre),
        .wrn(wrn),
	
		.ram1Address(ALUResult_a_EXMEM),
		.dataIn(data_a_EXMEM),
		
		//output
		.dataOut(data_a_MemController),
        
        
        //--------for ram2
        .ram2Address(PCValue),
        .instruction(instruction_a_IM),
        
     
        .RAM2OE(ram2OE),
        .RAM2WE(ram2WE),
        .RAM2EN(ram2EN),
        .RAM2ADDR(ram2Addr),
        .RAM2DATA(ram2Data)
	);
    
	//modules in MEM/WB stage
	//MEM_WB
	MEM_WB mem_wb(
		.CLK(button_half),
		.RST(RST),
		.freeze(freeze),
		//input
		.writeSpecRegIn(writeSpecReg_a_EXMEM),
		.memtoRegIn(memToReg_a_EXMEM),
		.regWriteIn(regWrite_a_EXMEM),
		.dataIn(data_a_MemController),
		.ALUResultIn(ALUResult_a_EXMEM),
		.registerToWriteIdIn(registerToWriteId_a_EXMEM),
		//output
		.writeSpecRegOut(writeSpecReg_a_MEMWB),
		.memtoRegOut(  	memToReg_a_MEMWB),
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

	assign next_PC = PCWrite ? PCValue : (jump ? outData1Decided : (PCSrc ? PC_a_EXMEM : PCPlus));
	always @ (posedge button_half, negedge RST)
		if(!RST)
			begin
			if(freeze == 1'b0)
				PC <= 16'b0;
			end
		else
			begin
			if(freeze == 1'b0)
				PC <= next_PC;
			end
   //assign freeze = 1'b0;
	assign freeze = ( (~prefreeze) && (memWrite_a_EXMEM[1:0] != 2'b0) && (ALUResult_a_EXMEM[15:14] == 2'b01) && (memRead_a_EXMEM[1:0] == 2'b0)) ? 1'b1 : 1'b0;
	always @ (posedge button_half)
	begin
		prefreeze <= freeze;
	end


	
endmodule