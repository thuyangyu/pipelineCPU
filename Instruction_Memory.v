`timescale 1ns / 1ps
//!!! we do not have the initialization stage, so that we always need to have the CPU reset before working

module Instruction_Memory(
    input CLK,
    input RST,
    input [15:0]address,
    output reg [15:0] instruction,
    
    //this actually control the real memory
    output RAM2OE,
    output RAM2WE,
    output RAM2EN,
    output [17:0]RAM2ADDR,
    inout [15:0] RAM2DATA
);

//these are the buffers of the outputs
reg OEBuffer;
reg WEBuffer;
reg ENBuffer;

reg [15:0] DATABuffer;
reg [17:0] ADDRBuffer;


//assign those buffers
assign RAM2OE = OEBuffer;
assign  RAM2WE = WEBuffer;
assign RAM2EN = ENBuffer;
assign RAM2ADDR[17:0] = ADDRBuffer[17:0];
assign RAM2DATA[15:0] =  16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;



parameter   S0 = 1'b0,
S1 = 1'b1;

reg state;//you can not assign the register value outside of the always block
reg nextState;

always @ (posedge CLK, negedge RST)
begin
    if(!RST)begin

        OEBuffer <= 1'b1;
		WEBuffer <= 1'b1;
		ENBuffer <= 1'b1;
        DATABuffer[15:0] <= 16'b0000_1000_0000_0000;//NOP instruction
		ADDRBuffer[17:0] <= 18'b0;
        
    end
    else begin
        case(state)
        S0:begin
            ENBuffer <= 1'b0;//the 0 is enable
            WEBuffer <= 1'b1;
            OEBuffer <= 1'b1;
            ADDRBuffer[17:0] <= {2'b0,address[15:0]};
        end
        
        S1:begin
            ENBuffer <= 1'b0;//the 0 is enable
            WEBuffer <= 1'b1;
            OEBuffer <= 1'b0;
            ADDRBuffer[17:0] <= {2'b0,address[15:0]};
            instruction[15:0] <= RAM2DATA[15:0]; 
            
        end
        
        endcase
    end

end


//control the next state
always @(posedge CLK, negedge RST)
begin
    if(!RST)begin
        nextState = S0;
    end
    else begin
        case(state)
            S0:begin
                nextState = S1;
            end
            
            S1:begin
                nextState = S0;
            end
        endcase
    end
end

always @(posedge CLK) 
begin
	state <= nextState;
end


endmodule