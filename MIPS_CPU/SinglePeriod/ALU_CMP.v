module ALU_CMP(Z,V,N,fun,out);

    input Z;
    input V;
    input N;
    input [2:0] fun;
   
   	output reg [31:0] out;

	always @(*) begin
		out[31:1] = 31'b0000_0000_0000_0000_0000_0000_0000_000;
		case(fun)
			3'b001 : out[0] = Z;
			3'b000 : out[0] = ~Z;
			3'b010 : out[0] = N^V;
			3'b110 : out[0] = (Z)|(N^V);
			3'b101 : out[0] = (N^V);
			//3'b111 : out[0] = Z&(~(N^V));
			3'b111 : out[0] = ~Z;
			default: out[0] = 0;
		endcase
	end
endmodule





















