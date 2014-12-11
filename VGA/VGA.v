`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:23:15 11/23/2013 
// Design Name: 
// Module Name:    vga 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGA(
		input clk, rst,
		output hs, vs,
		output [2:0] r, g, b,
		input [15:0] instruction
		//input [15:0] PC,
    );

reg clkOut;
	
always @(negedge clk, negedge rst)
begin
	if(rst == 0)
		clkOut = 0;
	else
		clkOut = ~clkOut;
end

wire [10:0] x, y;

VGAScanner scanner(
	clk,
	rst,
	hs, vs,
	x, y
);

VGAPainter painter(
	x, y,
	instruction[15:0],
	//pc,
	r, g, b
);

endmodule
