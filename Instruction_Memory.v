`timescale 1ns / 1ps
//!!! we do not have the initialization stage, so that we always need to have the CPU reset before working

module Instruction_Memory(
    input CLK,
    input CLK_half,
    input RST,
    input [15:0]address,
    output [15:0] instruction,
    
    //this actually control the real memory
    output RAM2OE,
    output RAM2WE,
    output RAM2EN,
    output [17:0]RAM2ADDR,
    inout [15:0] RAM2DATA
);

//stash address in negedge of CLK_half
reg [15:0] addressBuffer;
always @ (negedge CLK_half)
	addressBuffer[15:0] <= address[15:0];

assign RAM2OE = CLK_half ^ CLK; //first quarter and fourth quarter
assign RAM2WE = 1'b1;//always disable
assign RAM2EN = 1'b0;//always enable
assign RAM2ADDR[17:0] = {2'b0, addressBuffer[15:0]};
assign RAM2DATA[15:0] =  16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;
assign instruction [15:0] = RAM2DATA[15:0];

endmodule