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
    
    //input , output for the serial port
	input tbre,
    input tsre,
    input data_ready,
    output rdn,
    output wrn
);

parameter 
	S0 = 4'd0,
	S1 = 4'd1,
	S2 = 4'd2,
	S3 = 4'd3;
	
	
wire read;
wire write;
assign read = (memRead[1:0] == 2'b01 || memRead[1:0] == 2'b10) && (memWrite[1:0] == 2'b00 );
assign write = (memWrite[1:0] == 2'b01 || memWrite[1:0] == 2'b10) && (memRead[1:0] == 2'b00 );

//wire portRead;
//wire portWrite;
//assign portRead = (readMem && (address[15:0] == 16'hBF00));
//assign portWrite = (writeMem && (address[15:0] == 16'hBF00));


assign ram1Data[15:0] = write ? dataIn: 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;//choose between write and read


reg state;//you can not assign the register value outside of the always block
reg nextState;

always @ (posedge CLK, negedge RST)
begin
    if(!RST)begin

        ram1OE <= 1'b1;
		ram1WE <= 1'b1;
		ram1EN <= 1'b1;
		ram1Addr[17:0] <= 18'b0;
        nextState <= S0;
		wrn <= 1'b1;
		rdn <= 1'b1;
    end
    else begin
        case(state)
        S0:begin
            if(read)begin
				if(!address[15:0] == 16'hBF00)
					begin
						wrn <= 1'b1;
						rdn <= 1'b1;
					end
				else 
					begin
						ram1OE <= 1'b1;
						ram1WE <= 1'b1;
						ram1EN <= 1'b0;//chip is always enabled, except reset
						ram1Addr[17:0] <= {2'b00, address[15:0]};
					end
            end 
			else if(write) begin
                ram1OE <= 1'b1;
                ram1WE <= 1'b1;
                ram1EN <= 1'b0;//chip is always enabled, except reset
                ram1Addr[17:0] <= {2'b00, address[15:0]};
            end
			nextState <= S1;
        end
        
        S1:begin
            if(read)begin
				
				if(!address[15:0] == 16'hBF00)
					begin
						wrn <= 1'b1;
						rdn <= 1'b0;
					end
				else 
					begin
						ram1OE <= 1'b0;//enable the read
						ram1WE <= 1'b1;
						ram1EN <= 1'b0;
						ram1Addr[17:0] <= {2'b00, address[15:0]};
						dataOut[15:0] = ram1Data[15:0];
					end
            end else if(write) begin
                ram1OE <= 1'b1;
                ram1WE <= 1'b0;//enable the write
                ram1EN <= 1'b0;
                ram1Addr[17:0] <= {2'b00, address[15:0]};   
            end
            nextState <= S2;
        end
		
		S2:
			begin
			nextState <= S3;
			end
			
		S3:
			begin
			nextState <= S0;
			end
        endcase
    end
end

always @(posedge CLK) 
begin
	state <= nextState;
end


endmodule
