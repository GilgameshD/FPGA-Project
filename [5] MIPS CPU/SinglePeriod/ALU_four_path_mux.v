module ALU_four_path_mux(a,b,c,d,s,t,out);
 
     input a;
     input b;
     input c;
     input d;
     input s;
     input t;
 
    output reg out;
   
 always @(*)
   begin   
     if(s==0)
        begin
          case(t)
               1'b0:out=a;
               1'b1:out=b;
            default:out=0;
          endcase
        end

     if(s==1)
        begin
          case(t)
               1'b0:out=c;
               1'b1:out=d;
            default:out=0;
          endcase
        end
   end 
endmodule
