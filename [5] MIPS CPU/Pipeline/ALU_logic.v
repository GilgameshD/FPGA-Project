module ALU_logic(a,b,fun,out);

   input [31:0] a;
   input [31:0] b;
   input [3:0] fun;
  output reg [31:0] out;

    always @(*)
      begin
        case(fun)
            4'b1000:out=a&b;
            4'b1110:out=a|b;
            4'b0110:out=a^b;
            4'b0001:out=~(a|b);
            4'b1010:out=a;
            default:out=0;
        endcase
      end
endmodule
 
          