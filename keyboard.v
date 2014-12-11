module keyboard(
           iSTART,   //press the button for transmitting instrucions to device;
           iRST_n,   //FSM reset signal;
           iCLK_50,  //clock source;
           PS2_CLK,  //ps2_clock signal inout;
           PS2_DAT,  //ps2_data  signal inout;
			  y_latch,
			  outend
//			  LEDState,
//			  LEDCNT
           ); 


input iSTART;
input iRST_n;
input iCLK_50;

inout PS2_CLK;
inout PS2_DAT;

parameter enable_byte =9'b011110100;

reg [1:0] cur_state,nex_state;
reg ce,de;
reg [3:0] byte_cnt,delay;
reg [5:0] ct;
output reg [7:0] y_latch;
output reg outend;
reg [7:0] cnt;
reg [8:0] clk_div;
reg [9:0] dout_reg;
reg [32:0] shift_reg;
reg       ps2_clk_in,ps2_clk_syn1,ps2_dat_in,ps2_dat_syn1;
wire      clk,ps2_dat_syn0,ps2_clk_syn0,ps2_dat_out,ps2_clk_out,flag;


parameter listen =2'b00,
          pullclk=2'b01,
          pulldat=2'b10,
          trans  =2'b11;

always@(posedge iCLK_50)
	begin
		clk_div <= clk_div+1;
	end
	
assign clk = clk_div[8];

//PS2时钟数据双向控制
assign PS2_CLK = ce?ps2_clk_out:1'bZ;
assign PS2_DAT = de?ps2_dat_out:1'bZ;
assign ps2_clk_out = 1'b0;
assign ps2_dat_out = dout_reg[0];
assign ps2_clk_syn0 = ce?1'b1:PS2_CLK;
assign ps2_dat_syn0 = de?1'b1:PS2_DAT;


always@(posedge clk)//可以确定的是分频之后的确定100kHz左右的时钟频率，要比键盘外设输入的时钟频率要快很多。
	begin
		ps2_clk_syn1 <= ps2_clk_syn0;
		ps2_clk_in   <= ps2_clk_syn1;
		ps2_dat_syn1 <= ps2_dat_syn0;
		ps2_dat_in   <= ps2_dat_syn1;
	end

//下一个状态生成
always@(*)
begin
   case(cur_state)
     listen  :begin//只要是在listen状态，键盘的时钟负边沿一定会有将发送的数据暂存起来，同时cnt开始计数。
              if ((!iSTART) && (cnt == 8'b11111111))
                  nex_state = pullclk;
              else
                  nex_state = listen;
                         ce = 1'b0;
                         de = 1'b0;
              end
     pullclk :begin
              if (delay == 4'b1100)
                  nex_state = pulldat;
              else
                  nex_state = pullclk;
                         ce = 1'b1;
                         de = 1'b0;
              end
     pulldat :begin
                  nex_state = trans;
                         ce = 1'b1;
                         de = 1'b1;
              end
     trans   :begin
              if  (byte_cnt == 4'b1010)
                  nex_state = listen;
              else    
                  nex_state = trans;
                         ce = 1'b0;
                         de = 1'b1;
              end
     default :    nex_state = listen;
   endcase
end

//判断是否空闲
always@(posedge clk)
begin
  if ({ps2_clk_in,ps2_dat_in} == 2'b11)//只有两个线都释放的时候才进行cnt的计数。
  //一旦有数据cnt立马就清零了。
	begin
		cnt <= cnt+1;
    end
  else begin
		cnt <= 8'd0;//操作状态cnt会在每一个周期都被置零
       end
end

assign flag = (cnt == 8'hff)?1:0;//一般情况下flag是0，cnt满足全1的情况时候flag变1
always@(posedge ps2_clk_in,posedge flag)//看到没ct是只有在ps2_clk_in的地方才进行计数的，平时规律性的reset为0
begin
  if (flag)
     ct <= 6'b000000;//cnt全1的时候才清零
  else
     ct <= ct+1;
end

//在cnt和ct计数到特定值得时候将键盘扫描码读出。
always@(posedge clk,negedge iRST_n)
begin
   if (!iRST_n) 
   begin
      y_latch  <= 8'd0;
	 outend <= 1'b0;
   end
   else if (cnt == 8'b00011110 && /*(ct[5] == 1'b1 || ct[4] == 1'b1)*/ct == 6'b001011)//当这个值被发送的时候，计数也就结束了。
   begin
      y_latch  <= /*y_latch+*/shift_reg[30 : 23];
		outend <= 1'b1;
   end
	else outend <= 1'b0;
end

// 在向PS2设备发送使能数据前先将ps2时钟拉低100us，作为协议的规定。
always@(posedge clk)
begin
  if (cur_state == pullclk)
     delay <= delay+1;
  else
     delay <= 4'b0000;
end

//向PS2设备发送信号，0xF4使能信号
always@(negedge ps2_clk_in)
begin
  if (cur_state == trans)
     dout_reg <= {1'b0,dout_reg[9:1]};//需要输出一个10位的初始化码
  else
     dout_reg <= {enable_byte,1'b0};
end

//向PS2设备发送信号字节数计数
always@(negedge ps2_clk_in)
begin
  if (cur_state == trans)
     byte_cnt <= byte_cnt+1;
  else
     byte_cnt <= 4'b0000;
end

//从PS2设备接收信号暂存到shift_reg变量当中
always@(negedge ps2_clk_in)
begin
  if (cur_state == listen)
     shift_reg <= {ps2_dat_in,shift_reg[32:1]};//每读入一位，将读到所有值向右移动一位。
end

//状态转移块
always@(posedge clk,negedge iRST_n)
begin
  if (!iRST_n)
     cur_state <= listen;
  else
     cur_state <= nex_state;
end

/*
always@(posedge clk, negedge iRST_n)
begin
	if(! iRST_n)
		LEDState[3:0] <= 4'b0000;
	else
		case(cur_state)
			listen  :begin
				LEDState[3] <= 1'b1;
				LEDState[2:0] <= 3'b000;
			end
			pullclk :begin
				LEDState[2] <= 1'b1;
				LEDState[3] <= 1'b0;
				LEDState[1:0] <= 2'b00;
         end
			pulldat :begin       
				LEDState[3:2] <= 2'b00;
				LEDState[1] <= 1'b1;
				LEDState[0] <= 1'b0;
			end
			trans   :begin
				LEDState[3:1] <= 3'b000;
				LEDState[0] <= 1'b0;
         end
     default : LEDState[3:0] <= 4'b0000;
	  endcase
end

always@(posedge clk)
begin
	LEDCNT[7:0] <= cnt[7:0];
end	

*/
endmodule

     


