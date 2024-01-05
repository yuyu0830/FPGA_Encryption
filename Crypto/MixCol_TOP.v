module MixCol_Top(
    input [127:0] i_State,
    output reg [127:0] o_State,
    input i_fDec
);

parameter shift3 = 3,
          shift2 = 2,
          shift1 = 1;        

function [7:0] hex02(input [7:0] state,input integer n);
    integer i;
    begin
        for(i=0;i<n;i=i+1) begin
            if(state[7]) state = (({state[6:0],1'b0})^8'h1b);
            else         state = {state[6:0],1'b0};
        end
        hex02 = state;
    end

endfunction

function [7:0] hex03; 
    input [7:0] state;
    begin
        hex03 = hex02(state,shift1) ^ state;
    end
    
endfunction

function [7:0] hex0e; 
    input [7:0] state;
    begin
        hex0e = hex02(state,shift3) ^ hex02(state,shift2) ^ hex02(state,shift1);
    end
    
endfunction

function [7:0] hex0b; 
    input [7:0] state;
    begin
        hex0b = hex02(state,shift3) ^ hex02(state,shift1) ^ state;
    end
    
endfunction

function [7:0] hex0d; 
    input [7:0] state;
    begin
        hex0d = hex02(state,shift3) ^ hex02(state,shift2) ^ state;
    end
    
endfunction

function [7:0] hex09; 
    input [7:0] state;
    begin
        hex09 = hex02(state,shift3) ^ state;
    end
    
endfunction
    always@(*) begin
        if(!i_fDec) begin
            o_State[120 +:8] = hex02(i_State[120+:8],shift1) ^ hex03(i_State[112+:8])        ^ i_State[104+:8]               ^ i_State[96+:8];                   // 2 3 1 1
            o_State[112 +:8] = i_State[120+:8]               ^ hex02(i_State[112+:8],shift1) ^ hex03(i_State[104+:8])        ^ i_State[96+:8];                   // 1 2 3 1
            o_State[104 +:8] = i_State[120+:8]               ^ i_State[112+:8]               ^ hex02(i_State[104+:8],shift1) ^ hex03(i_State[96+:8]);            // 1 1 2 3
            o_State[96  +:8] = hex03(i_State[120+:8])        ^ i_State[112+:8]               ^ i_State[104+:8]               ^ hex02(i_State[96+:8],shift1);     // 3 1 1 2
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            o_State[88  +:8] = hex02(i_State[88+:8],shift1)  ^ hex03(i_State[80+:8])         ^ i_State[72+:8]                ^ i_State[64+:8];                   // 2 3 1 1
            o_State[80  +:8] = i_State[88+:8]                ^ hex02(i_State[80+:8],shift1)  ^ hex03(i_State[72+:8])         ^ i_State[64+:8];                   // 1 2 3 1
            o_State[72  +:8] = i_State[88+:8]                ^ i_State[80+:8]                ^ hex02(i_State[72+:8],shift1)  ^ hex03(i_State[64+:8]);            // 1 1 2 3
            o_State[64  +:8] = hex03(i_State[88+:8])         ^ i_State[80+:8]                ^ i_State[72+:8]                ^ hex02(i_State[64+:8],shift1);     // 3 1 1 2
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            o_State[56  +:8] = hex02(i_State[56+:8],shift1)  ^ hex03(i_State[48+:8])         ^ i_State[40+:8]                ^ i_State[32+:8];                   // 2 3 1 1
            o_State[48  +:8] = i_State[56+:8]                ^ hex02(i_State[48+:8],shift1)  ^ hex03(i_State[40+:8])         ^ i_State[32+:8];                   // 1 2 3 1
            o_State[40  +:8] = i_State[56+:8]                ^ i_State[48+:8]                ^ hex02(i_State[40+:8],shift1)  ^ hex03(i_State[32+:8]);            // 1 1 2 3
            o_State[32  +:8] = hex03(i_State[56+:8])         ^ i_State[48+:8]                ^ i_State[40+:8]                ^ hex02(i_State[32+:8],shift1);     // 3 1 1 2
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            o_State[24  +:8] = hex02(i_State[24+:8],shift1)  ^ hex03(i_State[16+:8])         ^ i_State[8+:8]                 ^ i_State[0+:8];                    // 2 3 1 1
            o_State[16  +:8] = i_State[24+:8]                ^ hex02(i_State[16+:8],shift1)  ^ hex03(i_State[8+:8])          ^ i_State[0+:8];                    // 1 2 3 1
            o_State[8   +:8] = i_State[24+:8]                ^ i_State[16+:8]                ^ hex02(i_State[8+:8],shift1)   ^ hex03(i_State[0+:8]);             // 1 1 2 3
            o_State[0   +:8] = hex03(i_State[+24+:8])        ^ i_State[16+:8]                ^ i_State[8+:8]                 ^ hex02(i_State[0+:8],shift1);      // 3 1 1 2
        end 
        else begin
            o_State[120 +:8] = hex0e(i_State[120+:8]) ^ hex0b(i_State[112+:8]) ^ hex0d(i_State[104+:8]) ^ hex09(i_State[96+:8]);                // 0e 0b 0d 09
            o_State[112 +:8] = hex09(i_State[120+:8]) ^ hex0e(i_State[112+:8]) ^ hex0b(i_State[104+:8]) ^ hex0d(i_State[96+:8]);                // 09 0e 0b 0d
            o_State[104 +:8] = hex0d(i_State[120+:8]) ^ hex09(i_State[112+:8]) ^ hex0e(i_State[104+:8]) ^ hex0b(i_State[96+:8]);                // 0d 09 0e 0b
            o_State[96  +:8] = hex0b(i_State[120+:8]) ^ hex0d(i_State[112+:8]) ^ hex09(i_State[104+:8]) ^ hex0e(i_State[96+:8]);                // 0b 0d 09 0e
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            o_State[88  +:8] = hex0e(i_State[88+:8])  ^ hex0b(i_State[80+:8])  ^ hex0d(i_State[72+:8])  ^ hex09(i_State[64+:8]);                // 0e 0b 0d 09  
            o_State[80  +:8] = hex09(i_State[88+:8])  ^ hex0e(i_State[80+:8])  ^ hex0b(i_State[72+:8])  ^ hex0d(i_State[64+:8]);                // 09 0e 0b 0d  
            o_State[72  +:8] = hex0d(i_State[88+:8])  ^ hex09(i_State[80+:8])  ^ hex0e(i_State[72+:8])  ^ hex0b(i_State[64+:8]);                // 0d 09 0e 0b
            o_State[64  +:8] = hex0b(i_State[88+:8])  ^ hex0d(i_State[80+:8])  ^ hex09(i_State[72+:8])  ^ hex0e(i_State[64+:8]);                // 0b 0d 09 0e
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            o_State[56  +:8] = hex0e(i_State[56+:8])  ^ hex0b(i_State[48+:8])  ^ hex0d(i_State[40+:8])  ^ hex09(i_State[32+:8]);                // 0e 0b 0d 09
            o_State[48  +:8] = hex09(i_State[56+:8])  ^ hex0e(i_State[48+:8])  ^ hex0b(i_State[40+:8])  ^ hex0d(i_State[32+:8]);                // 09 0e 0b 0d
            o_State[40  +:8] = hex0d(i_State[56+:8])  ^ hex09(i_State[48+:8])  ^ hex0e(i_State[40+:8])  ^ hex0b(i_State[32+:8]);                // 0d 09 0e 0b
            o_State[32  +:8] = hex0b(i_State[56+:8])  ^ hex0d(i_State[48+:8])  ^ hex09(i_State[40+:8])  ^ hex0e(i_State[32+:8]);                // 0b 0d 09 0e
            //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            o_State[24  +:8] = hex0e(i_State[24+:8])  ^ hex0b(i_State[16+:8])  ^ hex0d(i_State[8+:8])   ^ hex09(i_State[0+:8]);                 // 0e 0b 0d 09
            o_State[16  +:8] = hex09(i_State[24+:8])  ^ hex0e(i_State[16+:8])  ^ hex0b(i_State[8+:8])   ^ hex0d(i_State[0+:8]);                 // 09 0e 0b 0d
            o_State[8   +:8] = hex0d(i_State[24+:8])  ^ hex09(i_State[16+:8])  ^ hex0e(i_State[8+:8])   ^ hex0b(i_State[0+:8]);                 // 0d 09 0e 0b
            o_State[0   +:8] = hex0b(i_State[+24+:8]) ^ hex0d(i_State[16+:8])  ^ hex09(i_State[8+:8])   ^ hex0e(i_State[0+:8]);                 // 0b 0d 09 0e
        end
    end

endmodule