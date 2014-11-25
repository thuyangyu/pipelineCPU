`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:14:26 11/03/2014 
// Design Name: 
// Module Name:    memaccess 
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
module MemoryController(
//input
	SW,
	CLK,
	RST,
	BUTTON,
	L,
	RAM1OE,
	RAM1WE,
	RAM1EN,
	RAM1ADDR,
	RAM1DATA,
	//output
	DYP0A,
	DYP0B,
	DYP0C,
	DYP0D,
	DYP0E,
	DYP0F,
	DYP0G,
	ONE1,
	ONE2
);

output [15:0] L;
output RAM1OE;
output RAM1WE;
output RAM1EN;
output ONE1,ONE2;
output DYP0A,DYP0B,DYP0C,DYP0D,DYP0E,DYP0F,DYP0G;//for the seven segment
output [17:0] RAM1ADDR;
inout [15:0] RAM1DATA;

input [15:0] SW;
input CLK;//this should be the 11MHz real clock
input RST;
input BUTTON;

//these are the buffers of the outputs
reg OEBuffer;
reg WEBuffer;
reg ENBuffer;
reg [15:0] LEDBuffer;
reg [15:0] DATABuffer;
reg [17:0] ADDRBuffer;

assign RAM1OE = OEBuffer;
assign  RAM1WE = WEBuffer;
assign RAM1EN = ENBuffer;
assign L[15:0] = LEDBuffer[15:0];//this is the format
assign RAM1ADDR[17:0] = ADDRBuffer[17:0];
//is this right, use this website :http://electronics.stackexchange.com/questions/22220/how-to-assign-value-to-bidirectional-port-in-verilog
assign RAM1DATA[15:0] = (RAM1WE) ? 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ : DATABuffer;
assign ONE1 = 1'b1;//this is always one to disable
assign ONE2 = 1'b1;


//the only inputs
reg [15:0] addrBase;

reg signed[7:0] dataCounter;//this is the counter for number of data

parameter   S0 = 4'd0,//the initial state
S1 = 4'd1,//get the addr input and display
S2 = 4'd2,//get the data input and display
S3 = 4'd3,
S4 = 4'd4,
S5 = 4'd5,
S6 = 4'd6,
S7 = 4'd7,
S8 = 4'd8;

reg [3:0] state;//you can not assign the register value outside of the always block
reg [3:0] nextState;

//for the seven segment
reg [6:0] segmentResult;
assign DYP0G = segmentResult[0];
assign DYP0F = segmentResult[1];
assign DYP0E = segmentResult[2];
assign DYP0D = segmentResult[3];
assign DYP0C = segmentResult[4];
assign DYP0B = segmentResult[5];
assign DYP0A = segmentResult[6];
//Seg7LUT seg7(segmentResult[6:0],state[3:0],1'b1);
//Seg7LUT seg7({DYP0G,DYP0F,DYP0E,DYP0D,DYP0C,DYP0B,DYP0A},7'b0110110,1'b0,1'b1);




reg buttonTriggered;//this is the signal that a button is pushed by the user
reg formerButton;// the register to remember the last button value

reg [7:0] beginCounter;//this is an initialization counter that deal with the start state
initial//this is the only place that we can use the initial counter
begin
	beginCounter <= 8'hFF;
end

always @ (posedge CLK)
begin
	if(beginCounter != 8'h0) beginCounter <= beginCounter - 8'h1;
end

//this part deal with the button triggered
always @(posedge CLK)
begin
	if (beginCounter != 8'h0)
		formerButton <= 1'b1;
	else
		formerButton <= BUTTON;
	
end

always @ (posedge CLK, negedge RST)
begin
	if(!RST)
		buttonTriggered <= 1'b0;
	else
		begin
			if({formerButton,BUTTON} == 2'b10)
				buttonTriggered <= 1'b1;
			else 
				buttonTriggered <= 1'b0;
		end
	
end

//this part deal with the states and the state changes
always @(posedge CLK)
begin
    if(beginCounter != 8'h0)
			state <= S0;
	 else
	   state <= nextState;
end

//only change the state if the button is accually pushed
always @(posedge buttonTriggered, negedge RST)
begin
	if(!RST)
		nextState <= S1;
	else
		begin
			case(state)
			S0:	nextState <= S1;
			S1:	nextState <= S2;
			S2:	nextState <= S3;
			S3:	nextState <= S4;
			S4:	nextState <= S5;
			S5:	begin
						if(dataCounter > 8'd0)
							nextState <= S4;
						else
							nextState <= S6;
					end
			S6:	nextState <= S7;
			S7:	nextState <= S8;
			S8:	begin
						if(dataCounter > 8'd0)
							nextState <= S7;
						else
							nextState <= S1;
					end
			endcase
		end
	
end


always @ (posedge buttonTriggered, negedge RST)
begin
	if(!RST)
		begin
			LEDBuffer[15:0] <= 16'b0;
			addrBase[15:0] <= 16'b0;
			dataCounter[7:0] <= 8'd10;
			OEBuffer <= 1'b1;
			WEBuffer <= 1'b1;
			ENBuffer <= 1'b0;
			DATABuffer[15:0] <= 16'b0;
			ADDRBuffer[17:0] <= 18'b0;
			segmentResult[6:0] <= 7'b0000001;

		end
	else
		begin
		case(state)
			S0: 
				begin
					LEDBuffer[15:0] <= 16'b0;
					addrBase[15:0] <= 16'b0;
					dataCounter[7:0] <= 8'd10;
					OEBuffer <= 1'b1;
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					DATABuffer[15:0] <= 16'b0;
					ADDRBuffer[17:0] <= 18'b0;
					segmentResult[6:0] <= 7'b1111110;
				end
			S1: 
				begin
					LEDBuffer[15:0] <= SW[15:0];//*
					addrBase[15:0] <= SW[15:0];//*
					dataCounter[7:0] <= 8'd10;
					OEBuffer <= 1'b1;
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					DATABuffer[15:0] <= 16'b0;
					ADDRBuffer[17:0] <= {2'b0,SW[15:0]};//*  this mean changed
					segmentResult[6:0] <= 7'b0110000;
				end
				
			S2: 
				begin
		
					LEDBuffer[15:0] <= SW[15:0];
					dataCounter[7:0] <= 8'd10;
					
					OEBuffer <= 1'b1;
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					DATABuffer[15:0] <= SW[15:0];//*
					segmentResult[6:0] <= 7'b1101101;
					
				end
				
			S3:
				begin
					LEDBuffer[15:0] <= {ADDRBuffer[7:0],DATABuffer[7:0]};
					dataCounter <= 8'd9;
					OEBuffer <= 1'b1;
					WEBuffer <= 1'b0;
					ENBuffer <= 1'b0;
					segmentResult[6:0] <= 7'b1111001;
				end


			S4: 
				begin
					//LEDBuffer[15:0] <= {ADDRBuffer[7:0],DATABuffer[7:0]};//we should not use this
					OEBuffer <= 1'b1;
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					DATABuffer[15:0] <= DATABuffer[15:0] + 16'b1;
					ADDRBuffer[17:0] <= ADDRBuffer[17:0] + 18'b1;//is this right???
					
					segmentResult[6:0] <= 7'b0110011;
				end
			
			S5: 
				begin
					LEDBuffer[15:0] <= {ADDRBuffer[7:0],DATABuffer[7:0]};
					dataCounter <= dataCounter - 8'd1;
					OEBuffer <= 1'b1;
					WEBuffer <= 1'b0;
					ENBuffer <= 1'b0;
					
					segmentResult[6:0] <= 7'b1011011;
				end
			S6: 
				begin
					//LEDBuffer[15:0] <= {ADDRBuffer[7:0],RAM1DATA[7:0]};//this could not be used
					dataCounter <= 8'd9;
					OEBuffer <= 1'b0;
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					ADDRBuffer[17:0] <= {2'b0,addrBase[15:0]};
					segmentResult[6:0] <= 7'b1011111;
					
				end
			S7: 
				begin
					LEDBuffer[15:0] <= {ADDRBuffer[7:0],RAM1DATA[7:0]};
					OEBuffer <= 1'b0;
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					segmentResult[6:0] <= 7'b1110000;
				end
			S8: 
				begin
					//LEDBuffer[15:0] <= {ADDRBuffer[7:0],RAM1DATA[7:0]};//this should not happen
					dataCounter <= dataCounter - 8'd1;
					OEBuffer <= 1'b1;//not enable?? is that right??
					WEBuffer <= 1'b1;
					ENBuffer <= 1'b0;
					ADDRBuffer[17:0] <= ADDRBuffer[17:0] + 18'b1;
					segmentResult[6:0] <= 7'b1111111;
				end


		endcase
		end
end



endmodule
