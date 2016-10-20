module Forwarding(
	input RegWrite_EX_MEM,
	input RegWrite_MEM_WB,
	input RegWrite_ID_EX,
	input [4:0] RS_ID_EX,
	input [4:0] RT_ID_EX,
	input [4 : 0] RS_IF_ID,
	input [4:0] RegRd_MEM_WB,
	input [2 : 0] PCSrc,

	input [1 : 0] ID_EX_RegDst, MEM_WB_RegDst, EX_MEM_RegDst,
	input [31 : 0] instruction_ID_EX, instruction_EX_MEM, instruction_MEM_WB,

	output reg [1:0] ForwardA,
	output reg [1:0] ForwardB,
	output reg [1:0] ForwardJR
	);
	
	// EX and MEM forwarding
	wire [4 : 0] EX_MEM_Rd;
	assign EX_MEM_Rd = EX_MEM_RegDst == 2'b00 ? instruction_EX_MEM[15 : 11] : 
						   EX_MEM_RegDst == 2'b01 ?	instruction_EX_MEM[20 : 16] :
					       5'b00000;

	always @ (*) begin
		// ALU result is used before we get it
		if(RegWrite_EX_MEM & (EX_MEM_Rd != 0) & (EX_MEM_Rd == RS_ID_EX))
			ForwardA <= 2'b10;
		else if(RegWrite_MEM_WB & (RegRd_MEM_WB != 0) & ~(RegWrite_EX_MEM & EX_MEM_Rd != 0 & (EX_MEM_Rd != RS_ID_EX))& (RS_ID_EX == RegRd_MEM_WB))
			ForwardA <= 2'b01;
		else if(RegWrite_MEM_WB & RegRd_MEM_WB != 0 & RegRd_MEM_WB == RS_ID_EX)
			ForwardA <= 2'b01;
		else
			ForwardA <= 2'b00;
		end
		
	always @ (*) begin
		if(RegWrite_EX_MEM & (EX_MEM_Rd != 0) & (EX_MEM_Rd == RT_ID_EX))
			ForwardB <= 2'b10;
		else if(RegWrite_MEM_WB & (RegRd_MEM_WB != 0) & ~(RegWrite_EX_MEM & EX_MEM_Rd != 0 & (EX_MEM_Rd != RT_ID_EX)) & (RT_ID_EX == RegRd_MEM_WB))
			ForwardB <= 2'b01;
		else if(RegWrite_MEM_WB & RegRd_MEM_WB != 0 && RegRd_MEM_WB == RT_ID_EX)
			ForwardB <= 2'b01;
		else
			ForwardB <= 2'b00;
	end

	// jr instruction forwarding
	wire [4 : 0] EX_AddrC, EX_MEM_AddrC, MEM_WB_AddrC;
	assign EX_AddrC = ID_EX_RegDst == 2'b00 ? instruction_ID_EX[15 : 11]:
					  ID_EX_RegDst == 2'b01 ? instruction_ID_EX[20 : 16]:
					  ID_EX_RegDst == 2'b10 ? 5'd31:
					  5'b11010;

	assign EX_MEM_AddrC = EX_MEM_RegDst == 2'b00 ? instruction_EX_MEM[15 : 11]:
					  	  EX_MEM_RegDst == 2'b01 ? instruction_EX_MEM[20 : 16]:
					  	  EX_MEM_RegDst == 2'b10 ? 5'd31:
					  	  5'b11010;
	assign MEM_WB_AddrC = MEM_WB_RegDst == 2'b00 ? instruction_MEM_WB[15 : 11]:
					  	  MEM_WB_RegDst == 2'b01 ? instruction_MEM_WB[20 : 16]:
					  	  MEM_WB_RegDst == 2'b10 ? 5'd31:
					  	  5'b11010;

	always@(*) begin
		if(PCSrc == 3'b011 && RS_IF_ID == EX_AddrC && EX_AddrC != 0 && RegWrite_ID_EX)
		    ForwardJR = 2'b01;
		else if(PCSrc == 3'b011 && RegWrite_EX_MEM && EX_MEM_AddrC != 0 && EX_MEM_AddrC == RS_IF_ID &&  RS_IF_ID != EX_AddrC)
			ForwardJR = 2'b10;
		else if(PCSrc == 3'b011 && RegWrite_MEM_WB && MEM_WB_AddrC!=0 && RS_IF_ID == MEM_WB_AddrC && RS_IF_ID != EX_AddrC && RS_IF_ID != EX_MEM_AddrC)
			ForwardJR = 2'b11;
		else
			ForwardJR = 2'b00;
	end
endmodule
