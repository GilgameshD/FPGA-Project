module ALU_add_32_bits(a,b,helper,s,V,N,Z,UN_V,UN_N,UN_Z);

   input [31:0] a;
   input [31:0] b;
   input helper;

   output [31:0] s;
   output reg V;
   output reg N;
   output reg Z;
   output reg UN_V;
   output reg UN_N;
   output reg UN_Z;

         wire [31:0] mark;
         wire mark_32;
         
   assign  mark[0]=helper;

   ALU_add_1_bits qq_1(a[0],b[0],mark[0],s[0],mark[1]);
   ALU_add_1_bits qq_2(a[1],b[1],mark[1],s[1],mark[2]);
   ALU_add_1_bits qq_3(a[2],b[2],mark[2],s[2],mark[3]);
   ALU_add_1_bits qq_4(a[3],b[3],mark[3],s[3],mark[4]);

   ALU_add_1_bits qq_5(a[4],b[4],mark[4],s[4],mark[5]);
   ALU_add_1_bits qq_6(a[5],b[5],mark[5],s[5],mark[6]);
   ALU_add_1_bits qq_7(a[6],b[6],mark[6],s[6],mark[7]);
   ALU_add_1_bits qq_8(a[7],b[7],mark[7],s[7],mark[8]);

   ALU_add_1_bits qq_9(a[8],b[8],mark[8],s[8],mark[9]);
   ALU_add_1_bits qq_10(a[9],b[9],mark[9],s[9],mark[10]);
   ALU_add_1_bits qq_11(a[10],b[10],mark[10],s[10],mark[11]);
   ALU_add_1_bits qq_12(a[11],b[11],mark[11],s[11],mark[12]);

   ALU_add_1_bits qq_13(a[12],b[12],mark[12],s[12],mark[13]);
   ALU_add_1_bits qq_14(a[13],b[13],mark[13],s[13],mark[14]);
   ALU_add_1_bits qq_15(a[14],b[14],mark[14],s[14],mark[15]);
   ALU_add_1_bits qq_16(a[15],b[15],mark[15],s[15],mark[16]);

   ALU_add_1_bits qq_17(a[16],b[16],mark[16],s[16],mark[17]);
   ALU_add_1_bits qq_18(a[17],b[17],mark[17],s[17],mark[18]);
   ALU_add_1_bits qq_19(a[18],b[18],mark[18],s[18],mark[19]);
   ALU_add_1_bits qq_20(a[19],b[19],mark[19],s[19],mark[20]);

   ALU_add_1_bits qq_21(a[20],b[20],mark[20],s[20],mark[21]);
   ALU_add_1_bits qq_22(a[21],b[21],mark[21],s[21],mark[22]);
   ALU_add_1_bits qq_23(a[22],b[22],mark[22],s[22],mark[23]);
   ALU_add_1_bits qq_24(a[23],b[23],mark[23],s[23],mark[24]);

   ALU_add_1_bits qq_25(a[24],b[24],mark[24],s[24],mark[25]);
   ALU_add_1_bits qq_26(a[25],b[25],mark[25],s[25],mark[26]);
   ALU_add_1_bits qq_27(a[26],b[26],mark[26],s[26],mark[27]);
   ALU_add_1_bits qq_28(a[27],b[27],mark[27],s[27],mark[28]);

   ALU_add_1_bits qq_29(a[28],b[28],mark[28],s[28],mark[29]);
   ALU_add_1_bits qq_30(a[29],b[29],mark[29],s[29],mark[30]);
   ALU_add_1_bits qq_31(a[30],b[30],mark[30],s[30],mark[31]);
   ALU_add_1_bits qq_32(a[31],b[31],mark[31],s[31],mark_32);

   
   always @(*) 
     begin
          V=((mark[31])&(~mark_32))|((~mark[31])&(mark_32));
       UN_V=mark_32;
          N=s[31];
       UN_N=0;
          Z=~(|s);
       UN_Z=~(|s);
     end
endmodule



