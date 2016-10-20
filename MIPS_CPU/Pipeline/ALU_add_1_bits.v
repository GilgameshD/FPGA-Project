module ALU_add_1_bits(x,y,din,s,dout);

   input x;
   input y;
   input din;

   output reg s;
   output reg dout;

   always @(*)
     begin
          s=((~x)&(~y)&din)+((~x)&y&(~din))+(x&y&din)+(x&(~y)&(~din));
       dout=(x&y)+(y&din)+(x&din);
     end
endmodule 
