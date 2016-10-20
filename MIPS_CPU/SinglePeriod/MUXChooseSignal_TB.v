module MUXChooseSignal_TB();
  
  reg [1 : 0] RegDst, MemToReg;
  reg [2 : 0] PCSrc;    
  // data in
  reg [31 : 0] instruction, DataBusA, DataBusB, ALUOUT, ReadData, PC;
  // data out
  wire [31 : 0] RESULT_ALUSrc1, RESULT_ALUSrc2, RESULT_PCSrc, RESULT_RegDst, RESULT_MemToReg;
  reg ALUSrc1, ALUSrc2, EXTOp, LUOp;       
			   		          
  initial begin 
    instruction = 32'b000000_00111_00011_10101_00000_100000; // op_rs_rt_rd_shamt_function
    DataBusA =    32'b11111_11111_11111_11111_11111_11111_11;
    DataBusB =    32'b00000_00000_00000_00000_00000_00000_00;
    ALUOUT   =    32'b10101_10101_10101_10101_10101_10101_10;
    ReadData =    32'b00000_11111_00000_11111_00000_11111_00;
    PC       =    32'b11111_00000_11111_00000_11111_00000_11;
  end
  
  initial begin
    RegDst = 0;
    MemToReg = 0;
    PCSrc = 0;
    ALUSrc1 = 0;
    ALUSrc2 = 0;
    EXTOp = 0; 
    LUOp = 0; 
    #1 RegDst = 1;
    #1 RegDst = 2;
    #1 RegDst = 3;
    #1 PCSrc = 1;
    #1 PCSrc = 2;
    #1 PCSrc = 3;
    #1 PCSrc = 4;
    #1 PCSrc = 5;
    #1 MemToReg = 1;
    #1 MemToReg = 2;
    #1 ALUSrc1 = 1;
    #1 ALUSrc2 = 1;
    #1 LUOp = 1;
    #1 EXTOp = 1;
  end
  
  MUXChooseSignal mux(PCSrc,     
                      RegDst,   
                      ALUSrc1,   
                      ALUSrc2, 
			   		           MemToReg,  
			   		           EXTOp,    
			   		           LUOp,      
			   		           instruction,
                      DataBusA,  
                      DataBusB, 
                      ALUOUT,    
                      ReadData,
			   		           PC,        
			   		           RESULT_ALUSrc1, 
			   		           RESULT_ALUSrc2, 
			   		           RESULT_PCSrc,
			   		           RESULT_RegDst,  
			   		           RESULT_MemToReg);
endmodule