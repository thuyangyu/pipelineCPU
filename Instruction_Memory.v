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


assign RAM2OE = CLK;
assign RAM2WE = 1'b1;//always disable
assign RAM2EN = 1'b0;//always enable
assign RAM2ADDR[17:0] = {2'b0, address[15:0]};
assign RAM2DATA[15:0] =  16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;

always @ (posedge CLK, negedge RST)
begin
    if(!RST)
        begin
            instruction[15:0] <= 16'b0000_1000_0000_0000;
        end
    else
        begin
            instruction[15:0] <= RAM2DATA[15:0];
        end
end

endmodule