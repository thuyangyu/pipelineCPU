`timescale 1ns / 1ps


module MemoryController(
    input CLK,
    input RST,
    input [15:0]address,
	input [15:0]dataIn,
    
    input [1:0] memRead,
	input [1:0]	memWrite,
        
    output reg [15:0] dataOut,
    
    //this actually control the real memory
    output reg ram1OE,
	output reg ram1WE,
	output reg ram1EN,
	output reg [17:0]ram1Addr,
	inout [15:0]ram1Data,
    
    //for the serial port
    output data_ready_out,
    output rdn_out,
    output tbre_out,
    output tsre_out,
    output wrn_out
);






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
