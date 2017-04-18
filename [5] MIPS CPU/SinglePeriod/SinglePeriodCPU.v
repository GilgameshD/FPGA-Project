// the clock on board is 100MHz, but we should generate our own clock
// so the module named clock is for this function 

module SinglePeriodCPU(SystemClk, reset, RX, TX, led, switch, digi, PC8, key_i);

	input SystemClk, reset, RX;
	input [7 : 0] switch;
	input key_i;
	output [7 : 0] PC8;
	
	output TX;
	output [7  : 0] led;
	output [11 : 0] digi;

	wire   [31 : 0] NextPC;
	wire   [31 : 0] RESULT_ALUSrc1, RESULT_ALUSrc2, ALUOUT;
	wire   [31 : 0] DataBusA, DataBusB, DataBusC, instruction;
	wire   [5  : 0] ALUFun;
	wire   [4  : 0] RESULT_RegDst;
	reg    [31 : 0] PC;
	wire   key;


	// some signals and clock
	wire Sign, clk, clk_baud, RegWr, MemRd, MemWr, IRQ;

	// other signals between MUXs and Control
	wire ALUSrc1, ALUSrc2, EXTOp, LUOp;
	wire [1  : 0] RegDst;
	wire [1  : 0] MemToReg;
	wire [2  : 0] PCSrc;
	wire [31 : 0] readdata;
	
	// generate the clock 
	// clk is the frequency we use to control the whole system
	// clk_baud is for UART
	// (DONE)
	Clock              clock(.SystemClk(SystemClk),
							 .clk_baud(clk_baud), 
				             .clk(clk));

	//debounce           de(SystemClk,key_i,key);

	// this module is ram, it includes two submodules
	// one is for peripheral(including UART) and the other is for data
	// (DONE)
	RAM_TOP            ram(.xx(PC[31]),      
						   .clk_hehe(clk_baud),   
						   .clk(clk),  
						   .reset(reset),  
						   .read(MemRd),  
						   .write(MemWr),
               			   .address(ALUOUT), 
               			   .writedata(DataBusB),  
               			   .readdata(readdata), 
               			   .irqout(IRQ), 
               			   .TX(TX),    
               			   .RX(RX),
               			   .digi(digi),    
               			   .led(led),
               			   .switch(switch));

	// register file 
	// (DONE)
	RegFile            regfile(.reset(reset),
							   .clk(clk),
							   .addr1(instruction[25 : 21]),  // rs
							   .data1(DataBusA),
							   .addr2(instruction[20 : 16]),  // rt
							   .data2(DataBusB),
							   .wr(RegWr),
							   .addr3(RESULT_RegDst),
							   .data3(DataBusC));

	// save instruction
	// (DONE)
	ROM                rom(.addr(PC),
						   .Instruction(instruction));

	// generate control signal
	// (DONE)
	Control            control(.instruction(instruction), 
							   .IRQ(IRQ),  
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
			   				   .LUOp(LUOp), 
			   				   .Supervise(PC[31]));

	// use control signal to select source
	// (DONE)
	MUXChooseSignal    mux(.PCSrc(PCSrc),     
						   .RegDst(RegDst),   
						   .ALUSrc1(ALUSrc1),   
						   .ALUSrc2(ALUSrc2), 
			   		   	   .MemToReg(MemToReg),  
			   		   	   .EXTOp(EXTOp),    
			   		   	   .LUOp(LUOp),      
			   		   	   .instruction(instruction),
			   		       .DataBusA(DataBusA),  
			   		       .DataBusB(DataBusB), 
			   		       .ALUOUT(ALUOUT),    
			   		       .ReadData(readdata),
			   		       .PC(PC),        
			   		       .RESULT_ALUSrc1(RESULT_ALUSrc1), 
			   		       .RESULT_ALUSrc2(RESULT_ALUSrc2), 
			   		   	   .RESULT_RegDst(RESULT_RegDst),  
			   		   	   .DataBusC(DataBusC),
			   		   	   .RESULT_PCSrc(NextPC));

	// ALU 
	// (DONE)
	ALU                alu(.A(RESULT_ALUSrc1),
			               .B(RESULT_ALUSrc2),
			               .ALUFun(ALUFun),
			               .Sign(Sign),
			               .S(ALUOUT));

	always @(posedge clk or negedge reset)
		if(~reset)
			PC = 32'h80000000;
		else
			PC = NextPC;

	assign PC8 = PC[9 : 2];
endmodule