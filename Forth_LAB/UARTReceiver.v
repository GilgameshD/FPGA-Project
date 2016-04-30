module UARTReceiver( UART_RX, BRclk, RX_STATUS, RX_DATA);
	input UART_RX;
	input BRclk;
	output reg RX_STATUS;
	output reg [7:0] RX_DATA;

	wire samp_clk;
	reg [7:0] Time;
	assign samp_clk = Time[3];

	initial begin
		Time <= 8'b0;
		RX_STATUS <= 1'b0;
		RX_DATA <= 8'b0;
	end

	always @(posedge BRclk) begin
		if (Time == 8'b0 & UART_RX) begin
			Time <= 8'b0;
			RX_STATUS <= 1'b0;
		end
		else if (Time[7:4] == 4'd9) begin
			RX_STATUS <= 1'b1;
			Time <= 8'b0;
		end
		else begin
			Time <= Time + 4'b1;
			RX_STATUS <= 1'b0;
		end
	end

	always @(posedge samp_clk)
		RX_DATA <= {UART_RX, RX_DATA[7:1]};
endmodule
