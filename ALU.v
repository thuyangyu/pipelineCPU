`timescale 1ns / 1ns


module ALU(
    input CLK,   
    input RST,	 
    input [15:0] first,
    input [15:0] second,
    input [3:0] op;
    output [15:0] result,
    output zeroFlag;
    );

assign zeroFlag = (result[15:0] == 16'b0)? 1'b1: 1'b0;

always @(first,second,op)
begin
    case(op):

    4'b0000:
    begin
    	result = first + second;
    end 

    4'b0001:
    begin
        result = first - second;
    end 

    4'b0010:
    begin
        result = first & second;
    end 

    4'b0011:
    begin
        result = first | second;
    end 

    4'b0100:
    begin
        result = ~first;
    end 

    4'b0101:
    begin
        result = first >>> second;
    end

    4'b0110:
    begin
        result = first << second;
    end

    4'b0111:
    begin
        if(first < second) result = 16'b1;
        else result = 16'b0; 
    end

    4'b1000:
    begin
        result = 16'b0;
    end 

    4'b1001:
    begin
        result = first;
    end 

    4'b1010:
    begin
        result = !first;
    end 

    4'b1011:
    begin
        if(first == second) result = 16'b0;
        else result = 16'b1;
    end 

    4'b1100:
    begin
        result = second;
    end 

    endcase

end
	
endmodule
