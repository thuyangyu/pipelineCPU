`timescale 1ns / 1ns

module ForwardUnit(
    input [2:0] Rx_a_IDEX;
    input [2:0] Ry_a_IDEX;
    input [2:0] Rz_a_IDEX;
    input regWrite_a_EXMEM;
    input regWrite_a_MEMWB;
    input [2:0] registerToWriteId_a_EXMEM;
    input [2:0] registerToWriteId_a_MEMWB;
    input writeSpecReg_a_EXMEM;
    input writeSpecReg_a_MEMWB;
    input readSpecReg_a_IDEX;

    output [1:0] forward1,
    output [1:0] forward2
);








endmodule