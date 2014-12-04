`timescale 1ns / 1ns

module HazardDetector(
    input [15:0]HD_instruction,
    input [1:0] HD_memRead_a_IDEX,
    input [2:0]HD_Rx_a_IDEX,
    input [2:0]HD_Ry_a_IDEX,
    output HD_PCWrite,
    output HD_IFIDWrite,
    output HD_addBubble
    
    );
    
    wire needToAddBubble;
    wire needToAddBubble_1;
    wire needToAddBubble_for_LW;
    wire needToAddBubble_for_LWSP;
    wire [2:0] IFID_rx;
    wire [2:0] IFID_ry;

    assign IFID_rx[2:0] = HD_instruction[10:8];//this is the rx
    assign IFID_ry[2:0] = HD_instruction[7:5];//this is the ry

    assign HD_addBubble = needToAddBubble;
    assign HD_PCWrite = needToAddBubble;
    assign HD_IFIDWrite = needToAddBubble;

    assign needToAddBubble =  (HD_memRead_a_IDEX[1:0] == 2'b00 || HD_memRead_a_IDEX[1:0] == 2'b11)? 1'b0 : needToAddBubble_1;

    assign needToAddBubble_1 = (HD_memRead_a_IDEX[1:0] == 2'b01) ? needToAddBubble_for_LW : needToAddBubble_for_LWSP;
    
    assign needToAddBubble_for_LW = (HD_Ry_a_IDEX[2:0] == IFID_rx[2:0] ||HD_Ry_a_IDEX[2:0] == IFID_ry[2:0]) ? 1'b1 : 1'b0;

    assign needToAddBubble_for_LWSP = (HD_Rx_a_IDEX[2:0] == IFID_rx[2:0] ||HD_Rx_a_IDEX[2:0] == IFID_ry[2:0]) ? 1'b1 : 1'b0;
    
    
    
endmodule
