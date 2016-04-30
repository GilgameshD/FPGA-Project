// we need a clk signal whoose frequency is 9600Hz
module ClkGenerate(clk, clkOut);
	input clk;          // the system clk is 100MHz
	output reg clkOut;  // output the BAUD = 9600Hz

	integer num;        // count the number

	initial begin
		clkOut <= 0;
		num <= 0;
	end

	always@(posedge clk) begin
		if(num == 5207) begin
			clkOut <= ~clkOut;
			num <= 0;
		end
		else
			num <= num + 1;
	end
endmodule

