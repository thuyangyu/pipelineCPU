`timescale 1ns / 1ns

module ForwardUnit(
    input [2:0] Rx_a_IDEX,
    input [2:0] Ry_a_IDEX,
    input [2:0] Rz_a_IDEX,
    input regWrite_a_EXMEM,
    input regWrite_a_MEMWB,
    input [2:0] registerToWriteId_a_EXMEM,
    input [2:0] registerToWriteId_a_MEMWB,
    input writeSpecReg_a_EXMEM,
    input writeSpecReg_a_MEMWB,
    input readSpecReg_a_IDEX,

    output [1:0] forward1,
    output [1:0] forward2
);
    
    //the wire for the forward 1
    wire forward1_a;
    wire forward1_EXMEM; //regWrite_a_MEMWB == 1'b1 && regWrite_a_EXMEM == 1'b1
    wire forward1_b;
    wire forward1_c;
    wire forward1_EX; //regWrite_a_MEMWB == 1'b0 && regWrite_a_EXMEM == 1'b1
    wire forward1_MEM; //regWrite_a_MEMWB == 1'b1 && regWrite_a_EXMEM == 1'b0
    wire forward1_maybeEX;
    wire forward1_d;
    wire forward1_maybeMEM;

    //the wire for the forward 2
    wire forward2_a;
    wire forward2_EXMEM; //regWrite_a_MEMWB == 1'b1 && regWrite_a_EXMEM == 1'b1
    wire forward2_b;
    wire forward2_EX; 
    wire forward2_MEM;

    //the logic for the forward 1
    assign forward1 = (regWrite_a_MEMWB == 1'b0 && regWrite_a_EXMEM == 1'b0) ? 2'b00: forward1_a;
    assign forward1_a = (regWrite_a_MEMWB == 1'b1 && regWrite_a_EXMEM == 1'b1) ? forward1_EXMEM : forward1_b;
    assign forward1_b = (regWrite_a_EXMEM == 1'b1) ? forward1_EX : forward1_MEM;
    assign forward1_EX = (writeSpecReg_a_EXMEM != readSpecReg_a_IDEX) ? 2'b00 :forward1_c;
    assign forward1_c = (writeSpecReg_a_EXMEM != 2'b00) ? 2'b01: forward1_maybeEX;
    assign forward1_maybeEX = (registerToWriteId_a_EXMEM[2:0] == Rx_a_IDEX[2:0]) ? 2'b01: 2'b00;
    assign forward1_MEM = (writeSpecReg_a_MEMWB != regWrite_a_EXMEM) ? 2'b00 :forward1_d;
    assign forward1_d = (writeSpecReg_a_MEMWB != 2'b00) ? 2'b10: forward1_maybeMEM;
    assign forward1_maybeMEM = (registerToWriteId_a_MEMWB[2:0] ==  Rx_a_IDEX[2:0]) ? 2'b10: 2'b00;
    assign forward1_EXMEM = (forward1_EX[1:0] != 2'b00) ? forward1_EX: forward1_MEM;

    //the logic for the forward2
    assign  forward2 = (regWrite_a_MEMWB == 1'b0 && regWrite_a_EXMEM == 1'b0) ? 2'b00: forward2_a;
    assign forward2_a = (regWrite_a_MEMWB == 1'b1 && regWrite_a_EXMEM == 1'b1) ? forward2_EXMEM : forward2_b; 
    assign forward2_b = (regWrite_a_EXMEM == 1'b1) ? forward2_EX : forward2_MEM;
    assign forward2_EX = (registerToWriteId_a_EXMEM[2:0] == Ry_a_IDEX[2:0]) ? 2'b01 :2'b00;
    assign forward2_MEM = (registerToWriteId_a_MEMWB[2:0] == Ry_a_IDEX[2:0]) ? 2'b10 :2'b00;
    assign forward2_EXMEM = (forward2_EX[1:0] != 2'b00) ? forward2_EX: forward2_MEM;

endmodule