`timescale 1ns / 1ns

module SignExtender(
    
    input [3:0] imSrcSelect, //select which part of the instruction is immediate
    input [15:0] instruction,

    output [15:0] ExtendedImmediateOut
);

always @(imSrcSelect or instruction)
begin
    case(imSrcSelect[3]):
    1'b0: //zero extended
    begin
        case(imSrcSelect[2:0]):
        3'b000:
        begin
            ExtendedImmediateOut[7:0] = instruction[7:0];
            ExtendedImmediateOut[15:8] = 8'b0000_0000;
        end
        3'b001:
        begin
            ExtendedImmediateOut[3:0] = instruction[3:0];
            ExtendedImmediateOut[15:4] = 12'b0000_0000_0000;
        end
        3'b010:
        begin
            ExtendedImmediateOut[4:0] = instruction[4:0];
            ExtendedImmediateOut[15:5] = 11'b000_0000_0000;
        end
        3'b011:
        begin
            ExtendedImmediateOut[10:0] = instruction[10:0];
            ExtendedImmediateOut[15:11] = 5'b0_0000;
        end
        3'b100:
        begin
            ExtendedImmediateOut[2:0] = instruction[4:2];
            ExtendedImmediateOut[15:3] = 13'b0_0000_0000_0000;
        end
        3'b101:
        begin
            if(instruction[4:2] == 3'b000)
            begin
                ExtendedImmediateOut[15:0] = 16'b0000_0000_0000_1000; // the result is 8
            end
            else
            begin
                ExtendedImmediateOut[2:0] = instruction[4:2];
                ExtendedImmediateOut[15:3] = 13'b0_0000_0000_0000;
            end
        end
        endcase
    end

    1'b1: //signed extended
    begin
        case(imSrcSelect[2:0]):
        3'b000:
        begin
            ExtendedImmediateOut[15:0] = { {8{instruction[7]}},instruction[7:0]};
            
        end
        3'b001:
        begin
            ExtendedImmediateOut[15:0] = { {12{instruction[3]}},instruction[3:0]};
        end
        3'b010:
        begin
            ExtendedImmediateOut[15:0] = { {11{instruction[4]}},instruction[4:0]};
        end
        3'b011:
        begin
            ExtendedImmediateOut[15:0] = { {5{instruction[10]}},instruction[10:0]};
        end
        3'b100:
        begin
            ExtendedImmediateOut[15:0] = { {13{instruction[4]}},instruction[4:2]};
        end
        //the 4'b1101 case will not happen in the real code

        endcase
    end
    endcase


end


endmodule