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
module paintLogoB(
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

paintRect b1(
	1,
	x, y,
	500+delt+10, 550,
	5, 40,
	hitTemp
);

paintRect b2(
	1,
	x, y,
	500+delt+10, 550,
	20, 5,
	hitTemp
);

paintRect b3(
	1,
	x, y,
	500+delt+10, 550+40,
	20, 5,
	hitTemp
);

paintRect b4(
	1,
	x, y,
	500+delt+10, 550+20,
	10, 5,
	hitTemp
);

paintRect b5(
	1,
	x, y,
	500+delt+30, 550,
	5, 10,
	hitTemp
);

paintRect b6(
	1,
	x, y,
	500+delt+30, 550+30,
	5,10,
	hitTemp
);


paintPosPara b7(
	1,
	x, y,
	500+delt+30, 550+10,
	5, 10,
	hitTemp
);

paintNegPara b8(
	1,
	x, y,
	500+delt+20, 550+20,
	5, 10,
	hitTemp
);




endmodule
