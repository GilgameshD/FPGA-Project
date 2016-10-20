module ALU_sub_32_bits(a,b,s,V,N,Z,UN_V,UN_N,UN_Z);
  
    input [31:0] a;
    input [31:0] b;

   output [31:0] s;
   output reg V;
   output reg N;
   output reg Z;
   output reg UN_V;
   output reg UN_N;
   output reg UN_Z;

     wire V_0,N_0,Z_0,UN_V_0,UN_N_0,UN_Z_0;
     wire [31:0] n_b;

   assign n_b=~b;

   ALU_add_32_bits AAA(a,n_b,1'b1,s,V_0,N_0,Z_0,UN_V_0,UN_N_0,UN_Z_0);
   
   always @(*)
     begin
          V=V_0;
          N=N_0;
          Z=Z_0;

       UN_V=~UN_V_0;
       UN_N=UN_V;
       UN_Z=Z;
     end
endmodule
