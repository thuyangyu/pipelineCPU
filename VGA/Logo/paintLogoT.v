`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:47 11/24/2013 
// Design Name: 
// Module Name:    paintLogoT 
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
module paintLogoT(
		input enble,
		input [10:0] x, y,
		input [10:0] delt,
		output reg hit
    );

wor hitTemp;

always @(hitTemp)
begin
	hit = hitTemp;
end

paintRect t1(
	enble,
	x, y,
	500+delt+10, 550,
	20, 5,
	hitTemp
);

paintRect t2(
	enble,
	x, y,
	500+delt+20, 550,
	5, 40,
	hitTemp
);

endmodule
