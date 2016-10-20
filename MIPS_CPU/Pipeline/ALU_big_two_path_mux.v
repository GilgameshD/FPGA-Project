module ALU_big_two_path_mux(a,b,s,out);

     input [31:0] a;
     input [31:0] b;
     input s;

    output [31:0]out;

    ALU_two_path_mux mux_0(a[0],b[0],s,out[0]);
    ALU_two_path_mux mux_1(a[1],b[1],s,out[1]);
    ALU_two_path_mux mux_2(a[2],b[2],s,out[2]);
    ALU_two_path_mux mux_3(a[3],b[3],s,out[3]);

    ALU_two_path_mux mux_4(a[4],b[4],s,out[4]);
    ALU_two_path_mux mux_5(a[5],b[5],s,out[5]);
    ALU_two_path_mux mux_6(a[6],b[6],s,out[6]);
    ALU_two_path_mux mux_7(a[7],b[7],s,out[7]);

    ALU_two_path_mux mux_8(a[8],b[8],s,out[8]);
    ALU_two_path_mux mux_9(a[9],b[9],s,out[9]);
    ALU_two_path_mux mux_10(a[10],b[10],s,out[10]);
    ALU_two_path_mux mux_11(a[11],b[11],s,out[11]);

    ALU_two_path_mux mux_12(a[12],b[12],s,out[12]);
    ALU_two_path_mux mux_13(a[13],b[13],s,out[13]);
    ALU_two_path_mux mux_14(a[14],b[14],s,out[14]);
    ALU_two_path_mux mux_15(a[15],b[15],s,out[15]);

    ALU_two_path_mux mux_16(a[16],b[16],s,out[16]);
    ALU_two_path_mux mux_17(a[17],b[17],s,out[17]);
    ALU_two_path_mux mux_18(a[18],b[18],s,out[18]);
    ALU_two_path_mux mux_19(a[19],b[19],s,out[19]);

    ALU_two_path_mux mux_20(a[20],b[20],s,out[20]);
    ALU_two_path_mux mux_21(a[21],b[21],s,out[21]);
    ALU_two_path_mux mux_22(a[22],b[22],s,out[22]);
    ALU_two_path_mux mux_23(a[23],b[23],s,out[23]);

    ALU_two_path_mux mux_24(a[24],b[24],s,out[24]);
    ALU_two_path_mux mux_25(a[25],b[25],s,out[25]);
    ALU_two_path_mux mux_26(a[26],b[26],s,out[26]);
    ALU_two_path_mux mux_27(a[27],b[27],s,out[27]);

    ALU_two_path_mux mux_28(a[28],b[28],s,out[28]);
    ALU_two_path_mux mux_29(a[29],b[29],s,out[29]);
    ALU_two_path_mux mux_30(a[30],b[30],s,out[30]);
    ALU_two_path_mux mux_31(a[31],b[31],s,out[31]);
endmodule
