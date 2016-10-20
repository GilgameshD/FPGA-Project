module MEM_WBReg(
	input clk,
	input reset,
	input clear,
	input RegWrite_in,
	input [31 : 0] instruction_in,
	input [1 : 0] RegDst_in,

	output reg RegWrite_out,
	output reg [31 : 0] instruction_out,
	input [31 : 0] ALUOUT_IN,
	output reg [31 : 0] ALUout_OUT,
	input [31 : 0] PC_IN,
	output reg [31 : 0] PC_OUT,
	input [31 : 0] readdata_in,
	output reg [31 : 0] readdata_out,
	input [1 : 0] memToReg_in,
	output reg [1 : 0] memToReg_out,
	output reg [1 : 0] RegDst_out);

	always @(posedge clk or negedge reset)
		if(~reset | clear) begin
			RegWrite_out    <= 1'b0;
			instruction_out <= 32'b0;
			ALUout_OUT      <= 32'b0;
			PC_OUT          <= 32'b0;
			readdata_out    <= 32'b0;
			memToReg_out   <= 32'b0;
			RegDst_out <= 32'b0;
		end
		else begin
			RegWrite_out<=RegWrite_in;
			instruction_out<=instruction_in;
			ALUout_OUT <= ALUOUT_IN;
			PC_OUT <= PC_IN;
			readdata_out <= readdata_in;
			memToReg_out <= memToReg_in;
			RegDst_out <=   RegDst_in;
	end

endmodule
