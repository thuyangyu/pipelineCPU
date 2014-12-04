`timescale 1ns / 1ns

module Registers (
input CLK,
input regWrite,   //RegWrite == 1 express write, but the read is always enabled
input [1:0]writeSpecReg,
input [1:0]readSpecReg,
input [2:0] R1, //where to read
input [2:0] R2, //where to read
input [2:0] R3, // this tells where to write
input [15:0] inData3,
output [15:0] outData1,
output [15:0] outData2

);

reg [15:0] generalRegister [7:0];
reg [15:0] registerSP;
reg [15:0] registerIH;
reg [15:0] registerT;

always @ (negedge CLK) // we write the data into specific reg in the negedge
begin
    if(regWrite != 0)begin //only when it is 1, we write the value of the registers
        case(writeSpecReg[1:0])
            2'b00: //this is the normal situation
            begin
                generalRegister[R3[2:0]] <= inData3;
            end

            2'b01:
            begin
                registerSP <= inData3;
            end

            2'b10:
            begin
                registerIH <= inData3;
            end

            2'b11:
            begin
                registerT <= inData3;
            end
        endcase
    end
end

//I change it to the assign combination logic
wire [15:0]specialRegisters;
wire [15:0]register_IH_or_T;
assign outData2 = generalRegister[R2[2:0]];
assign outData1 = (readSpecReg[1:0] == 2'b00) ? generalRegister[R1[2:0]]: specialRegisters;
assign specialRegisters = readSpecReg[1] ? register_IH_or_T : registerSP;
assign register_IH_or_T = readSpecReg[0] ? registerT: registerIH;


endmodule