module SinglePeriodCPU_TB();
	
	reg SystemClk, reset, RX;
	reg  [7 : 0]  switch;
	wire [7 : 0] led;
	wire [11 : 0] digi;
	wire TX;
	reg [24 : 0] data;

	initial begin
		switch = 8'b00000000;
		reset = 0;
		#1 reset = 1;
		SystemClk = 0;
		RX <= 1;
		// the data is received from right to left, and every 8bits should start with 0
		// and end with 1. When there is no data, the data signal should be 1
		// low bit first
		data <= 25'b11_00010010_011_00001100_0111;
	end

	always #1 SystemClk <= ~SystemClk;
	// 10^9 / 9600 * 2 = 20834
	always #20834 {data, RX} <= {1'b1, data};
	//always #20834 {data, UART_RX} = {data[58 : 0], data[59]};

	SinglePeriodCPU cpu(SystemClk, reset, RX, TX, led, switch, digi);
endmodule
