module SubByte(
    input [127:0] i_Data,
    output [127:0] o_Data,
    input i_fDec
);

genvar i;

generate
    for(i=0;i<128;i=i+8) begin
        SBox Sb(i_Data[i +:8],o_Data[i +:8],i_fDec);
    end
endgenerate

endmodule
