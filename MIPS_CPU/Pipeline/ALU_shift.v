module ALU_shift(a,b,fun,out);

     input [31:0] a;
     input [31:0] b;
     input [1:0] fun;
    
    output [31:0] out;

  wire [31:0] right_1,right_2,right_4,right_8,right_16;
  wire [31:0] al_1,al_2,al_4,al_8,al_16;
  wire [31:0] left_1,left_2,left_4,left_8,left_16;

    right_shift_1     r_1_v(a[0],b,right_1);
    right_shift_2     r_2_v(a[1],right_1,right_2);
    right_shift_4     r_3_v(a[2],right_2,right_4);
    right_shift_8     r_4_v(a[3],right_4,right_8);
    right_shift_16    r_5_v(a[4],right_8,right_16);
    
    al_shift_1        al_1_v(a[0],b,al_1);
    al_shift_2        al_2_v(a[1],al_1,al_2);
    al_shift_4        al_3_v(a[2],al_2,al_4);
    al_shift_8        al_4_v(a[3],al_4,al_8);
    al_shift_16       al_5_v(a[4],al_8,al_16);
 
    left_shift_1      l_1_v(a[0],b,left_1);
    left_shift_2      l_2_v(a[1],left_1,left_2);
    left_shift_4      l_3_v(a[2],left_2,left_4);
    left_shift_8      l_4_v(a[3],left_4,left_8);
    left_shift_16     l_5_v(a[4],left_8,left_16);
 
    ALU_big_four_path_mux hehe(left_16,right_16,b,al_16,fun,out); 
endmodule
//////////////////////////////////////////////////////////////////////////////////
module right_shift_1(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din>>1;end 
   ALU_big_two_path_mux B_M_1(din,temp,mark,dout);
endmodule

module right_shift_2(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din>>2;end 
   ALU_big_two_path_mux B_M_2(din,temp,mark,dout);
endmodule

module right_shift_4(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din>>4;end 
   ALU_big_two_path_mux B_M_3(din,temp,mark,dout);
endmodule

module right_shift_8(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din>>8;end 
   ALU_big_two_path_mux B_M_4(din,temp,mark,dout);
endmodule

module right_shift_16(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din>>16;end 
   ALU_big_two_path_mux B_M_5(din,temp,mark,dout);
endmodule
//////////////////////////////////////////////////////////////////////////////////
module al_shift_1(mark,din,dout);

   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;
   
   always @(*)begin temp[30:0]=din[30:0]>>1;end
   always @(*)begin temp[31]=din[31];end
   ALU_big_two_path_mux B_M_6(din,temp,mark,dout);
endmodule

module al_shift_2(mark,din,dout);

   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;
   
   always @(*)begin temp[30:0]=din[30:0]>>2;end
   always @(*)begin temp[31]=din[31];end
   ALU_big_two_path_mux B_M_7(din,temp,mark,dout);
endmodule

module al_shift_4(mark,din,dout);

   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;
   
   always @(*)begin temp[30:0]=din[30:0]>>4;end
   always @(*)begin temp[31]=din[31];end
   ALU_big_two_path_mux B_M_8(din,temp,mark,dout);
endmodule

module al_shift_8(mark,din,dout);

   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;
   
   always @(*)begin temp[30:0]=din[30:0]>>8;end
   always @(*)begin temp[31]=din[31];end
   ALU_big_two_path_mux B_M_9(din,temp,mark,dout);
endmodule

module al_shift_16(mark,din,dout);

   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;
   
   always @(*)begin temp[30:0]=din[30:0]>>16;end
   always @(*)begin temp[31]=din[31];end
   ALU_big_two_path_mux B_M_10(din,temp,mark,dout);
endmodule
//////////////////////////////////////////////////////////////////////////////////
module left_shift_1(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din<<1;end 
   ALU_big_two_path_mux B_M_11(din,temp,mark,dout);
endmodule

module left_shift_2(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din<<2;end 
   ALU_big_two_path_mux B_M_12(din,temp,mark,dout);
endmodule

module left_shift_4(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din<<4;end 
   ALU_big_two_path_mux B_M_13(din,temp,mark,dout);
endmodule

module left_shift_8(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din<<8;end 
   ALU_big_two_path_mux B_M_14(din,temp,mark,dout);
endmodule

module left_shift_16(mark,din,dout);
  
   input mark;
   input [31:0] din;
  output [31:0] dout;
     reg [31:0] temp;

   always @(*)begin temp=din<<16;end 
   ALU_big_two_path_mux B_M_15(din,temp,mark,dout);
endmodule
//////////////////////////////////////////////////////////////////////////////////
