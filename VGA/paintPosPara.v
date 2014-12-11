`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:40 11/24/2013 
// Design Name: 
// Module Name:    paintPosPara 
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
module paintPosPara(
		input enble,
		input [10:0] x, y,
		input [10:0] cx, cy,
		input [10:0] width, height,
		output reg hit
    );

always @(*)
begin
	if(enble == 1 && y > cy && y < cy + height && x > cy - y + cx&& x < cy - y + cx + width)
		hit = 1;
	else
		hit = 0;
end

endmodule
