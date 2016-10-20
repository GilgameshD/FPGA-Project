module IF_IDReg(
	input clk,
	input reset,
	input clear,
	input IF_IDWrite,
	input IF_Flush,
	input [31:0] PC_in,
	input [31:0] instruction_in,
	output reg [31:0] PC_out,
	output reg [31:0] instruction_out);

always @(posedge clk or negedge reset) begin
	if(~reset | clear) begin
		PC_out <= 32'b0;
		instruction_out <= 32'b0;
	end
	else if(IF_IDWrite == 1) begin
		PC_out<=PC_in;
		if(IF_Flush == 0)
			instruction_out <= 32'b0;
		else
			instruction_out <= instruction_in;
		end
	end
endmodule
