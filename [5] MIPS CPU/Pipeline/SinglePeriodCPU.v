// the clock on board is 100MHz, but we should generate our own clock
// so the module named clock is for this function 
// we use instruction to transfer the address(rd, rs, rt)
// change PC and ALUOUT and readdata

module PipelineCPU(SystemClk, reset, RX, TX, led, switch, digi);

	input SystemClk, reset, RX;
	input  [7  : 0] switch;
	output [7  : 0] led;
	output [11 : 0] digi;
	output TX;

	wire   [31 : 0] NextPC;
	wire   [31 : 0] RESULT_ALUSrc1, RESULT_ALUSrc2, ALUOUT, RESULT_DATABUSB;
	wire   [31 : 0] DataBusA, DataBusB, DataBusC;
	wire   [5  : 0] ALUFun;
	wire   [4  : 0] RESULT_RegDst;
	reg    [31 : 0] PC;

	// some signals and clock
	wire Sign, clk, clk_baud, RegWr, MemRd, MemWr, IRQ;
	wire FinalRegWrite;
	
	// other signals between MUXs and Control
	wire ALUSrc1, ALUSrc2, EXTOp, LUOp,EXTOp_OUT,LUOp_OUT;
	wire [1  : 0] RegDst;
	wire [1  : 0] MemToReg;
	wire [2  : 0] PCSrc;
	wire [31 : 0] readdata;

	// IRQ signal will cause every register being fulshed
	wire clear;
	
    //////////////////////// signals in pipeline ///////////////////////

    //signals in IF_ID
    wire IF_IDWrite, IF_Flush;
    wire [31 : 0] Instruction_IN, IF_ID_PC_OUT, instruction_IF_ID;

    //signals in ID_EX
    wire ID_Flush, ID_EX_RegWr, ID_EX_MemWr, ID_EX_MemRd, ID_EX_ALUSrc1, ID_EX_ALUSrc2;
    wire [1  : 0] ID_EX_MemToReg, ID_EX_RegDst;
    wire [5  : 0] ID_EX_ALUFun;
    wire [31 : 0] ID_EX_DataBusA, ID_EX_DataBusB, ID_EX_PC_OUT, instruction_ID_EX;
    wire [2  : 0] ID_EX_PCSrc;

    //signals in EX_MEM
    wire [1  : 0] EX_MEM_RegDst;
    wire [1  : 0] EX_MEM_MemToReg;
    wire [31 : 0] EX_MEM_PC_OUT, EX_MEM_ALUOut, instruction_EX_MEM, ALUOUT_EX_MEM;
    wire [31 : 0] EX_MEM_DataBusB;

    //signals in MEM_WB
    wire EX_MEM_RegWrite, MEM_WB_RegWrite;
    wire [1  : 0] MEM_WB_RegDst;
    wire [1  : 0] MEM_WB_MemToReg;
    wire [31 : 0] MEM_WB_PC_OUT, instruction_MEM_WB, ALU_OUT_MEM_WB, ReadData_MEM_WB;

    //signals in Forwarding
    wire [1 : 0] ForwardA, ForwardB, ForwardJR;
    wire PCWrite;

	// generate the clock 
	// clk is the frequency we use to control the whole system
	// clk_baud is for UART
	// (DONE)
	Clock              clock(.SystemClk(SystemClk),
							 .clk_baud(clk_baud), 
				             .clk(clk));
	// this module is ram, it includes two submodules
	// one is for peripheral(including UART) and the other is for data
	// (DONE)
	RAM_TOP            ram(.xx(EX_MEM_PC_OUT[31]),      
						   .clk_hehe(clk_baud),   
						   .clk(clk),  
						   .RX(RX),
						   .reset(reset),  
						   .read(EX_MEM_MemRd),    
						   .write(EX_MEM_MemWr),   
               			   .address(EX_MEM_ALUOut),         
               			   .writedata(EX_MEM_DataBusB), 

               			   // output        
               			   .readdata(readdata), 
               			   .irqout(IRQ), 
               			   .TX(TX),    
               			   .digi(digi),    
               			   .led(led),
               			   .switch(switch));

	// register file 
	RegFile            regfile(.reset(reset),
							   .clk(clk),
							   .addr1(instruction_IF_ID[25 : 21]),  // rs
							   .data1(DataBusA),
							   .addr2(instruction_IF_ID[20 : 16]),  // rt
							   .data2(DataBusB),
							   // when we enter interrupt we should write the regiter
							   // but we are now in ID, so this wr signal comes from to source
							   .wr(FinalRegWrite), 

							   // input
							   .data3(DataBusC),
							   .addr3(RESULT_RegDst));

	// save instruction
	ROM                rom(.addr(PC),
						   .Instruction(Instruction_IN));

	// generate control signal
	Control            control(.instruction(instruction_IF_ID), 
							   .Supervise(IF_ID_PC_OUT[31]),
							   .IRQ(IRQ),

							   // output
							   .PCSrc(PCSrc), 
							   .RegDst(RegDst), 
							   .RegWr(RegWr),    
							   .ALUSrc1(ALUSrc1), 
							   .ALUSrc2(ALUSrc2), 
			   				   .ALUFun(ALUFun),      
			   				   .Sign(Sign), 
			   				   .MemRd(MemRd), 
			   				   .MemWr(MemWr),  
			   				   .MemToReg(MemToReg), 
			   				   .EXTOp(EXTOp),   
			   				   .LUOp(LUOp));

	// use control signal to select source
	MUXChooseSignal    mux(.PC(PC),
						   .DataBusA(DataBusA),
						   .ALUOUT(ALUOUT),
						   .PCSrc(PCSrc),   
						   .ForwardA(ForwardA),
			   		   	   .ForwardB(ForwardB),
			   		   	   .ForwardJR(ForwardJR),
						   .ID_EX_PCSrc(ID_EX_PCSrc),  
						   .RegDst(RegDst),                // for interruption
						   .MEM_WB_RegDst(MEM_WB_RegDst),  //  in MEM/WB
						   .ALUSrc1(ID_EX_ALUSrc1),
						   .ALUSrc2(ID_EX_ALUSrc2),
						   .MemToReg(MemToReg),               // for interruption
			   		   	   .MEM_WB_MemToReg(MEM_WB_MemToReg), // for others
			   		   	   .EXTOp(EXTOp_OUT),
			   		   	   .LUOp(LUOp_OUT),
			   		   	   .instruction_IN(Instruction_IN),
			   		   	   .instruction_ID_EX(instruction_ID_EX),
			   		   	   .instruction_IF_ID(instruction_IF_ID),  
			   		   	   .instruction_EX_MEM(instruction_EX_MEM),
			   		       .ID_EX_DataBusA(ID_EX_DataBusA),
			   		       .ID_EX_DataBusB(ID_EX_DataBusB), // input    
			   		       .MEM_WB_ALUOUT(ALU_OUT_MEM_WB),
			   		       .ReadData(ReadData_MEM_WB),
			   		       .instruction_MEM_WB(instruction_MEM_WB),
			   		       .MEM_WB_PC_OUT(MEM_WB_PC_OUT),
			   		       .ID_EX_PC(ID_EX_PC_OUT), // for beq instruction
			   		       .IF_ID_PC_OUT(IF_ID_PC_OUT),
			   		       .EX_MEM_ALUOUT(EX_MEM_ALUOut),
			   		       .EX_MEM_PC_OUT(EX_MEM_PC_OUT),
			   		       .MEM_WB_RegWrite(MEM_WB_RegWrite),
			   		       .FinalRegWrite(FinalRegWrite),

			   		       // output     
			   		       .RESULT_DATABUSB(RESULT_DATABUSB),
			   		       .RESULT_ALUSrc1(RESULT_ALUSrc1), 
			   		       .RESULT_ALUSrc2(RESULT_ALUSrc2), 
			   		   	   .RESULT_RegDst(RESULT_RegDst),  
			   		   	   .DataBusC(DataBusC),  // WB 
			   		   	   .RESULT_PCSrc(NextPC));

	// ALU module
	ALU                alu(.A(RESULT_ALUSrc1),
			               .B(RESULT_ALUSrc2),
			               .ALUFun(ID_EX_ALUFun),
			               .Sign(Sign_OUT),
			               .S(ALUOUT));

	always @(posedge clk or negedge reset)
		if(~reset) begin
			PC <= 32'h80000000;
		end
		else
			if(PCWrite == 1'b1 | IRQ)
				PC <= NextPC;
	assign clear = IRQ;


//////////////////////////////////   pipe line   /////////////////////////////////
    
    IF_IDReg       IF_ID(.clk(clk),
    					.clear(clear),
						.reset(reset),
						.IF_IDWrite(IF_IDWrite),
						.IF_Flush(IF_Flush),
						.PC_in(PC),                          
						.instruction_in(Instruction_IN),

						// output
						.PC_out(IF_ID_PC_OUT),
						.instruction_out(instruction_IF_ID));

  	ID_EXReg       ID_EX(.clk(clk),
						.reset(reset),
						.clear(clear),
						.ID_Flush(ID_Flush),
						.EXTOp_in(EXTOp),                  
						.LUOp_in(LUOp),                     
						.MemtoReg_in(MemToReg),
						.PCSrc_in(PCSrc),
						.RegWrite_in(RegWr),
						.MemRead_in(MemRd),
						.MemWrite_in(MemWr),
						.RegDst_in(RegDst),
						.ALUSrc1_in(ALUSrc1),
						.ALUSrc2_in(ALUSrc2),
						.ALUFun_in(ALUFun),
						.Sign_in(Sign),
						.ReadData1_in(DataBusA),
						.ReadData2_in(DataBusB),           
						.PC_in(IF_ID_PC_OUT),
						.instruction_in(instruction_IF_ID),

						// output
						.PCSrc_out(ID_EX_PCSrc),
						.MemtoReg(ID_EX_MemToReg),
						.RegWrite(ID_EX_RegWr),               
						.MemRead(ID_EX_MemRd),                 
						.MemWrite(ID_EX_MemWr),                
						.RegDst(ID_EX_RegDst),            
						.ALUSrc1(ID_EX_ALUSrc1),
						.ALUSrc2(ID_EX_ALUSrc2),
						.ALUFun(ID_EX_ALUFun),
						.Sign(Sign_OUT),
						.PC(ID_EX_PC_OUT),
						.ReadData1(ID_EX_DataBusA),
						.ReadData2(ID_EX_DataBusB),
						.LUOp(LUOp_OUT),                         
						.EXTOp(EXTOp_OUT),                          
						.instruction_out(instruction_ID_EX));

	EX_MEMReg     EX_MEM(.clk(clk),
						.reset(reset),
						.clear(clear),
						.RegWrite_in(ID_EX_RegWr),
						.MemWrite_in(ID_EX_MemWr),
						.MemRead_in(ID_EX_MemRd),
						.MemtoReg_in(ID_EX_MemToReg),
						.PC_in(ID_EX_PC_OUT),
						.instruction_in(instruction_ID_EX),
						.ALUout_in(ALUOUT),
						.RegDst_in(ID_EX_RegDst),
						.DataBusB_in(RESULT_DATABUSB),

						// output
						.RegWrite(EX_MEM_RegWrite),
						.MemWrite(EX_MEM_MemWr),
						.MemRead(EX_MEM_MemRd),
						.MemtoReg(EX_MEM_MemToReg),
						.PC(EX_MEM_PC_OUT),
						.ALUout(EX_MEM_ALUOut),
						.instruction_out(instruction_EX_MEM),
						.ALUOUT_EX_MEM(ALUOUT_EX_MEM),
						.RegDst_out(EX_MEM_RegDst),
						.DataBusB_out(EX_MEM_DataBusB));


	MEM_WBReg     MEM_WB(.clk(clk),
						.reset(reset),
						.clear(clear),
						.RegWrite_in(EX_MEM_RegWrite),
						.readdata_in(readdata),
						.ALUOUT_IN(ALUOUT_EX_MEM),    
						.PC_IN(EX_MEM_PC_OUT),  
						.instruction_in(instruction_EX_MEM),
						.memToReg_in(EX_MEM_MemToReg),
						.RegDst_in(EX_MEM_RegDst),

						// output
						.RegWrite_out(MEM_WB_RegWrite),
						.instruction_out(instruction_MEM_WB),
						.ALUout_OUT(ALU_OUT_MEM_WB),
						.PC_OUT(MEM_WB_PC_OUT),
						.readdata_out(ReadData_MEM_WB),
						.memToReg_out(MEM_WB_MemToReg),
						.RegDst_out(MEM_WB_RegDst));
	
	Forwarding    foward(.RegWrite_EX_MEM(EX_MEM_RegWrite),
						.RegWrite_MEM_WB(MEM_WB_RegWrite),
						.RegWrite_ID_EX(ID_EX_RegWr),
						.RS_ID_EX(instruction_ID_EX[25 : 21]),
						.RT_ID_EX(instruction_ID_EX[20 : 16]),
						.RS_IF_ID(instruction_IF_ID[25 : 21]),

						// used for comparing two destinations
						.instruction_ID_EX(instruction_ID_EX),
						.instruction_MEM_WB(instruction_MEM_WB),
						.instruction_EX_MEM(instruction_EX_MEM),
						.EX_MEM_RegDst(EX_MEM_RegDst),
						.ID_EX_RegDst(ID_EX_RegDst),
						.MEM_WB_RegDst(MEM_WB_RegDst),
						.RegRd_MEM_WB(RESULT_RegDst),
						.PCSrc(PCSrc),

						// output
						.ForwardA(ForwardA),
						.ForwardB(ForwardB),
						.ForwardJR(ForwardJR));
				
	Stall         stall(
						.RS_IF_ID(instruction_IF_ID[25 : 21]),
						.RT_IF_ID(instruction_IF_ID[20 : 16]),
						.RT_ID_EX(instruction_ID_EX[20 : 16]),
						.ID_EXMemRead(ID_EX_MemRd),
						.IF_IDopcode(instruction_IF_ID[31 : 26]),
						.IF_IDfunct(instruction_IF_ID[5 : 0]),
						.IF_IDMemtoReg(ID_EX_MemToReg),
						.Zero(ALUOUT[0]),
						.PCSrc_ID_EX(ID_EX_PCSrc),

						// output         
						.PCWrite(PCWrite),
						.IF_Flush(IF_Flush),
						.IF_IDWrite(IF_IDWrite),
						.ID_Flush(ID_Flush));
endmodule