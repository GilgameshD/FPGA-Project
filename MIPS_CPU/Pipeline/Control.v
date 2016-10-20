// the signal named supervise is used to check if the IRQ is able
// when supervise is 0, we are in user's state, IRQ can be used

module Control(instruction, IRQ,  PCSrc, RegDst, RegWr,    ALUSrc1, ALUSrc2, 
			   ALUFun,      Sign, MemRd, MemWr,  MemToReg, EXTOp,   LUOp, 
			   Supervise);
	
	input IRQ, Supervise;
	input [31 : 0] instruction;
	output RegWr, ALUSrc1, ALUSrc2, Sign, MemWr, MemRd, EXTOp, LUOp;
	output [1 : 0] RegDst, MemToReg;
	output [2 : 0] PCSrc;
	output [5 : 0] ALUFun;
	
	reg RegWr, ALUSrc1, ALUSrc2, Sign, MemWr, MemRd, EXTOp, LUOp;
	reg [1 : 0] RegDst, MemToReg;
	reg [2 : 0] PCSrc;
	reg [5 : 0] ALUFun;

	always @* begin
		// interrupt instruction
		if(IRQ == 1'b1 && Supervise == 1'b0) begin
			PCSrc  = 3'b100;    RegDst = 2'b11; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
			ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b11;
			EXTOp  = 0;         LUOp   = 0;
		end
		// nop instruction (sll $0 $0 0)
		else if(instruction == 32'b0) begin
			PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
			ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
			EXTOp  = 0;         LUOp   = 0;
		end
		// other instructions
		else begin
			// R type instruction
			if(instruction[31 : 26] == 6'b000000) begin
				case(instruction[5 : 0])
					// add
					6'b100000 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 1;  MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;      LUOp   = 0;
					end
					// addu (only Sign is different from add)
					6'b100001 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// sub
					6'b100010 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000001; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;      LUOp   = 0;
					end
					// subu (only Sign is different from sub)
					6'b100011 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000001; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;      LUOp   = 0;
					end
					// and
					6'b100100 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b011000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// or
					6'b100101 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b011110; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;      LUOp   = 0;
					end
					// xor
					6'b100110 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b010110; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;      LUOp   = 0;
					end
					// nor
					6'b100111 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b010001; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// sll 
					6'b000000 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 1; ALUSrc2  = 0; 
						ALUFun = 6'b100000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// srl
					6'b000010 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 1; ALUSrc2  = 0; 
						ALUFun = 6'b100001; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// sra
					6'b000011 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 1; ALUSrc2  = 0; 
						ALUFun = 6'b100011; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// slt
					6'b101010 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b110101; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// jr
					6'b001000 : begin
						PCSrc  = 3'b011;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
          end
					// jalr
					6'b001001 : begin
						PCSrc  = 3'b011;    RegDst = 2'b10; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b10;
						EXTOp  = 0;         LUOp   = 0;
					end
					// default instruction 
					// when the code of instruction can not be recognized
					// this is an abnormal situation
					default : begin
						PCSrc  = 3'b101;    RegDst = 2'b11; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b11;
						EXTOp  = 0;         LUOp   = 0;
					end
				endcase
			end
			// not R type
			else begin
				case(instruction[31 : 26])
					// addi (I)
					6'b001000 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b000000; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// addiu (I)
					6'b001001 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// andi (I)
					6'b001100 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b011000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// slti (I)
					6'b001010 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b110101; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// sltiu (I) ************  not sure  *************
					6'b001011 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b110101; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// lui (I)
					6'b001111 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b000000; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 1;
					end
					// lw
					6'b100011 : begin
						PCSrc  = 3'b000;    RegDst = 2'b01; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b000000; Sign   = 1;     MemWr = 0; MemRd   = 1; MemToReg = 2'b01;
						EXTOp  = 1;         LUOp   = 0;
					end
					// sw
					6'b101011 : begin
						PCSrc  = 3'b000;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 1; 
						ALUFun = 6'b000000; Sign   = 1;     MemWr = 1; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// beq 
					6'b000100 : begin
						PCSrc  = 3'b001;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b110011; 
						Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// bne (only ALUFun is different from beq)
					6'b000101 : begin
						PCSrc  = 3'b001;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b110001; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// blez (only ALUFun is different from beq)
					6'b000110 : begin
						PCSrc  = 3'b001;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b111101; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// bgtz 
					6'b000111 : begin
						PCSrc  = 3'b001;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b111111; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// bltz  ***************  not sure  ***************
					6'b000001 : begin
						PCSrc  = 3'b001;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b111011; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 1;         LUOp   = 0;
					end
					// j
					6'b000010 : begin
						PCSrc  = 3'b010;    RegDst = 2'b00; RegWr = 0; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b00;
						EXTOp  = 0;         LUOp   = 0;
					end
					// jal
					6'b000011 : begin
						PCSrc  = 3'b010;    RegDst = 2'b10; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 1;     MemWr = 0; MemRd   = 0; MemToReg = 2'b10;
						EXTOp  = 0;         LUOp   = 0;
					end
					// default instruction 
					// when the code of instruction can not be recognized
					// this is an abnormal situation
					default : begin
						PCSrc  = 3'b101;    RegDst = 2'b11; RegWr = 1; ALUSrc1 = 0; ALUSrc2  = 0; 
						ALUFun = 6'b000000; Sign   = 0;     MemWr = 0; MemRd   = 0; MemToReg = 2'b11;
						EXTOp  = 0;         LUOp   = 0;
					end
				endcase
			end
		end
	end
endmodule