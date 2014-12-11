`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:42 11/23/2013 
// Design Name: 
// Module Name:    paintRect 
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
module paintRect(
		input enble,
		input [10:0] x, y,
		input [10:0] cx, cy,
		input [10:0] width, height,
		output reg hit
    );

always @(*)
begin
	if(enble == 1 && x > cx && x < cx + width && y > cy && y < cy + height)
		hit = 1;
	else
		hit = 0;
end

endmodule
