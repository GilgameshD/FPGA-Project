// we use the system clk directly to generte
// a signal whose frequency is 16*BAUD
module Clk_16Times(clk, clkOut_16times);
	input clk;                  // the system clk is 100MHz
	output reg clkOut_16times;  // output 16*BAUD

	integer num;   // count the number

	initial begin
		clkOut_16times <= 0;
		num <= 0;
	end

	always@(posedge clk) begin
		if(num == 325) begin
			clkOut_16times <= ~clkOut_16times;
			num <= 0;
		end
		else
			num <= num + 1;
	end
endmodule