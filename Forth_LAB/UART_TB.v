module UART_tb(CLOCK_50, KEY, UART_RXD, UART_TXD);
	output reg CLOCK_50;
	output reg KEY;
	output reg UART_RXD;
	output wire UART_TXD;

	reg [59 : 0] temp;

	initial begin
	KEY <= 1'b1;
	CLOCK_50 <= 1'b0;
	UART_RXD <= 1'b1;
	temp <= 60'b111_00101101_011_00000000_01111_11111111_01111_00001111_011_10011010_0;
	end

	initial fork
	#1 KEY <= 1'b0;
	#2 KEY <= 1'b1;
	forever #1 CLOCK_50 <= ~CLOCK_50;
	forever #10416 {temp,UART_RXD} <= {1'b1,temp};
	join

	UART u(CLOCK_50, KEY, UART_RXD, UART_TXD);
endmodule