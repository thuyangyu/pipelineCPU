`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:07 11/24/2013 
// Design Name: 
// Module Name:    paintNegPara 
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
module paintNegPara(
		input enble,
		input [10:0] x, y,
		input [10:0] cx, cy,
		input [10:0] width, height,
		output reg hit
    );

always @(*)
begin
	if(enble == 1 && y > cy && y < cy + height && x > y - cy + cx && x < y - cy + cx + width)
		hit = 1;
	else
		hit = 0;
end


endmodule
