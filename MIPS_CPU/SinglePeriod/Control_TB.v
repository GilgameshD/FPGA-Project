module Control_TB();
  
  wire [1 : 0] RegDst, MemToReg;
  wire [2 : 0] PCSrc;
  wire [5 : 0] ALUFun;
  wire RegWr, ALUSrc1, ALUSrc2, LUOp;      
	wire Sign, MemRd, MemWr, EXTOp; 
  
  reg [31 : 0] instruction;
  reg IRQ, Supervise;
  
  initial begin
    instruction = 0;
    IRQ = 0;
    Supervise = 0;
    #1 instruction = 32'b000000_00000000000000000000_000000;  // nop
    #1 instruction = 32'b000000_11111111111111111111_100000;  // add
    #1 instruction = 32'b001000_11111111111111111111_000000;  // addi
    #1 instruction = 32'b000011_11111111111111111111_000000;  // jal
    #1 instruction = 32'b111111_11111111111111111111_000000;  // can not be recognized
    #1 instruction = 32'b000000_11111111111111111111_100101;  // or
    #1 instruction = 32'b000000_11111111111111111111_100100;  // and
    //#1 IRQ = 1;  // interrupt 
  end
  
  Control control(instruction, 
                  IRQ,  
                  PCSrc, 
                  RegDst, 
                  RegWr,    
                  ALUSrc1, 
                  ALUSrc2, 
			            ALUFun,      
			            Sign, 
			            MemRd, 
			            MemWr,  
			            MemToReg, 
			            EXTOp,   
			            LUOp, 
			            Supervise);
			                      
endmodule
