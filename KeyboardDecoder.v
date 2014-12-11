//KeyboardDecoder 首先写一个独立于dynamo的模块实现，读入键盘上面的数字键并显示在LED上面。

//Verilog写代码中应当经常的注意事项：endcase和default问题。if elseif的问题，防止生成锁存器的问题。
module KeyboardDecoder(
	//CLOCK
	CLOCK_50,
	
	////////KEYS//////////
	KEYS,
	
	//HEX6,
	//HEX7,
	///////output directions///////
	forward,
	backward,
	left,
	right,
	up,
	down,
	////////LED////////////
	//LEDG,
	//LEDR,
	//////// PS2 //////////
	PS2_CLK,
	PS2_DAT
);

input CLOCK_50;
//////////// SEG7 //////////
input [3:0] KEYS;
//output [17:0] LEDR;
//output [6:0] HEX6;
//output [6:0] HEX7; 
//output [7:0] LEDG;
//////////// PS2 //////////
inout		          		PS2_CLK;
inout		          		PS2_DAT;

//这些输出的reg类型
output reg forward;
output reg backward;
output reg left;
output reg right;
output reg up;
output reg down;

//assign    LEDR[7] = forward 	;//=   LEDR[7];
//assign 	 LEDR[6] = backward	;//=	 LEDR[6];
//assign 	 LEDR[5] = left		;//	=	 LEDR[5];
//assign    LEDR[4] = right		;//=   LEDR[4];
//assign    LEDR[3] = up			;//=   LEDR[3];
//assign  	 LEDR[2] = down		;//	= 	 LEDR[2];
//assign 	 LEDR[1] = breaktrue;
wire [7:0] temp;//存储当前接受到的键盘发送值
parameter forwardsig =8'h75,
          backwardsig=8'h72,
          leftsig    =8'h6B,
          rightsig  	=8'h74,
			 upsig 		=8'h79,
			 downsig 	=8'h5A;

//Seg7LUT  seg7lut2(.segOut(HEX6), .enable(1'b1), .displayedNumber(temp[3:0]));
//Seg7LUT  seg7lut3(.segOut(HEX7), .enable(1'b1), .displayedNumber(temp[7:4]));
			 //键盘的边沿检测函数看来还是没有办法写成组合逻辑。
reg [7:0] pretemp/*synthesis noprune*/;//存储上一个时刻的temp值。
reg breaktrue/*synthesis noprune*/;//表示当前是否为断码释放状态
wire outend;

reg [20:0] clock_div/*synthesis noprune*/;
reg clock/*synthesis noprune*/;
always @ (posedge CLOCK_50)
begin
	clock_div = clock_div + 1;
	clock <= clock_div[8];
end
always @ (posedge clock, negedge KEYS[3])
	if(!KEYS[3]) 
		begin
			forward <= 1'b0;
			backward <= 1'b0;
			left <= 1'b0;
			right <= 1'b0;
			up <= 1'b0;
			down <= 1'b0;
			breaktrue <= 1'b0;
		end
	else
	begin
		pretemp <= temp;//始终记录之前的输出值
		if((temp == 8'hF0) && (pretemp != 8'hF0)) breaktrue <= 1'b1;//此时为断码状态。
		else if((temp == 8'h75) && (outend == 1'b1)) begin //在75的上边沿产生问题
			if(breaktrue) begin forward <= 1'b0; breaktrue <= 1'b0; end
			else forward <= 1'b1;
		end
		else if(temp == 8'h72 && outend == 1'b1) begin 
			if(breaktrue) begin backward <= 1'b0; breaktrue <= 1'b0; end
			else backward <= 1'b1;
		end
		else if(temp == 8'h6B && outend == 1'b1) begin 
			if(breaktrue) begin left <= 1'b0; breaktrue <= 1'b0; end
			else left <= 1'b1;
		end
		else if(temp == 8'h74 && outend == 1'b1) begin 
			if(breaktrue) begin right <= 1'b0; breaktrue <= 1'b0; end
			else right <= 1'b1;
		end
		else if(temp == 8'h79 && outend == 1'b1) begin 
			if(breaktrue) begin up <= 1'b0; breaktrue <= 1'b0; end
			else up <= 1'b1;
		end
		else if(temp == 8'h5A && outend == 1'b1) begin 
			if(breaktrue) begin down <= 1'b0; breaktrue <= 1'b0; end
			else down <= 1'b1;
		end
		
		else if(temp == 8'h77 && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h4A && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h7C && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h7b && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h6C && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h7d && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h73 && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h69 && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h7A && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h70 && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h66 && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
		else if(temp == 8'h71 && outend == 1'b1) begin 
			if(breaktrue) begin breaktrue <= 1'b0; end
		end
	end

//有效键盘
//75 8 forward
//74 6
//6b 4
//72 2
//79 +
//5A enter

//77 numberlock
//4A /
//7C *
//7b -
//6C 7
//7d 9
//73 5
//69 1
//7A 3
//70 0
//66 backspace
//71 .

keyboard U1(.iSTART(KEYS[3]),  //press the button for transmitting instrucions to device;
 .iRST_n(KEYS[1]),  //global reset signal;
 .iCLK_50(CLOCK_50),  //clock source;
 .PS2_CLK(PS2_CLK), //ps2_clock signal inout;
 .PS2_DAT(PS2_DAT), //ps2_data  signal inout;
 .y_latch(temp),
 .outend(outend)
 //.LEDState(LEDG[17:14]),
 //.LEDCNT(LEDR[13:6])
 );
 
endmodule 