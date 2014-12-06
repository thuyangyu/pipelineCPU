`timescale 1ns / 1ns

module InstructionDecoder(
	//rx express 10 to 8 bit in instruction, ry express 7 to 5 bit, rz express 4 to 2;
    input  [15:0] instruction,	
    output reg [3:0] imSelector,
    output reg [1:0] ALUSrc2,
    output reg [1:0] memWrite,
    output reg [1:0] memRead,
    output reg [1:0]regDst,   
	output reg  branch, 
	output reg  regWrite,
	output reg  memToReg,
	output reg  [3:0]op,
	output reg  [1:0]readSpecReg,
	output reg [1:0]writeSpecReg,
	output reg jump,     
	output reg [1:0]ALUSrc1,
	output reg rxToMem
	
    );
    
always @(*)
begin

case(instruction[15:11])

    5'b00001:  
        begin
        if(instruction[10:0] == 11'b0000_0000_000)
            begin
            //NOP
            imSelector = 4'b0000;
            ALUSrc2 = 2'b00;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0;
            op = 4'b0000;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
            end
		else 
			begin
				  imSelector = 4'b0000;
                  ALUSrc2 = 2'b00;
                  memWrite = 2'b00;
                  memRead = 2'b00;
                  regDst = 2'b00;
                  branch = 1'b0;
                  regWrite = 1'b0;
                  memToReg = 1'b0;
                  op = 4'b0000;
                  readSpecReg = 2'b00;
                  writeSpecReg = 2'b00;
                  jump = 1'b0;
                  ALUSrc1 = 2'b00;
                  rxToMem = 1'b0;
			end
        end
        
    5'b00010:
        begin
        //B
            imSelector = 4'b1011;
            ALUSrc2 = 2'b00;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b1;
            regWrite = 1'b0;
            memToReg = 1'b0;
            op = 4'b1000;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
        
    5'b00100:
        begin
        //BEQZ
            imSelector = 4'b1000;
            ALUSrc2 = 2'b00;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b1;
            regWrite = 1'b0;
            memToReg = 1'b0;
            op = 4'b1001;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
    
    5'b00101:
        begin
        //BNEZ
            imSelector = 4'b1000;
            ALUSrc2 = 2'b00;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b1;
            regWrite = 1'b0;
            memToReg = 1'b0;
            op = 4'b1010;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
        
    5'b00110:
        case(instruction[1:0])
            2'b00:
                begin
                    //SLL
                    imSelector = 4'b0101;
                    ALUSrc2 = 2'b01;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b1;
                    memToReg = 1'b0;
                    op = 4'b0110;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b10;
                    rxToMem = 1'b0;
                end
                
            2'b11:
                begin 
                    //SRA
                    imSelector = 4'b0101;
                    ALUSrc2 = 2'b01;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b1;
                    memToReg = 1'b0;
                    op = 4'b0101;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b10;
                    rxToMem = 1'b0;
                end
				default: 
					begin
						  imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
        endcase
        
    5'b01000:
        begin
        //ADDIU3
            imSelector = 4'b1001;
            ALUSrc2 = 2'b01;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b01;
            branch = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            op = 4'b0000;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
        
    5'b01001:
        begin
        //ADDIU
            imSelector = 4'b1000;
            ALUSrc2 = 2'b01;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            op = 4'b0000;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
    
    5'b01100:
        case(instruction[10:8])
            3'b011:
                begin
                    //ADDSP
                    imSelector = 4'b1000;
                    ALUSrc2 = 2'b01;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b1;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b01;
                    writeSpecReg = 2'b01;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
                end
            3'b000:
                begin
                    //BTEQZ
                    imSelector = 4'b1000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b1;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b1001;
                    readSpecReg = 2'b11;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
                end
            3'b100:
                if(instruction[4:0]==5'b00000)
                begin
                    //MTSP
                    imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b1;
                    memToReg = 1'b0;
                    op = 4'b1001;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b01;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
                end
				else 
				begin
					imSelector = 4'b0000;
					ALUSrc2 = 2'b00;
					memWrite = 2'b00;
					memRead = 2'b00;
					regDst = 2'b00;
					branch = 1'b0;
					regWrite = 1'b0;
					memToReg = 1'b0;
					op = 4'b0000;
					readSpecReg = 2'b00;
					writeSpecReg = 2'b00;
					jump = 1'b0;
					ALUSrc1 = 2'b00;
					rxToMem = 1'b0;
				end
					 
				default: 
					begin
						  imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
                
            
        endcase
    
    5'b01101:
        begin
        //LI
            imSelector = 4'b0000;
            ALUSrc2 = 2'b01;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            op = 4'b1100;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end    
        
    5'b01110:
        begin
        //CMPI
            imSelector = 4'b1000;
            ALUSrc2 = 2'b01;
            memWrite = 2'b00;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b0;
            op = 4'b1011;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b11;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end    
    
    5'b10010:
        begin
        //LW_SP
            imSelector = 4'b1000;
            ALUSrc2 = 2'b01;
            memWrite = 2'b00;
            memRead = 2'b10;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b1;
            op = 4'b0000;
            readSpecReg = 2'b01;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
    
    5'b10011:
        begin
        //LW
            imSelector = 4'b1010;
            ALUSrc2 = 2'b01;
            memWrite = 2'b00;
            memRead = 2'b01;
            regDst = 2'b01;
            branch = 1'b0;
            regWrite = 1'b1;
            memToReg = 1'b1;
            op = 4'b0000;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
    
    5'b11010:
        begin
        //SW_SP
            imSelector = 4'b1000;
            ALUSrc2 = 2'b01;
            memWrite = 2'b10;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0;
            op = 4'b0000;
            readSpecReg = 2'b01;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b1;
        end
    
    5'b11011:
        begin
        //SW
            imSelector = 4'b1010;
            ALUSrc2 = 2'b01;
            memWrite = 2'b01;
            memRead = 2'b00;
            regDst = 2'b00;
            branch = 1'b0;
            regWrite = 1'b0;
            memToReg = 1'b0;
            op = 4'b0000;
            readSpecReg = 2'b00;
            writeSpecReg = 2'b00;
            jump = 1'b0;
            ALUSrc1 = 2'b00;
            rxToMem = 1'b0;
        end
    
    5'b11100:
        case(instruction[1:0])
            2'b01:
            begin
                //ADDU
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b10;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0000;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
            
            2'b11:
            begin
                //SUBU
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b10;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0001;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
				
				default: 
					begin
						  imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
        endcase
    
    5'b11101:
        case(instruction[4:0])
            5'b01100:
            begin
                //AND
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0010;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;  
            end
            
            5'b01010:
            begin
                //CMP
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b1011;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b11;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
            
            5'b00000:
            case(instruction[7:5])
                3'b000:
                begin
                //JR
                    imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b1001;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b1;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
                end
                3'b010:
                begin
                //MFPC
                    imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b1;
                    memToReg = 1'b0;
                    op = 4'b1001;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b01;
                    rxToMem = 1'b0;
                end
					 
					 default: 
					begin
						  imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
            endcase
            
            5'b01111:
            begin
                //NOT
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0100;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
            
            5'b01101:
            begin
                //OR
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0011;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
            
            5'b00100:
            begin
                //SLLV
                imSelector = 4'b0000;
                ALUSrc2 = 2'b10;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b01;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0110;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b10;
                rxToMem = 1'b0;
            end
            
            5'b00010:
            begin
                //SLT
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0111;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b11;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
            
            5'b00111:
            begin
                //SRAV 
                imSelector = 4'b0000;
                ALUSrc2 = 2'b10;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b01;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b0101;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b10;
                rxToMem = 1'b0;
            end
				
				default: 
					begin
						  imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
        endcase
    
    5'b11110:
        case(instruction[7:0])
            8'b0000_0000:
            begin
                //MFIH
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b1001;
                readSpecReg = 2'b10;
                writeSpecReg = 2'b00;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
            
            8'b0000_0001:
            begin
                //MTIH
                imSelector = 4'b0000;
                ALUSrc2 = 2'b00;
                memWrite = 2'b00;
                memRead = 2'b00;
                regDst = 2'b00;
                branch = 1'b0;
                regWrite = 1'b1;
                memToReg = 1'b0;
                op = 4'b1001;
                readSpecReg = 2'b00;
                writeSpecReg = 2'b10;
                jump = 1'b0;
                ALUSrc1 = 2'b00;
                rxToMem = 1'b0;
            end
				default: 
					begin
						  imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
        endcase
   
    
 default: 
					begin
					imSelector = 4'b0000;
                    ALUSrc2 = 2'b00;
                    memWrite = 2'b00;
                    memRead = 2'b00;
                    regDst = 2'b00;
                    branch = 1'b0;
                    regWrite = 1'b0;
                    memToReg = 1'b0;
                    op = 4'b0000;
                    readSpecReg = 2'b00;
                    writeSpecReg = 2'b00;
                    jump = 1'b0;
                    ALUSrc1 = 2'b00;
                    rxToMem = 1'b0;
					end
endcase    
end  
    

endmodule
