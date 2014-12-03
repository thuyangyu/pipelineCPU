`timescale 1ns / 1ns

module Registers (
input CLK,
input regWrite,   //RegWrite == 1 express write, but the read is always enabled
input [1:0]writeSpecReg,
input [1:0]readSpecReg,
input [2:0] R1,
input [2:0] R2,
input [2:0] R3,
input [15:0] inData3,
output [15:0] outData1,
output [15:0] outData2

);

reg [15:0] generalRegister [7:0];

generalRegister[R1[2:0]]

endmodule