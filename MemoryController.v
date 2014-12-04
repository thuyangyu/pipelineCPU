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
    
    //output for the serial port
    output data_ready_out,
    output rdn_out,
    output tbre_out,
    output tsre_out,
    output wrn_out
);


wire readMem;
wire writeMem;
assign readMem = (memRead[1:0] == 2'b01 || memRead[1:0] == 2'b10) && (memWrite[1:0] == 2'b00 )
assign writeMem = (memWrite[1:0] == 2'b01 || memWrite[1:0] == 2'b10) && (memRead[1:0] == 2'b00 )

assign ram1Data[15:0] = writeMem ? dataIn: 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;//choose between write and read

parameter   S0 = 1'b0,
S1 = 1'b1;

reg state;//you can not assign the register value outside of the always block
reg nextState;

always @ (posedge CLK, negedge RST)
begin
    if(!RST)begin

        ram1OE <= 1'b1;
		ram1WE <= 1'b1;
		ram1EN <= 1'b1;
		ram1Addr[17:0] <= 18'b0;
        
    end
    else begin
        case(state)
        S0:begin
            if(readMem)begin
                ram1OE <= 1'b1;
                ram1WE <= 1'b1;
                ram1EN <= 1'b0;//chip is always enabled, except reset
                ram1Addr[17:0] <= {2'b00, address[15:0]};
            end else if(writeMem) begin
                ram1OE <= 1'b1;
                ram1WE <= 1'b1;
                ram1EN <= 1'b0;//chip is always enabled, except reset
                ram1Addr[17:0] <= {2'b00, address[15:0]};
            end
        end
        
        S1:begin
            if(readMem)begin
                ram1OE <= 1'b0;//enable the read
                ram1WE <= 1'b1;
                ram1EN <= 1'b0;
                ram1Addr[17:0] <= {2'b00, address[15:0]};
                dataOut[15:0] = ram1Data[15:0];
            end else if(writeMem) begin
                ram1OE <= 1'b1;
                ram1WE <= 1'b0;//enable the write
                ram1EN <= 1'b0;
                ram1Addr[17:0] <= {2'b00, address[15:0]};
                
            end
            
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
