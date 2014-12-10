`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:39:35 11/23/2013 
// Design Name: 
// Module Name:    VGAEngine 
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
module VGAScanner(
		input clk, rst,
		output reg hs, vs,
		output reg [10:0] x, y
    );

localparam H_RESOLUTION = 800,
			H_FRONT_PORCH = 56,
			H_SYNC_PULSE = 120,
			H_BACK_PORCH = 64,
			H_MAX = 1040;
localparam V_RESOLUTION = 600,
			V_FRONT_PORCH = 37,
			V_SYNC_PULSE = 6,
			V_BACK_PORCH = 23,
			V_MAX = 666;

always @(negedge clk, negedge rst)
begin
	if(rst == 0)
		x = 0;
	else
	begin
		if(x == H_MAX - 1)
			x = 0;
		else
			x = x + 1;
	end
end

always @(negedge clk, negedge rst)
begin
	if(rst == 0)
		y = 0;
	else
	begin
		if(x == H_MAX - 1)
			if(y == V_MAX - 1)
				y = 0;
			else
				y = y + 1;
	end
end

always @(negedge clk, negedge rst)
begin
	if(rst == 0)
		hs = 1;
	else
	begin
		if(x >= H_RESOLUTION + H_FRONT_PORCH - 1 && x < H_RESOLUTION + H_FRONT_PORCH + H_SYNC_PULSE - 1)
			hs = 0;
		else
			hs = 1;
	end
end

always @(negedge clk, negedge rst)
begin
	if(rst == 0)
		vs = 1;
	else
	begin
		if(y >= V_RESOLUTION + V_FRONT_PORCH - 1 && y < V_RESOLUTION + V_FRONT_PORCH + V_SYNC_PULSE - 1)
			vs = 0;
		else
			vs = 1;
	end
end

endmodule
