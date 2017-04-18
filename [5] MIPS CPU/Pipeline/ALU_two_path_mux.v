module ALU_two_path_mux(a,b,s,out);
 
     input a;
     input b;
     input s;
    output reg out;
   
    always@(*)
      begin 
        out=((~s)&a)+(s&b);
      end
endmodule
