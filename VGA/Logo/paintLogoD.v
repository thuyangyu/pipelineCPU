`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:27:51 11/24/2013 
// Design Name: 
// Module Name:    paintLogoD 
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
module paintLogoD(
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

paintRect d1(
	1,
	x, y,
	500+delt+10, 550,
	5,40,
	hitTemp
);

paintRect d2(
	1,
	x, y,
	500+delt+10, 550,
	10, 5,
	hitTemp
);

paintNegPara d3(
	1,
	x, y,
	500+delt+20, 550,
	5, 10,
	hitTemp
);

paintRect d4(
	1,
	x, y,
	500+delt+30, 550+10,
	5, 20,
	hitTemp
);

paintPosPara d5(
	1,
	x, y,
	500+delt+30, 550+30,
	5,10,
	hitTemp
);

paintRect d6(
	1,
	x, y,
	500+delt+10, 550+40,
	20, 5,
	hitTemp
);

endmodule
