module EX_MEMReg(
	input clk,
	input reset,
	input clear,
	input RegWrite_in,
	input MemWrite_in,
	input MemRead_in,
	input [1:0] MemtoReg_in,
	input [31:0] PC_in,
	input [31:0] ALUout_in,
	input [31 : 0] instruction_in,
	input [1 : 0] RegDst_in,
	input [31 : 0] DataBusB_in,

	output reg RegWrite,
	output reg MemWrite,
	output reg MemRead,
	output reg [1:0] MemtoReg,
	output reg [31:0] PC,
	output reg [31:0] ALUout,
	output reg [31 : 0] instruction_out,
	output reg [31 : 0] ALUOUT_EX_MEM,
	output reg [1 : 0] RegDst_out,
	output reg [31 : 0] DataBusB_out);

	always @(posedge clk or negedge reset) begin
		if(~reset | clear)begin
			RegWrite<=1'b0;
			MemWrite<=1'b0;
			MemRead<=1'b0;
			MemtoReg<=2'b0;
			PC<=32'b0;
			ALUout<=32'b0;
			instruction_out <= 32'b0;
			ALUOUT_EX_MEM <= 32'b0;
			RegDst_out <= 0;
			DataBusB_out <= 0;
		end
		else begin
			PC<=PC_in;
			MemtoReg<=MemtoReg_in;
			RegWrite<=RegWrite_in;
			MemRead<=MemRead_in;
			MemWrite<=MemWrite_in;
			ALUout<=ALUout_in;
			instruction_out<=instruction_in;
			ALUOUT_EX_MEM <= ALUout_in;
			RegDst_out <= RegDst_in;
			DataBusB_out <= DataBusB_in;
		end
	end

endmodule
