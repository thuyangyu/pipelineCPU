`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:03:28 10/21/2014 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input CLK,   //11.0592MHz B8 
    input RST,	  // reset U10
	input NXT,   //single step U9
    input [15:0] SW,
    output [15:0] L
    );
	 
	//state defination
	parameter 	 
			 S0 = 3'd0,//power on
			 S1 = 3'd1,//get input first and display a
			 S2 = 3'd2,//get input second and display second
			 S3 = 3'd3,//get input op and display op
			 S4 = 3'd4,//display result
             S5 = 3'd5;//display flag
	
	//op defination
	parameter
			 ADD = 4'd0, //A+B
			 SUB = 4'd1, //A-B
			 AND = 4'd2, //A and B
			 OR  = 4'd3, //A or B
			 XOR = 4'd4, //A xor B
			 NOT = 4'd5, //not A
			 SLL = 4'd6, //A sll B
			 SRL = 4'd7, //A srl B
			 SRA = 4'd8, //A sra B
			 ROL = 4'd9, //A rol B
			 DEFAULT = 4'd10;//initial value
	
	reg signed [15:0] first;
	reg signed [15:0] second;
	reg [3:0]  op;
	reg signed [15:0] result;
	reg flag_c,flag_n,flag_z,flag_v;

	reg [15:0] LEDbuf;
	assign L[15:0] = LEDbuf[15:0];
	
	//initial signal
	reg [7:0] initializationCounter;
	initial
	begin
		initializationCounter <= 8'hFF;
	end
	//count the initial signal
	always @ (posedge CLK)
	begin
		if(initializationCounter != 8'h0)	initializationCounter <= initializationCounter - 8'h1;
	end
	
	//state change
	reg [2:0] state;
	reg [2:0] next_state;
	always @ (posedge CLK)
	begin
		if(initializationCounter != 8'h0) 
        begin 
            state <= S0;
        end
		else 
			state <= next_state;	
	end
	
	//what to do in each state, and calculate next state
	always @ (posedge CLK, negedge RST)
		if(!RST)
			begin
			LEDbuf[15:0] <= 16'b0;
			first[15:0] <= 16'b0;
			second[15:0] <= 16'b0;
			op[3:0] <= DEFAULT;
			result[15:0] <= 16'b0;
			flag_c <= 1'b0;
			flag_n <= 1'b0;
			flag_z <= 1'b0;
			flag_v <= 1'b0;
			end
		else
		begin
			case(state)
			S0:
				begin
				LEDbuf[15:0] <= 16'b0;
				end
			S1:
				begin
				first[15:0] <= SW[15:0];
				LEDbuf[15:0] <= SW[15:0];
				end
			S2:
				begin
				second[15:0] <= SW[15:0];
				LEDbuf[15:0] <= SW[15:0];
				end
			S3:
				begin
				op[3:0] <= SW[3:0];
				LEDbuf[15:0] <= {12'b0, SW[3:0]};
				case(op)
					DEFAULT: 
						begin 
							result <= 16'b0; 
							flag_c <= 1'b0; 
							flag_n <= 1'b0;
							flag_z <= 1'b0;
							flag_v <= 1'b0;
						end
					ADD: 
						begin 
							result <= first + second;
							flag_c <= (first[15] & second[15])
											| (first[15] & ~result[15])
											| (second[15] & ~result[15]);
							flag_v <= (first[15] & second[15] & ~result[15])
											| (~first[15] & ~second[15] & result[15]);
						end

					SUB: 
						begin
							result <= first - second;
							flag_c <= (~first[15] & second[15])
									| (first[15] & second[15] & ~result[15])
									| (~first[15] & ~second[15] & result[15]);
							flag_v <= (first[15] & second[15] & ~result[15])
									| (~first[15] & ~second[15] & result[15]);
						end
					AND: begin result <= first & second;   flag_c <= 1'b0; flag_v <= 1'b0; end
					OR:  begin result <= first | second;   flag_c <= 1'b0; flag_v <= 1'b0; end
					XOR: begin result <= first ^ second;   flag_c <= 1'b0; flag_v <= 1'b0; end
					NOT: begin result <= ~first;		   flag_c <= 1'b0; flag_v <= 1'b0; end
					SLL: begin result <= first << second;  flag_c <= 1'b0; flag_v <= 1'b0; end
					SRL: begin result <= first >> second;  flag_c <= 1'b0; flag_v <= 1'b0; end
					SRA: begin result <= first >>> second; flag_c <= 1'b0; flag_v <= 1'b0; end
					ROL: 
						begin
							result <= (first << second) + (first >> (16'd16-second));
							flag_c <= 1'b0; 
							flag_v <= 1'b0;
						end
				endcase
				end
            S4:
            	begin
                LEDbuf[15:0] <= result[15:0];
                flag_n <= result[15]; //perfect
				if(result[15:0] == 16'b0) 
					flag_z <= 1'b1;
				else
					flag_z <= 1'b0;
				end
			S5: 
				LEDbuf[15:0] <= {12'b0,flag_c,flag_v,flag_n,flag_z};
			endcase
		end
		//$display("flag_c, flag_v, flag_n, flag_z is %b", L);
		//edge detection for NXT
		reg Pre_NXT;
		reg NXT_send;
		always @(posedge CLK)
		begin
			if(initializationCounter != 8'h0) 
				Pre_NXT <= 1'b1;
		    else
			    Pre_NXT <= NXT;
		end
		
		always @ (posedge CLK, negedge RST)
		if(!RST)
			NXT_send <= 1'b0;
		else
			begin
				if({Pre_NXT, NXT}==2'b10) 
					NXT_send <= 1'b1;
				else 
					NXT_send <= 1'b0;
			end
			
		//next_state choose using input signal
		always @ (posedge NXT_send, negedge RST)
		begin
			if(!RST)
				next_state <= S1;
			else
			begin
				case(state)
				S0:
					next_state <= S1;
				S1: 
					next_state <= S2;
				S2:
					next_state <= S3;
				S3:
					next_state <= S4;
				S4:
					next_state <= S5;
                S5:
                    next_state <= S1;
				endcase
			end
		end
endmodule
