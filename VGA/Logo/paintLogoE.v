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
module paintLogoE(
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

paintRect e1(
	1,
	x, y,
	500+delt+10, 550,
	20, 5,
	hitTemp
);

paintRect e2(
	1,
	x, y,
	500+delt+10, 550+40,
	20, 5,
	hitTemp
);

paintRect e3(
	1,
	x, y,
	500+delt+10, 550,
	5, 40,
	hitTemp
);

paintRect e4(
	1,
	x, y,
	500+delt+10, 550+20,
	20, 5,
	hitTemp
);


endmodule
