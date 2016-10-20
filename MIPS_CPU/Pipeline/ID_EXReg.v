module ID_EXReg(
	input clk,
	input reset,
	input clear,
	input ID_Flush,
	input [1:0] RegDst_in,
	input RegWrite_in,
	input ALUSrc1_in,
	input ALUSrc2_in,
	input [5:0] ALUFun_in,
	input Sign_in,
	input MemWrite_in,
	input MemRead_in,
	input [1:0] MemtoReg_in,
	input [2:0] PCSrc_in,
	input [31:0] PC_in,
	input [31:0] ReadData1_in,
	input [31:0] ReadData2_in,
	input EXTOp_in,    
	input LUOp_in,
	input [31 : 0] instruction_in,
	output reg [1:0] RegDst,
	output reg RegWrite,
	output reg ALUSrc1,
	output reg ALUSrc2,
	output reg [5:0] ALUFun,
	output reg Sign,
	output reg MemWrite,
	output reg MemRead,
	output reg [1:0] MemtoReg,
	output reg [2:0] PCSrc_out,
	output reg [31:0] PC,
	output reg [31:0] ReadData1,
	output reg [31:0] ReadData2,
	output reg EXTOp,    
	output reg LUOp,
	output reg [31 : 0] instruction_out
	);

	always @(posedge clk or negedge reset) begin
	if(~reset | clear) begin
		RegDst<=2'b0;
		RegWrite<=1'b0;
		ALUSrc1<=1'b0;
		ALUSrc2<=1'b0;
		ALUFun<=6'b0;
	    Sign<=1'b0;
		MemWrite<=1'b0;
		MemRead<=1'b0;
		MemtoReg<=2'b0;
	    PCSrc_out<=3'b0;
		PC<=32'b0;
		ReadData1<=32'b0;
		ReadData2<=32'b0;
		EXTOp<=1'b0;
		LUOp<=1'b0;
		instruction_out <= 0;
		end
	else begin
	if(ID_Flush == 1) begin
		RegDst<=RegDst_in;
		RegWrite<=RegWrite_in;
		ALUSrc1<=ALUSrc1_in;
		ALUSrc2<=ALUSrc2_in;
		ALUFun<=ALUFun_in;
		Sign<=Sign_in;
		MemWrite<=MemWrite_in;
		MemRead<=MemRead_in;
		MemtoReg<=MemtoReg_in;
		EXTOp<=EXTOp_in;
		LUOp<=LUOp_in;
		end
	else begin
		RegDst<=2'b00;
		RegWrite<=1'b0;
		ALUSrc1<=1'b0;
		ALUSrc2<=1'b0;
		ALUFun<=6'b0;
		Sign<=1'b0;
		MemWrite<=1'b0;
		MemRead<=1'b0;
		MemtoReg<=2'b00;
		EXTOp<=1'b0;
		LUOp<=1'b0;
	end
	PC<=PC_in;
	ReadData1<=ReadData1_in;
	ReadData2<=ReadData2_in;
	instruction_out<=instruction_in;
	PCSrc_out<=PCSrc_in;
	end
end

endmodule
