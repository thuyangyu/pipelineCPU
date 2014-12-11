`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:47 12/8/2014 
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
module paintLogoNum3(
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

paintRect Num31(
	enble,
	x, y,
	500+delt+10, 550,
	20, 5,
	hitTemp
);

paintRect Num32(
	enble,
	x, y,
	500+delt+10, 550,
	5, 20,
	hitTemp
);

paintRect Num33(
	enble,
	x, y,
	500+delt+10, 550+20,
	20, 5,
	hitTemp
);

paintRect Num34(
	enble,
	x, y,
	500+delt+10, 550+20,
	5, 20,
	hitTemp
);

paintRect Num35(
	enble,
	x, y,
	500+delt+10, 550+40,
	20, 5,
	hitTemp
);

endmodule
