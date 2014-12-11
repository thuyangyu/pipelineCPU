`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:03:34 11/23/2013 
// Design Name: 
// Module Name:    VGAPainter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGAPainter(
        input [10:0] x, y,
        input [15:0] instruction,
        //input [15:0] pc,
        output reg [2:0] r, g, b
    );
     
wor hit;

//define the reg

reg enableA;
reg [10:0]deltA;
reg enableB;
reg [10:0]deltB;
reg enableC;
reg [10:0]deltC;
reg enableD1;
reg [10:0]deltD1;
reg enableD2;
reg [10:0]deltD2;
reg enableE;
reg [10:0]deltE;
reg enableF;
reg [10:0]deltF;
reg enableH;
reg [10:0]deltH;
reg enableI;
reg [10:0]deltI;
reg enableJ;
reg [10:0]deltJ;
reg enableL1;
reg [10:0]deltL1;
reg enableL2;
reg [10:0]deltL2;
reg enableM;
reg [10:0]deltM;

reg enableN;
reg [10:0]deltN;
reg enableO;
reg [10:0]deltO;
reg enableP;
reg [10:0]deltP;

reg enableQ ;
reg [10:0]deltQ;
reg enableR ;
reg [10:0]deltR;
reg enableS ;
reg [10:0]deltS;
reg enableT ;
reg [10:0]deltT;
reg enableU1 ;
reg [10:0]deltU1;
reg enableU2 ;
reg [10:0]deltU2;
reg enableV ;
reg [10:0]deltV;
reg enableW ;
reg [10:0]deltW;
reg enableZ ;
reg [10:0]deltZ;
reg enable3 ;
reg [10:0]delt3;


//Samplization


paintLogoA a(
    enableA,
    x, y,
    deltA,
    hit
);

paintLogoB b1(
    enableB,
    x, y,
    deltB,
    hit
);

paintLogoC c(
    enableC,
    x, y,
    deltC,
    hit
);

paintLogoD d1(
    enableD1,
    x, y,
    deltD1,
    hit
);

paintLogoD d2(
    enableD2,
    x, y,
    deltD2,
    hit
);

paintLogoE e(
    enableE,
    x, y,
    deltE,
    hit
);

paintLogoF f(
    enableF,
    x, y,
    deltF,
    hit
);

paintLogoH h(
    enableH,
    x, y,
    deltH,
    hit
);

paintLogoI i(
    enableI,
    x, y,
    deltI,
    hit
);

paintLogoJ j(
    enableJ,
    x, y,
    deltJ,
    hit
);

paintLogoL l1(
    enableL1,
    x, y,
    deltL1,
    hit
);

paintLogoL l2(
    enableL2,
    x, y,
    deltL2,
    hit
);

paintLogoM m(
    enableM,
    x, y,
    deltM,
    hit
);

paintLogoN n(
    enableN,
    x, y,
    deltN,
    hit
);

paintLogoO o(
    enableO,
    x, y,
    deltO,
    hit
);

paintLogoP p(
    enableP,
    x, y,
    deltP,
    hit
);

paintLogoQ q(
    enableQ,
    x, y,
    deltQ,
    hit
);

paintLogoR r1(
    enableR,
    x, y,
    deltR,
    hit
);

paintLogoS s(
    enableS,
    x, y,
    deltS,
    hit
);

paintLogoT t(
    enableT,
    x, y,
    deltT,
    hit
);

paintLogoU u1(
    enableU1,
    x, y,
    deltU1,
    hit
);

paintLogoU u2(
    enableU2,
    x, y,
    deltU2,
    hit
);

paintLogoV v(
    enableV,
    x, y,
    deltV,
    hit
);

paintLogoW w(
    enableW,
    x, y,
    deltW,
    hit
);

paintLogoZ z(
    enableZ,
    x, y,
    deltZ,
    hit
);

paintLogoNum3 num3(
    enable3,
    x, y,
    delt3,
    hit
);
 


localparam H_RESOLUTION = 800;
localparam V_RESOLUTION = 600;

always @(x, y, hit)
begin
    if(x < H_RESOLUTION && y < V_RESOLUTION && hit)
    begin
        r = 7;
        g = 7;
        b = 7;
    end
    else
    begin
        r = 0;
        g = 0;
        b = 0;
    end
end


/*paintLogoA a(
    1,
    x, y,
    hit
);
*/

always @(*)
begin

case(instruction[15:11])

    5'b00001:  
        begin
        if(instruction[10:0] == 11'b0000_0000_000)
                
            begin
            //NOP
                enableA = 0;
                deltA=0;
                enableB = 0;
                deltB=0;
                enableC = 0;
                deltC=0;
                enableD1 = 0;
                deltD1=0;
                enableD2 = 0;
                deltD2=0;
                enableE = 0;
                deltE=0;
                enableF = 0;
                deltF=0;
                enableH = 0;
                deltH=0;
                enableI = 0;
                deltI=0;
                enableJ = 0;
                deltJ=0;
                enableL1 = 0;
                deltL1=0;
                enableL2 = 0;
                deltL2=0;
                enableM = 0;
                deltM=0;
                enableN = 1;
                deltN=0+50;
                enableO = 1;
                deltO=50+50;
                enableP = 1;
                deltP=100+50;
                enableQ = 0;
                deltQ=0;
                enableR = 0;
                deltR=0;
                enableS = 0;
                deltS=0;
                enableT = 0;
                deltT=0;
                enableU1 = 0;
                deltU1=0;
                enableU2 = 0;
                deltU2=0;
                enableV = 0;
                deltV=0;
                enableW = 0;
                deltW=0;
                enableZ = 0;
                deltZ=0;  
                enable3 = 0;
                delt3=0;
                 
            end
        else
                begin
                enableA = 0;
                deltA=0;
                enableB = 0;
                deltB=0;
                enableC = 0;
                deltC=0;
                enableD1 = 0;
                deltD1=0;
                enableD2 = 0;
                deltD2=0;
                enableE = 0;
                deltE=0;
                enableF = 0;
                deltF=0;
                enableH = 0;
                deltH=0;
                enableI = 0;
                deltI=0;
                enableJ = 0;
                deltJ=0;
                enableL1 = 0;
                deltL1=0;
                enableL2 = 0;
                deltL2=0;
                enableM = 0;
                deltM=0;
                enableN = 0;
                deltN=0;
                enableO = 0;
                deltO=0;
                enableP = 0;
                deltP=0;
                enableQ = 0;
                deltQ=0;
                enableR = 0;
                deltR=0;
                enableS = 0;
                deltS=0;
                enableT = 0;
                deltT=0;
                enableU1 = 0;
                deltU1=0;
                enableU2 = 0;
                deltU2=0;
                enableV = 0;
                deltV=0;
                enableW = 0;
                deltW=0;
                enableZ = 0;
                deltZ=0;  
                enable3 = 0;
                delt3=0; 
                end
        end
        
    5'b00010:
        begin
        //B
                    enableA = 0;
                    deltA=0;
                    enableB = 1;
                    deltB=0+50;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
        end
        
    5'b00100:
        begin
        //BEQZ
                    enableA = 0;
                    deltA=0;
                    enableB = 1;
                    deltB=0+50;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 1;
                    deltE=50+50;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 1;
                    deltQ=100+50;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 1;
                    deltZ=150+50;  
                    enable3 = 0;
                    delt3=0; 
        end
    
    5'b00101:
        begin
        //BNEZ
                    enableA = 0;
                    deltA=0;
                    enableB = 1;
                    deltB=0+50;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 1;
                    deltE=100+50;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 1;
                    deltN=50+50;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 1;
                    deltZ=150+50;  
                    enable3 = 0;
                    delt3=0; 
        end
        
    5'b00110:
        case(instruction[1:0])
            2'b00:
                begin
                    //SLL
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 1;
                    deltL1=50+50;
                    enableL2 = 1;
                    deltL2=100+50;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                end
                
            2'b11:
                begin 
                    //SRA
                    enableA = 1;
                    deltA=100+50;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 1;
                    deltR=50+50;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 

                end
					 
                default: 
                    begin
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                    end
        endcase
     
    5'b01000:
        begin
        //ADDIU3
                    enableA = 1;
                    deltA=0+30;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 1;
                    deltD1=50+30;
                    enableD2 = 1;
                    deltD2=100+30;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 1;
                    deltI=150+30;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 1;
                    deltU1=200+30;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 1;
                    delt3=250+30; 
        end
       
    5'b01001:
        begin
        //ADDIU
                    enableA = 1;
                    deltA=0+50;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 1;
                    deltD1=50+50;
                    enableD2 = 1;
                    deltD2=100+50;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 1;
                    deltI=150+50;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
						  
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
						  
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 1;
                    deltU1=200+50;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0;					  
        end
		  
    5'b01100:
        case(instruction[10:8])
            3'b011:
                begin
                    //ADDSP
                    enableA = 1;
                    deltA=0+50;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 1;
                    deltD1=50+50;
                    enableD2 = 1;
                    deltD2=100+50;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=200+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=150+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                end
            3'b000:
                begin
                    //BTEQZ
                    enableA = 0;
                    deltA=0;
                    enableB = 1;
                    deltB=0+50;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 1;
                    deltE=100+50;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 1;
                    deltQ=150+50;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 1;
                    deltT=50+50;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 1;
                    deltZ=200+50;  
                    enable3 = 0;
                    delt3=0; 
                end
            3'b100:
                if(instruction[4:0]==5'b00000)
                begin
                    //MTSP
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 1;
                    deltM=0+50;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=150+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=100+50;
                    enableT = 1;
                    deltT=50+50;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0;                    
                end
                else 
                begin
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                end
                     
                default: 
                    begin
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                    end
                
            
        endcase
    
    5'b01101:
        begin
        //LI
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 1;
                    deltI=50+50;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 1;
                    deltL1=0+50;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0;             
        end    
        
    5'b01110:
        begin
        //CMPI
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 1;
                    deltC=0+50;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 1;
                    deltI=150+50;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 1;
                    deltM=50+50;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=100+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
        end    
    
    5'b10010:
        begin
        //LW_SP
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 1;
                    deltL1=0+50;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=150+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=100+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 1;
                    deltW=50+50;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
        end
    
    5'b10011:
        begin
        //LW
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 1;
                    deltL1=0+50;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 1;
                    deltW=50+50;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 

            
        end
    
    5'b11010:
        begin
        //SW_SP
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=150+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 1;
                    deltR=100+50;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 1;
                    deltW=50+50;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
        end
    
    5'b11011:
        begin
        //SW
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 1;
                    deltW=50+50;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 

        end
    
    5'b11100:
        case(instruction[1:0])
            2'b01:
            begin
                //ADDU
                    enableA = 1;
                    deltA=0+50;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 1;
                    deltD1=50+50;
                    enableD2 = 1;
                    deltD2=100+50;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 1;
                    deltU1=150+50;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
            end
            
            2'b11:
            begin
                //SUBU
                    enableA = 0;
                    deltA=0;
                    enableB = 1;
                    deltB=100+50;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 1;
                    deltU1=50+50;
                    enableU2 = 1;
                    deltU2=150+50;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0;  
            end
                
                default:
                    begin
                    enableA = 0;
                    deltA = 0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                    end
        endcase
    
    5'b11101:
        case(instruction[4:0])
            5'b01100:
            begin
                //AND
                    enableA = 1;
                    deltA=0+50;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 1;
                    deltD1=100+50;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 1;
                    deltN=50+50;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
    
                
            end
            
            5'b01010:
            begin
                //CMP
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 1;
                    deltC=0+50;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 1;
                    deltM=50+50;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=100+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
    
            end
            
            5'b00000:
            case(instruction[7:5])
                3'b000:
                begin
                //JR
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 1;
                    deltJ=0+50;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 1;
                    deltR=50+50;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
    
                end
                3'b010:
                    begin
                    //MFPC
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 1;
                    deltC=150+50;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 1;
                    deltF=50+50;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 1;
                    deltM=0+50;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 1;
                    deltP=100+50;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                    end
            endcase
            
            5'b01111:
            begin
                //NOT
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 1;
                    deltN=0+50;
                    enableO = 1;
                    deltO=50+50;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 1;
                    deltT=100+50;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
    
            end
            
            5'b01101:
            begin
                //OR
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 1;
                    deltO=0+50;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 1;
                    deltR=50+50;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
            end
            
            5'b00100:
            begin
                //SLLV
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 1;
                    deltL1=50+50;
                    enableL2 = 1;
                    deltL2=100+50;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 1;
                    deltV=150+50;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
            end
            
            5'b00010:
            begin
                //SLT
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 1;
                    deltL1=50+50;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 1;
                    deltT=100+50;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
    
            end
            
            5'b00111:
            begin
                //SRAV 
                    enableA = 1;
                    deltA=100+50;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 1;
                    deltR=50+50;
                    enableS = 1;
                    deltS=0+50;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 1;
                    deltV=150+50;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
            end
                
                default: 
                    begin
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                    end
        endcase
    
    5'b11110:
        case(instruction[7:0])
            8'b0000_0000:
            begin
                //MFIH
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 1;
                    deltF=50+50;
                    enableH = 1;
                    deltH=150+50;
                    enableI = 1;
                    deltI=100+50;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 1;
                    deltM=0+50;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
            end
            
            8'b0000_0001:
            begin
                //MTIH
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 1;
                    deltH=150+50;
                    enableI = 1;
                    deltI=100+50;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 1;
                    deltM=0+50;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 1;
                    deltT=50+50;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
            end
                default: 
                    begin
                    enableA = 0;
                    deltA=0;
                    enableB = 0;
                    deltB=0;
                    enableC = 0;
                    deltC=0;
                    enableD1 = 0;
                    deltD1=0;
                    enableD2 = 0;
                    deltD2=0;
                    enableE = 0;
                    deltE=0;
                    enableF = 0;
                    deltF=0;
                    enableH = 0;
                    deltH=0;
                    enableI = 0;
                    deltI=0;
                    enableJ = 0;
                    deltJ=0;
                    enableL1 = 0;
                    deltL1=0;
                    enableL2 = 0;
                    deltL2=0;
                    enableM = 0;
                    deltM=0;
                    enableN = 0;
                    deltN=0;
                    enableO = 0;
                    deltO=0;
                    enableP = 0;
                    deltP=0;
                    enableQ = 0;
                    deltQ=0;
                    enableR = 0;
                    deltR=0;
                    enableS = 0;
                    deltS=0;
                    enableT = 0;
                    deltT=0;
                    enableU1 = 0;
                    deltU1=0;
                    enableU2 = 0;
                    deltU2=0;
                    enableV = 0;
                    deltV=0;
                    enableW = 0;
                    deltW=0;
                    enableZ = 0;
                    deltZ=0;  
                    enable3 = 0;
                    delt3=0; 
                    end
        endcase
   
    
 default: 
                begin
                enableA = 0;
                deltA=0;
                enableB = 0;
                deltB=0;
                enableC = 0;
                deltC=0;
                enableD1 = 0;
                deltD1=0;
                enableD2 = 0;
                deltD2=0;
                enableE = 0;
                deltE=0;
                enableF = 0;
                deltF=0;
                enableH = 0;
                deltH=0;
                enableI = 0;
                deltI=0;
                enableJ = 0;
                deltJ=0;
                enableL1 = 0;
                deltL1=0;
                enableL2 = 0;
                deltL2=0;
                enableM = 0;
                deltM=0;
					 
                enableN = 0;
                deltN=0;
                enableO = 0;
                deltO=0;
                enableP = 0;
                deltP=0;
					 
                enableQ = 0;
                deltQ=0;
                enableR = 0;
                deltR=0;
                enableS = 0;
                deltS=0;
                enableT = 0;
                deltT=0;
                enableU1 = 0;
                deltU1=0;
                enableU2 = 0;
                deltU2=0;
                enableV = 0;
                deltV=0;
                enableW = 0;
                deltW=0;
                enableZ = 0;
                deltZ=0;  
                enable3 = 0;
                delt3=0;
			 
                end
endcase    
end  



endmodule
