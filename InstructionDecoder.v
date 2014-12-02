module InstructionDecoder(
	//rx express 10 to 8 bit in instruction, ry express 7 to 5 bit, rz express 4 to 2;
    input  [15:0] instruction,	
    output [3:0] imSelector,
    output [1:0] ALUSrc2;
    output [1:0] memWrite,
    output [1:0] memRead,
    output [1:0]regDst,   
	output branch, 
	output regWrite,
	output memToReg,
	output [3:0]op,
	output [1:0]readSpecReg,
	output [1:0]writeSpecReg,
	output jump,     
	output [1:0]ALUSrc1,
	output rxToMem
	
    );
    
always @(instruction)

case(instruction[15:11])
    5'b00001:  
        begin
        if(instruction[10:0] == 11'b0000_0000_000)
            begin
            //NOP
            imSelector = 4'b0000;
            ALUSrc2 = 2b'00;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'0;
            memToReg = 1b'0;
            op = 4b'0000;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;

            end

        end
        
    5'b00010:
        begin
        //B
            imSelector = 4'b1011;
            ALUSrc2 = 2b'00;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'1;
            regWrite = 1b'0;
            memToReg = 1b'0;
            op = 4b'1000;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
        
    5'b00100:
        begin
        //BEQZ
            imSelector = 4'b1000;
            ALUSrc2 = 2b'00;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'1;
            regWrite = 1b'0;
            memToReg = 1b'0;
            op = 4b'1001;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
    
    5'b00101:
        begin
        //BNEZ
            imSelector = 4'b1000;
            ALUSrc2 = 2b'00;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'1;
            regWrite = 1b'0;
            memToReg = 1b'0;
            op = 4b'1010;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
        
    5'b00110:
        case(instruction[1:0])
            2'b00:
                begin
                    //SLL
                    imSelector = 4'b0101;
                    ALUSrc2 = 2b'01;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'0;
                    regWrite = 1b'1;
                    memToReg = 1b'0;
                    op = 4b'0110;
                    readSpecReg = 4b'00;
                    writeSpecReg = 2b'00;
                    jump = 1b'0;
                    ALUSrc1 = 2b'10;
                    rxToMem = 1b'0;
                end
                
            2'b11:
                begin 
                    //SRA
                    imSelector = 4'b0101;
                    ALUSrc2 = 2b'01;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'0;
                    regWrite = 1b'1;
                    memToReg = 1b'0;
                    op = 4b'0101;
                    readSpecReg = 4b'00;
                    writeSpecReg = 2b'00;
                    jump = 1b'0;
                    ALUSrc1 = 2b'10;
                    rxToMem = 1b'0;
                end
        endcase
        
    5'b01000:
        begin
        //ADDIU3
            imSelector = 4'b1001;
            ALUSrc2 = 2b'01;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'01;
            branch = 1b'0;
            regWrite = 1b'1;
            memToReg = 1b'0;
            op = 4b'0000;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
        
    5'b01001:
        begin
        //ADDIU
            imSelector = 4'b1000;
            ALUSrc2 = 2b'01;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'1;
            memToReg = 1b'0;
            op = 4b'0000;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
    
    5'b01100:
        case(instruction[10:8])
            3'b011:
                begin
                    //ADDSP3
                    imSelector = 4'b1000;
                    ALUSrc2 = 2b'01;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'0;
                    regWrite = 1b'1;
                    memToReg = 1b'0;
                    op = 4b'0000;
                    readSpecReg = 4b'01;
                    writeSpecReg = 2b'01;
                    jump = 1b'0;
                    ALUSrc1 = 2b'00;
                    rxToMem = 1b'0;
                end
            3'b000:
                begin
                    //BTEQZ
                    imSelector = 4'b1000;
                    ALUSrc2 = 2b'00;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'1;
                    regWrite = 1b'0;
                    memToReg = 1b'0;
                    op = 4b'1001;
                    readSpecReg = 4b'11;
                    writeSpecReg = 2b'00;
                    jump = 1b'0;
                    ALUSrc1 = 2b'00;
                    rxToMem = 1b'0;
                end
            3'b100:
                if(instruction[4:0]==5'b00000)
                begin
                    //MTSP
                    imSelector = 4'b0000;
                    ALUSrc2 = 2b'00;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'0;
                    regWrite = 1b'1;
                    memToReg = 1b'0;
                    op = 4b'1001;
                    readSpecReg = 4b'00;
                    writeSpecReg = 2b'01;
                    jump = 1b'0;
                    ALUSrc1 = 2b'00;
                    rxToMem = 1b'0;
                end    
                
            
        endcase
    
    5'b01101:
        begin
        //LI
            imSelector = 4'b0000;
            ALUSrc2 = 2b'01;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'1;
            memToReg = 1b'0;
            op = 4b'1100;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end    
        
    5'b01110:
        begin
        //CMPI
            imSelector = 4'b1000;
            ALUSrc2 = 2b'01;
            memWrite = 2b'00;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'1;
            memToReg = 1b'0;
            op = 4b'1011;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'11;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end    
    
    5'b10010:
        begin
        //LW_SP
            imSelector = 4'b1000;
            ALUSrc2 = 2b'01;
            memWrite = 2b'00;
            memRead = 2b'10;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'1;
            memToReg = 1b'1;
            op = 4b'0000;
            readSpecReg = 4b'01;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
    
    5'b10011:
        begin
        //LW
            imSelector = 4'b1010;
            ALUSrc2 = 2b'01;
            memWrite = 2b'00;
            memRead = 2b'01;
            regDst = 2b'01;
            branch = 1b'0;
            regWrite = 1b'1;
            memToReg = 1b'1;
            op = 4b'0000;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
    
    5'b11010:
        begin
        //SW_IP
            imSelector = 4'b1000;
            ALUSrc2 = 2b'01;
            memWrite = 2b'10;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'0;
            memToReg = 1b'0;
            op = 4b'0000;
            readSpecReg = 4b'01;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
    
    5'b11011:
        begin
        //SW
            imSelector = 4'b1010;
            ALUSrc2 = 2b'01;
            memWrite = 2b'01;
            memRead = 2b'00;
            regDst = 2b'00;
            branch = 1b'0;
            regWrite = 1b'0;
            memToReg = 1b'0;
            op = 4b'0000;
            readSpecReg = 4b'00;
            writeSpecReg = 2b'00;
            jump = 1b'0;
            ALUSrc1 = 2b'00;
            rxToMem = 1b'0;
        end
    
    5'b11100:
        case(instruction[1:0])
            2'b01:
            begin
                //ADDU
                imSelector = 4'b1000;
                ALUSrc2 = 2b'01;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0000;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
            
            2'b11:
            begin
                //SUBU
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'10;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0001;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
        endcase
    
    5'b11101:
        case(instruction[4:0])
            5'b01100:
            begin
                //AND
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0010;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;  
            end
            
            5'b01010:
            begin
                //CMP
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'1011;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'11;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
            
            5'b00000:
            case(instruction[7:5])
                3'b000:
                begin
                //JR
                    imSelector = 4'b0000;
                    ALUSrc2 = 2b'00;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'0;
                    regWrite = 1b'0;
                    memToReg = 1b'0;
                    op = 4b'1001;
                    readSpecReg = 4b'00;
                    writeSpecReg = 2b'00;
                    jump = 1b'1;
                    ALUSrc1 = 2b'00;
                    rxToMem = 1b'0;
                end
                3'b010:
                begin
                //MFPC
                    imSelector = 4'b0000;
                    ALUSrc2 = 2b'00;
                    memWrite = 2b'00;
                    memRead = 2b'00;
                    regDst = 2b'00;
                    branch = 1b'0;
                    regWrite = 1b'1;
                    memToReg = 1b'0;
                    op = 4b'1001;
                    readSpecReg = 4b'00;
                    writeSpecReg = 2b'00;
                    jump = 1b'0;
                    ALUSrc1 = 2b'01;
                    rxToMem = 1b'0;
                end
            endcase
            
            5'b01111:
            begin
                //NOT
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0100;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
            
            5'b01101:
            begin
                //OR
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0011;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
            
            5'b00100:
            begin
                //SLLV
                imSelector = 4'b0000;
                ALUSrc2 = 2b'10;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'01;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0110;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'10;
                rxToMem = 1b'0;
            end
            
            5'b00010:
            begin
                //SLT
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0111;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'11;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
            
            5'b00111:
            begin
                //SRAV 
                imSelector = 4'b0000;
                ALUSrc2 = 2b'10;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'01;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'0101;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'00;
                jump = 1b'0;
                ALUSrc1 = 2b'10;
                rxToMem = 1b'0;
            end
        endcase
    
    5'b11110:
        case(instruction[7:0])
            8'b0000_0000:
            begin
                //MFIH
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'1001;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'10;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
            
            2'b0000_0001:
            begin
                //MTIH
                imSelector = 4'b0000;
                ALUSrc2 = 2b'00;
                memWrite = 2b'00;
                memRead = 2b'00;
                regDst = 2b'00;
                branch = 1b'0;
                regWrite = 1b'1;
                memToReg = 1b'0;
                op = 4b'1001;
                readSpecReg = 4b'00;
                writeSpecReg = 2b'10;
                jump = 1b'0;
                ALUSrc1 = 2b'00;
                rxToMem = 1b'0;
            end
        endcase
        
        
endcase    
    
    

endmodule
