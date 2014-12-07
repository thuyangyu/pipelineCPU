`timescale 1ns / 1ps

module MemoryController(
    input CLK,
    input CLK_half,
    input RST,
    input [15:0]address,
	input [15:0]dataIn,
    
    input [1:0] memRead,
	input [1:0] memWrite,
        
    output reg [15:0] dataOut,
    
    //this actually control the real memory
    output reg ram1OE,
	output reg ram1WE,
	output reg ram1EN,
	output [17:0]ram1Addr,
	inout [15:0]ram1Data,
    
    //input , output for the serial port
	input tbre,
    input tsre,
    input data_ready,
    output reg rdn,
    output reg wrn
);


//wire state1;
wire state2;
wire state3;
//wire state4;
wire shiftCLK;
//assign state1 = CLK & CLK_half;
assign state2 = ~CLK & CLK_half;
assign state3 = CLK & ~CLK_half;
//assign state4 = ~CLK & ~CLK_half;
assign shiftCLK = state2 | state3;



parameter 
	S0 = 1'd0,
	S1 = 1'd1;
	
	
wire read;
wire write;
assign read = (memRead[1:0] == 2'b01 || memRead[1:0] == 2'b10) && (memWrite[1:0] == 2'b00 );
assign write = (memWrite[1:0] == 2'b01 || memWrite[1:0] == 2'b10) && (memRead[1:0] == 2'b00 );

//wire portRead;
//wire portWrite;
//assign portRead = (readMem && (address[15:0] == 16'hBF00));
//assign portWrite = (writeMem && (address[15:0] == 16'hBF00));


assign ram1Data[15:0] = write ? dataIn: 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;//choose between write and read

assign ram1Addr[17:0] = {2'b0, address[15:0]};

always @ (*)
begin
    if(!RST)begin
      ram1OE = 1'b1;
		ram1WE = 1'b1;
		ram1EN = 1'b1;
		wrn = 1'b1;
		rdn = 1'b1;
		dataOut[15:0] = ram1Data[15:0];
    end
    else begin
        case(shiftCLK)  //in negedge of CLK
        S1:
			begin
			case(address)
				16'hBF00:
					ram1EN = 1'b1;
				16'hBF01:
					ram1EN = 1'b1;
				default:
					ram1EN = 1'b0;
			endcase
			wrn = 1'b1;
			rdn = 1'b1;
			ram1OE = 1'b1;
            ram1WE = 1'b1;
			dataOut[15:0] = ram1Data[15:0];
            end
        
        S0:
            begin
            if(read)begin
				case(address)
						16'hBF00:
							begin
								ram1OE = 1'b1;
								ram1WE = 1'b1;
								ram1EN = 1'b1;
								wrn = 1'b1;
								rdn = 1'b0;
								dataOut[15:0] = ram1Data[15:0];
							end
						16'hBF01:
							begin
								
								ram1OE = 1'b1;
								ram1WE = 1'b1;
								ram1EN = 1'b1;
								wrn = 1'b1;
								rdn = 1'b1;
								dataOut[15:2] = 14'b0;
								dataOut[1] = data_ready ? 1'b1: 1'b0;
								dataOut[0] = (tsre && tbre) ? 1'b1: 1'b0;
							end
						default:
							begin				
								ram1OE = 1'b0;//enable the read
								ram1WE = 1'b1;
								ram1EN = 1'b0;
								wrn = 1'b1;
								rdn = 1'b1;
								dataOut[15:0] = ram1Data[15:0];
							end
				endcase
            end 
			else if(write) 
			begin
				case(address)
						16'hBF00:
							begin
								ram1OE = 1'b1;
								ram1WE = 1'b1;
								ram1EN = 1'b1;
								wrn = 1'b0;
								rdn = 1'b1;
								dataOut[15:0] = 16'b0; //invalid
							end
						default:
							begin
								wrn = 1'b1;
								rdn = 1'b1;
								ram1OE = 1'b1;
								ram1WE = 1'b0;//enable the write
								ram1EN = 1'b0; 
								dataOut[15:0] = 16'b0; //invalid;
							end
				endcase //end of case address
            end //end of if write
			else begin
				ram1OE = 1'b1;
				ram1WE = 1'b1;
				ram1EN = 1'b1;
				wrn = 1'b1;
				rdn = 1'b1;
				dataOut[15:0] = ram1Data[15:0];
			end
        end //end of S1 begin
		  
		  default:
		  begin
				ram1OE = 1'b1;
				ram1WE = 1'b1;
				ram1EN = 1'b1;
				wrn = 1'b1;
				rdn = 1'b1;
				dataOut[15:0] = ram1Data[15:0];
		  end
        endcase
    end //end of else of RST
end //end of always

endmodule
