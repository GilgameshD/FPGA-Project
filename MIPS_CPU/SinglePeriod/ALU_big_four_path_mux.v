module ALU_big_four_path_mux(a,b,c,d,s,out); 

    input [31:0] a;
    input [31:0] b;
    input [31:0] c;
    input [31:0] d;
    input [1:0] s; 

   output reg [31:0] out;

   always @(*)
     begin
       case(s)
           2'b00:out=a;
           2'b01:out=b;
           2'b10:out=c;
           2'b11:out=d;
         default:out=0;
       endcase
     end
endmodule
