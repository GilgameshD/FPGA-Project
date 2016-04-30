module UART(clk, UART_RXD, UART_TXD);
	input clk;
	input UART_RXD;
	output UART_TXD;	

	wire clkOut;
	wire RX_STATUS, TX_STATUS, TX_EN;
	wire [7 : 0] RX_DATA, TX_DATA;

	//  the clk signals
	ClkGenerate        CG(clk,
						  clkOut);
	Clk_16Times     Clk16(clk,
					      clkOut_16times);

	UARTControl       ctl(clk,
						  RX_STATUS,
						  TX_STATUS,
						  RX_DATA,
						  TX_DATA,
						  TX_EN);

	UARTReceiver  receiver(UART_RXD,
						   clkOut_16times,
						   RX_STATUS,
						   RX_DATA);

	UARTSender 	  sender(clkOut,
						 TX_EN,
						 TX_DATA,
						 UART_TXD,
						 TX_STATUS);
endmodule