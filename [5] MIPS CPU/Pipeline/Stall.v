module Stall(
	input [4:0] RS_IF_ID,
	input [4:0] RT_IF_ID,
	input [4:0] RT_ID_EX,
	input ID_EXMemRead,
	input [5:0] IF_IDopcode,
	input [5:0] IF_IDfunct,
	input [1:0] IF_IDMemtoReg,
	input Zero,
	input [2:0] PCSrc_ID_EX,
	output PCWrite,
	output IF_Flush,
	output IF_IDWrite,
	output ID_Flush);


	wire LStall;
	wire JStall;
	wire BStall;

	assign LStall = (ID_EXMemRead && ((RS_IF_ID == RT_ID_EX) || (RT_IF_ID == RT_ID_EX))) ? 1'b1 : 1'b0;
	assign JStall = ((IF_IDopcode==6'b000010) || (IF_IDopcode==6'b000011)||
					((IF_IDopcode==6'b000000) && (IF_IDfunct==6'b001000))||
					((IF_IDopcode==6'b000000) && (IF_IDfunct==6'b001001))) ? 1'b1 : 1'b0;

	assign BStall = (Zero & PCSrc_ID_EX == 1) ? 1'b1 : 1'b0;

	assign PCWrite = LStall ? 1'b0 : 1'b1;

	// j and beq should flush the instrucion
	assign IF_Flush = (BStall || JStall) ? 1'b0 : 1'b1;

	assign ID_Flush = (BStall || LStall) ? 1'b0 : 1'b1;
	assign IF_IDWrite = LStall ? 1'b0 : 1'b1;

endmodule
