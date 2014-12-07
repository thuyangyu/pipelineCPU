module AllInOneRamController(
    input CLK,
    input CLK_half,
    input RST,
    
    //-------------below are for ram2
    input [15:0]ram2Address,
    output [15:0] instruction,
  
    output RAM2OE,
    output RAM2WE,
    output RAM2EN,
    output [17:0]RAM2ADDR,
    inout [15:0] RAM2DATA,
  
    //-------------below are for ram1
    input [15:0]ram1Address,
	input [15:0]dataIn,
    
    input [1:0] memRead,
	input [1:0] memWrite,
        
    output [15:0] dataOut,
   
    output ram1OE,
	output ram1WE,
	output ram1EN,
	output [17:0]ram1Addr,
	inout [15:0]ram1Data,
 
	input tbre,
    input tsre,
    input data_ready,
    output rdn,
    output wrn
);


//----------------------------this is for the ram2
//stash address in negedge of CLK_half
reg [15:0] addressBuffer;
always @ (negedge CLK_half)
	addressBuffer[15:0] <= ram2Address[15:0];

assign RAM2OE = CLK_half ^ CLK; //first quarter and fourth quarter
assign RAM2WE = 1'b1;//always disable
assign RAM2EN = 1'b0;//always enable
assign RAM2ADDR[17:0] = {2'b0, addressBuffer[15:0]};
assign RAM2DATA[15:0] =  16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;
assign instruction [15:0] = RAM2DATA[15:0];

    
    
//------------------------this is for the ram1    

reg [15:0] addressBuffer;
reg [15:0] dataInBuffer;
reg tbreBuffer;
reg tsreBuffer;
reg data_readyBuffer;
	
//LW and SW judge
wire readFlag;
wire writeFlag;
reg read;
reg write;
assign readFlag = read;
assign writeFlag = write;

//stash these inputs in negedge of CLK_half
always @ (negedge CLK_half)
begin
	read <= (memRead[1:0] == 2'b01 || memRead[1:0] == 2'b10) && (memWrite[1:0] == 2'b00 );     //need to ensure read must == !write
	write <= (memWrite[1:0] == 2'b01 || memWrite[1:0] == 2'b10) && (memRead[1:0] == 2'b00 );
	addressBuffer[15:0] <= ram1Address[15:0];
	dataInBuffer[15:0] <= dataIn[15:0];
	tbreBuffer <= tbre;
	tsreBuffer <= tsre;
	data_readyBuffer <= data_ready;
end

assign ram1Data[15:0] = writeFlag ? dataInBuffer: 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;//choose between write and read
assign ram1Addr[17:0] = {2'b0, addressBuffer[15:0]};

wire [15:0] SignalOut;
assign SignalOut[15:2] = 14'b0;
assign SignalOut[1] = data_readyBuffer ? 1'b1: 1'b0;
assign SignalOut[0] = (tsreBuffer && tbreBuffer) ? 1'b1: 1'b0;

//our cycle start from negedge of CLK_half
//combination
wire isPort = (addressBuffer[15:0] == 16'hBF00 || addressBuffer[15:0] == 16'hBF01);
assign ram1EN = isPort ? 1'b1: 1'b0;
assign ram1OE = (~isPort && readFlag && (~(CLK_half ^ CLK))) ? 1'b0: 1'b1;
assign ram1WE = (~isPort && writeFlag && (~(CLK_half ^ CLK))) ? 1'b0: 1'b1;
assign rdn = ((addressBuffer[15:0] == 16'hBF00) && readFlag &&   (~(CLK_half ^ CLK))) ? 1'b0: 1'b1;
assign wrn = (isPort && writeFlag && (~(CLK_half ^ CLK))) ? 1'b0: 1'b1;
assign dataOut[15:0] = readFlag ? ((addressBuffer[15:0] != 16'hBF01) ? ram1Data[15:0] : SignalOut) : 16'b0;






    
endmodule