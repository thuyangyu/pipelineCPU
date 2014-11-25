module InstructionDecoder(
	//rx express 10 to 8 bit in instruction, ry express 7 to 5 bit, rz express 4 to 2;
    input  [15:0] instruction,	
    output regDst,   //select write R3 from ry or rz;   0 is from ry, 1 is from rz;
	output jump,     //select PC or jump to immediate
	output branch, //
	output memRead,//
	output memToReg,
	output ALUOp,
	output memWrite,
	output ALUSrc,
	output regWrite
    );
    
always @(instruction)

case(instruction[15:11])
    5'b00001:  
        begin
        if(instruction[10:0] == 11'b0000_0000_000)
            //NOP
        end
        
    5'b00010:
        begin
        //B
        end
        
    5'b00100:
        begin
        //BEQZ
       
        end
    
    5'b00101:
        begin
        //BNEZ
        end
        
    5'b00110:
        case(instruction[1:0])
            2'b00:
                begin
                    //SLL
                end
                
            2'b11:
                begin 
                    //SRA
                end
        endcase
        
    5'b01000:
        begin
        //ADDIU3
        end
        
    5'b01001:
        begin
        //ADDIU
        end
    
    5'b01100:
        case(instruction[10:8])
            3'b011:
                begin
                    //ADDSP3
                end
            3'b000:
                begin
                    //BTEQZ
                end
            3'b100:
                if(instruction[4:0]==5'b00000)
                begin
                    //MTSP
                end    
                
            
        endcase
    
    5'b01101:
        begin
        //LI
        end    
        
    5'b01110:
        begin
        //CMPI
        end    
    
    5'b10010:
        begin
        //LW_SP
        end
    
    5'b10011:
        begin
        //LW
        end
    
    5'b11010:
        begin
        //SW_IP
        end
    
    5'b11011:
        begin
        //SW
        end
    
    5'b11100:
        case(instruction[1:0])
            2'b01:
            begin
                //ADDU    
            end
            
            2'b11:
            begin
                //SUBU
            end
        endcase
    
    5'b11101:
        case(instruction[4:0])
            5'b01100:
            begin
                //AND    
            end
            
            5'b01010:
            begin
                //CMP    
            end
            
            5'b00000:
            case(instruction[7:5])
                3'b000:
                begin
                //JR
                end
                3'b010:
                begin
                //MFPC
                end
            endcase
            
            5'b01111:
            begin
                //NOT    
            end
            
            5'b01101:
            begin
                //OR    
            end
            
            5'b00100:
            begin
                //SLLV
            end
            
            5'b00010:
            begin
                //SLT    
            end
            
            5'b00111:
            begin
                //SRAV 
            end
        endcase
    
    5'b11110:
        case(instruction[7:0])
            8'b0000_0000:
            begin
                //MFIH  
            end
            
            2'b0000_0001:
            begin
                //MTIH
            end
        endcase
        
        
endcase    
    
    

endmodule