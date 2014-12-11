`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:26:36 11/24/2013 
// Design Name: 
// Module Name:    paintLogoM 
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
module paintLogoW(
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

paintRect w1(
	1,
	x, y,
	500+delt, 550,
	5, 40,
	hitTemp
);

paintNegPara w2(
	1,
	x, y,
	500+delt+20, 550+20,
	5, 20,
	hitTemp
);

paintPosPara w3(
	1,
	x, y,
	500+delt+20, 550+20,
	5, 20,
	hitTemp
);

paintRect w4(
	1,
	x, y,
	500+delt+40, 550,
	5, 40,
	hitTemp
);

endmodule
