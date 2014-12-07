`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:33:18 11/21/2013 
// Design Name: 
// Module Name:    Ram 
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

  
module Ram(
    input CLK,
    input RST,
    input boot,
    input [15:0] addrin,
    input [15:0] datain,
    input MemRead,
    input MemWrite,
    input [15:0] pc,	
	 input tbre, tsre, data_ready,
	 output rdn, wrn,
    output ram1_en, ram2_en,
	 output reg ram1_oe, ram1_rw,
    output reg ram2_oe, ram2_rw,
    output [17:0] ram1_addr,
    output [17:0] ram2_addr,
    output [15:0] instruction,
    output [15:0] dataout,
    output reg RamSlot,
    inout [15:0] ram1_data,
    inout [15:0] ram2_data
    );

//系统程序区：0x0000~0x3FFF
//用户程序区：0x4000~0x7FFF
//系统数据区：0x8000~0xBDFF
//用户数据区：0xC000~0xFFFF
//串口1数据寄存器：0xBF00
//串口1状态寄存器：0xBF01
//预留0xBF02-0xBF0F
//RAM编写规定：
//1. 汇编代码在每次读写串口之前检测串口是否可以读写
//2. 系统程序区只读

parameter S = 5'b00000,  NOP = 16'h0800;
parameter RAM1_WRITE = 5'b00001, RAM1_READ = 5'b00010, RAM1_DISABLE = 5'b00100,
          RAM2_NORMAL = 5'b00001, RAM2_READ = 5'b00010, RAM2_WRITE = 5'b00100,
			 PORT_READ = 5'b00001, PORT_WRITE = 5'b00010, PORT_DISABLE = 5'b00100,
			 INS_NORMAL = 5'b00001, INS_NOP = 5'b00010, 
			 OUT_RAM1DATA = 5'b00001, OUT_RAM2DATA = 5'b00010, OUT_PORTSIGN = 5'b00100, OUT_ZERO = 5'b01000;

reg bus1_read, bus2_read, com_read;

wire RSTboot;
wire[1:0] address_flag;
wire[11:0] address_flag2;
wire com_readSign, com_writeSign;


reg[4:0] state, ram1State, ram2State, portState, insState, outState, slotState;

assign RSTboot = RST && boot;
assign address_flag = addrin[15:14];
assign address_flag2 = addrin[15:4];

assign ram1_data = (bus1_read)? 16'bzzzzzzzzzzzzzzzz: ((com_read)?16'b00000000zzzzzzzz: datain);	 
assign ram2_data = (bus2_read)? 16'bzzzzzzzzzzzzzzzz: datain;

assign com_readSign = (data_ready == 1'b1) ? 1'b1: 1'b0;
assign com_writeSign = (tbre == 1'b1 && tsre == 1'b1)? 1'b1: 1'b0;

assign ram1_addr = {2'b00, addrin};
assign ram2_addr = (ram2State == RAM2_NORMAL)? ({2'b00, pc}):({2'b00, addrin});
assign instruction = (insState == INS_NORMAL)?(ram2_data):(16'h0800);
assign dataout = (outState == OUT_RAM1DATA)?(ram1_data):
                 ((outState == OUT_RAM2DATA)?(ram2_data):
					  ((outState == OUT_PORTSIGN)?({14'b00000000000000, com_readSign, com_writeSign}):
					  (16'h0000)));
assign ram1_en = (ram1State == RAM1_DISABLE)? 1'b1:1'b0;
assign ram2_en = 1'b0;

assign rdn = (portState == PORT_READ)? 1'b0: 1'b1;
assign wrn = (portState == PORT_WRITE)? 1'b0: 1'b1;


/*assign ram1_oe = (ram1State == RAM1_READ)? 1'b0: 1'b1;
assign ram1_rw = (ram1State == RAM1_WRITE && CLK == 1'b1)? 1'b0: 1'b1;
assign ram2_oe = (ram2State == RAM2_WRITE)? 1'b1:1'b0;
assign ram2_rw = (ram2State == RAM2_WRITE && CLK == 1'b1)? 1'b0: 1'b1;*/

always @(ram1State, CLK)
begin
    case(ram1State)
	     RAM1_READ: begin
		  		if(CLK == 1) begin
		          ram1_oe = 1'b1;
		          ram1_rw = 1'b1;					
				end
				else begin
		          ram1_oe = 1'b0;
		          ram1_rw = 1'b1;					
				end	
	      
		  end
		  RAM1_WRITE: begin
		      if(CLK == 1) begin
		          ram1_oe = 1'b1;
		          ram1_rw = 1'b1;					
				end
				else begin
		          ram1_oe = 1'b1;
		          ram1_rw = 1'b0;					
				end		  	  
		  end
		  default: begin   //disable
		      ram1_oe = 1'b1;
		      ram1_rw = 1'b1;		  
		  end
	endcase
end

always @(ram2State, CLK)
begin
    case(ram2State)
	 	  RAM2_READ: begin
		  		if(CLK == 1) begin
		          ram2_oe = 1'b1;
		          ram2_rw = 1'b1;					
				end
				else begin
		          ram2_oe = 1'b0;
		          ram2_rw = 1'b1;					
				end      
		  end
		  RAM2_WRITE: begin
				if(CLK == 1) begin
		          ram2_oe = 1'b1;
		          ram2_rw = 1'b1;					
				end
				else begin
		          ram2_oe = 1'b1;
		          ram2_rw = 1'b0;					
				end
		  end
		  default: begin   //normal, read
		      ram2_oe = 1'b0;
		      ram2_rw = 1'b1;
		  end	 		  
    endcase
end

/*
always @(negedge RSTboot, posedge CLK)
begin
    if(RSTboot == 0) begin
		  //state <= STATE_RST;
	     tmp_addrin <= 0;
		  tmp_datain <= 16'h0000;	
	     tmemRead <= 0;
		  tmemWrite <= 0;
	 end
    else begin  
		  tmp_addrin <= addrin;		
		  tmp_datain <= datain;
		  tmemRead <= MemRead;
		  tmemWrite <= MemWrite;
    end
end*/


always @(MemRead, MemWrite, addrin)
begin
	  if(MemRead == 1'b1 || MemWrite == 1'b1) begin
			case (address_flag)
			  2'b00: begin                    //read sys code
					if(MemRead) begin
					  bus2_read <= 1'b1;
					end
					else begin						//write sys code_not allowed
					  bus2_read <= 1'b1;
					end
			  end 
			  2'b01: begin                   //read usr code
					if(MemRead) begin
					  bus2_read <= 1'b1;
					end
					else begin                //write usr code
					  bus2_read <= 1'b0;
					end				  
			  end
			  default: begin
				  case(address_flag2)
					 12'hbf0: begin              
						 if(addrin[0] == 1'b0) begin      //read com
							if(MemRead) begin
							  bus2_read <= 1'b1;							  
							end
							else begin                    //write com
							  bus2_read <= 1'b1;
							end				  							     
						 end
						 else begin
							  bus2_read <= 1'b1;
						 end

					 end
					 default: begin
							if(MemRead) begin        //load RAM1 data
							  bus2_read <= 1'b1;
							end
							else begin               //store RAM1 data
							  bus2_read <= 1'b1;
							end
					 end								
				  endcase
				end
			endcase				
	  end
	  else begin
			  bus2_read <= 1'b1;		  
	  end
	
end


always @(MemRead, MemWrite, addrin)
begin
	  if(MemRead == 1'b1 || MemWrite == 1'b1) begin
			case (address_flag)
			  2'b00: begin                    //read sys code
					if(MemRead) begin
					  RamSlot <= 1'b1;
					  bus1_read <= 1'b1;
					 // bus2_read <= 1'b1;
					  com_read <= 1'b0;
					end
					else begin						//write sys code_not allowed
					  RamSlot <= 1'b1;
					  bus1_read <= 1'b1;
					 // bus2_read <= 1'b1;
					  com_read <= 1'b0;
					end
			  end 
			  2'b01: begin                   //read usr code
					if(MemRead) begin
					  RamSlot <= 1'b1;
					  bus1_read <= 1'b1;
					 // bus2_read <= 1'b1;
					  com_read <= 1'b0;
					end
					else begin                //write usr code
					  RamSlot <= 1'b1;
					  bus1_read <= 1'b1;
					 // bus2_read <= 1'b0;
					  com_read <= 1'b0;

					end				  
			  end
			  default: begin
				  case(address_flag2)
					 12'hbf0: begin              
						 if(addrin[0] == 1'b0) begin      //read com
							if(MemRead) begin
							  RamSlot <= 1'b0;
							  bus1_read <= 1'b0;
							 // bus2_read <= 1'b1;
							  com_read <= 1'b1;								  
							end
							else begin                    //write com
							  RamSlot <= 1'b0;
							  bus1_read <= 1'b0;
							 // bus2_read <= 1'b1;
							  com_read <= 1'b0;
							end				  							     
						 end
						 else begin
							  RamSlot <= 1'b0;								  
							  bus1_read <= 1'b1;
							  //bus2_read <= 1'b1;
							  com_read <= 1'b0;
						 end

					 end
					 default: begin
							if(MemRead) begin        //load RAM1 data
							  RamSlot <= 1'b0;								  
							  bus1_read <= 1'b1;
							 // bus2_read <= 1'b1;
							  com_read <= 1'b0;
							end
							else begin               //store RAM1 data
							  RamSlot <= 1'b0;								  
							  bus1_read <= 1'b0;
							 // bus2_read <= 1'b1;
							  com_read <= 1'b0;
							end
					 end								
				  endcase
				end
			endcase				
	  end
	  else begin
			  RamSlot <= 1'b0;
			  bus1_read <= 1'b1;
			 // bus2_read <= 1'b1;
			  com_read <= 1'b0;				  
	  end
	
end

always @(MemRead, MemWrite, addrin)
begin
	  if(MemRead == 1'b1 || MemWrite == 1'b1) begin
			case (address_flag)
			  2'b00: begin                    //read sys code
					if(MemRead) begin
					  ram1State <= RAM1_DISABLE;
					  ram2State <= RAM2_READ;
					  portState <= PORT_DISABLE;
					  insState <= INS_NOP;
					  outState <= OUT_RAM2DATA;
					end
					else begin						//write sys code_not allowed
					  ram1State <= RAM1_DISABLE;
					  ram2State <= RAM2_READ;
					  portState <= PORT_DISABLE;
					  insState <= INS_NOP;
					  outState <= OUT_ZERO;
					end
			  end 
			  2'b01: begin                   //read usr code
					if(MemRead) begin
					  ram1State <= RAM1_DISABLE;
					  ram2State <= RAM2_READ;
					  portState <= PORT_DISABLE;
					  insState <= INS_NOP;
					  outState <= OUT_RAM2DATA;
					end
					else begin                //write usr code
					  ram1State <= RAM1_DISABLE;
					  ram2State <= RAM2_WRITE;
					  portState <= PORT_DISABLE;
					  insState <= INS_NOP;
					  outState <= OUT_ZERO;

					end				  
			  end
			  default: begin
				  case(address_flag2)
					 12'hbf0: begin              
						 if(addrin[0] == 1'b0) begin      //read com
							if(MemRead) begin
							  ram1State <= RAM1_DISABLE;
							  ram2State <= RAM2_NORMAL;
							  portState <= PORT_READ;
							  insState <= INS_NORMAL;
							  outState <= OUT_RAM1DATA;							  
							end
							else begin                    //write com
							  ram1State <= RAM1_DISABLE;
							  ram2State <= RAM2_NORMAL;
							  portState <= PORT_WRITE;
							  insState <= INS_NORMAL;
							  outState <= OUT_ZERO;
							end				  							     
						 end
						 else begin
							  ram1State <= RAM1_DISABLE;
							  ram2State <= RAM2_NORMAL;
							  portState <= PORT_DISABLE;
							  insState <= INS_NORMAL;
							  outState <= OUT_PORTSIGN;
						 end

					 end
					 default: begin
							if(MemRead) begin        //load RAM1 data
							  ram1State <= RAM1_READ;
							  ram2State <= RAM2_NORMAL;
							  portState <= PORT_DISABLE;
							  insState <= INS_NORMAL;
							  outState <= OUT_RAM1DATA;
							end
							else begin               //store RAM1 data
							  ram1State <= RAM1_WRITE;
							  ram2State <= RAM2_NORMAL;
							  portState <= PORT_DISABLE;
							  insState <= INS_NORMAL;
							  outState <= OUT_ZERO;
							end
					 end								
				  endcase
				end
			endcase				
	  end
	  else begin
			  ram1State <= RAM1_DISABLE;
			  ram2State <= RAM2_NORMAL;
			  portState <= PORT_DISABLE;
			  insState <= INS_NORMAL;
			  outState <= OUT_ZERO;	  
	  end
	
end

/*
always @(negedge RSTboot, posedge CLK)
begin
    if(RSTboot == 0) begin
		  //state <= STATE_RST;	  
		  ram1State <= RAM1_DISABLE;
		  ram2State <= RAM2_NORMAL;
		  portState <= PORT_DISABLE;
		  insState <= INS_NORMAL;
		  outState <= OUT_ZERO;
		  RamSlot <= 1'b0;		  
		  bus1_read <= 1'b1;
		  bus2_read <= 1'b1;
		  com_read <= 1'b0;
	 end
    else begin  
	     if(MemRead == 1'b1 || MemWrite == 1'b1) begin
		      case (address_flag)
              2'b00: begin                    //read sys code
				      if(MemRead) begin
						  ram1State <= RAM1_DISABLE;
						  ram2State <= RAM2_READ;
						  portState <= PORT_DISABLE;
						  insState <= INS_NOP;
						  outState <= OUT_RAM2DATA;
						  RamSlot <= 1'b1;
						  bus1_read <= 1'b1;
						  bus2_read <= 1'b1;
						  com_read <= 1'b0;
						end
						else begin						//write sys code_not allowed
						  ram1State <= RAM1_DISABLE;
						  ram2State <= RAM2_READ;
						  portState <= PORT_DISABLE;
						  insState <= INS_NOP;
						  outState <= OUT_ZERO;
						  RamSlot <= 1'b1;
						  bus1_read <= 1'b1;
						  bus2_read <= 1'b1;
						  com_read <= 1'b0;
						end
				  end 
				  2'b01: begin                   //read usr code
				      if(MemRead) begin
						  ram1State <= RAM1_DISABLE;
						  ram2State <= RAM2_READ;
						  portState <= PORT_DISABLE;
						  insState <= INS_NOP;
						  outState <= OUT_RAM2DATA;
						  RamSlot <= 1'b1;
						  bus1_read <= 1'b1;
						  bus2_read <= 1'b1;
						  com_read <= 1'b0;
						end
						else begin                //write usr code
						  ram1State <= RAM1_DISABLE;
						  ram2State <= RAM2_WRITE;
						  portState <= PORT_DISABLE;
						  insState <= INS_NOP;
						  outState <= OUT_ZERO;
						  RamSlot <= 1'b1;
						  bus1_read <= 1'b1;
						  bus2_read <= 1'b0;
						  com_read <= 1'b0;

						end				  
				  end
              default: begin
				     case(address_flag2)
					    12'hbf0: begin              
						    if(addrin[0] == 1'b0) begin      //read com
								if(MemRead) begin
								  ram1State <= RAM1_DISABLE;
								  ram2State <= RAM2_NORMAL;
								  portState <= PORT_READ;
								  insState <= INS_NORMAL;
								  outState <= OUT_RAM1DATA;
								  RamSlot <= 1'b0;
								  bus1_read <= 1'b0;
								  bus2_read <= 1'b1;
                          com_read <= 1'b1;								  
								end
								else begin                    //write com
								  ram1State <= RAM1_DISABLE;
								  ram2State <= RAM2_NORMAL;
								  portState <= PORT_WRITE;
								  insState <= INS_NORMAL;
								  outState <= OUT_ZERO;
								  RamSlot <= 1'b0;
                          bus1_read <= 1'b0;
								  bus2_read <= 1'b1;
 								  com_read <= 1'b0;
								end				  							     
							 end
							 else begin
								  ram1State <= RAM1_DISABLE;
								  ram2State <= RAM2_NORMAL;
								  portState <= PORT_DISABLE;
								  insState <= INS_NORMAL;
								  outState <= OUT_PORTSIGN;
								  RamSlot <= 1'b0;								  
                          bus1_read <= 1'b1;
								  bus2_read <= 1'b1;
								  com_read <= 1'b0;
							 end

						 end
						 default: begin
								if(MemRead) begin        //load RAM1 data
								  ram1State <= RAM1_READ;
								  ram2State <= RAM2_NORMAL;
								  portState <= PORT_DISABLE;
								  insState <= INS_NORMAL;
								  outState <= OUT_RAM1DATA;
								  RamSlot <= 1'b0;								  
                          bus1_read <= 1'b1;
								  bus2_read <= 1'b1;
								  com_read <= 1'b0;
								end
								else begin               //store RAM1 data
								  ram1State <= RAM1_WRITE;
								  ram2State <= RAM2_NORMAL;
								  portState <= PORT_DISABLE;
								  insState <= INS_NORMAL;
								  outState <= OUT_ZERO;
								  RamSlot <= 1'b0;								  
                          bus1_read <= 1'b0;
								  bus2_read <= 1'b1;
								  com_read <= 1'b0;
								end
                   end								
				     endcase
					end
            endcase				
		  end
		  else begin
				  ram1State <= RAM1_DISABLE;
				  ram2State <= RAM2_NORMAL;
				  portState <= PORT_DISABLE;
				  insState <= INS_NORMAL;
				  outState <= OUT_ZERO;
				  RamSlot <= 1'b0;
				  bus1_read <= 1'b1;
				  bus2_read <= 1'b1;
              com_read <= 1'b0;				  
        end
	end
end
*/
endmodule

/*always @(portState, CLK)
begin
    case(portState)
	     PORT_READ: begin
					rdn = 1'b0;
					wrn = 1'b1;						  
		  end
		  PORT_WRITE: begin
					rdn = 1'b1;
					wrn = 1'b0;					  
		  end
		  default: begin
		      rdn = 1'b1;
				wrn = 1'b1;			  
		  end
	endcase
end*/