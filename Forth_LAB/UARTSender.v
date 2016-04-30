module UARTSender(BRclk, TX_EN, TX_DATA, UART_TX, TX_STATUS);
	input BRclk;
	input TX_EN;
	input [7 : 0] TX_DATA;
	output reg UART_TX;
	output reg TX_STATUS;

	reg send_clk;
	reg [3 : 0] Time, count;

	initial begin
		send_clk <= 1'b0;
		Time <= 4'b0;
		count <= 4'h0;
		UART_TX <= 1'b1;
		TX_STATUS <= 1'b1;
	end

	always @(posedge BRclk or posedge TX_EN) begin
		if (TX_EN) begin
			send_clk <= 1'b1;
			Time <= 4'b0;
		end
		else begin
			if (~TX_STATUS) begin
				send_clk <= ~Time[3];
				Time <= Time + 4'b1;
			end
			else begin
				send_clk <= 1'b0;
				Time <= 4'b0;
			end
		end
	end
	
	always @(posedge send_clk) begin
		case(count)
			4'h0:begin UART_TX <= 0;TX_STATUS<=0;end
			4'h1:begin UART_TX <= TX_DATA[0];TX_STATUS<=0;end
			4'h2:begin UART_TX <= TX_DATA[1];TX_STATUS<=0;end
			4'h3:begin UART_TX <= TX_DATA[2];TX_STATUS<=0;end
			4'h4:begin UART_TX <= TX_DATA[3];TX_STATUS<=0;end
			4'h5:begin UART_TX <= TX_DATA[4];TX_STATUS<=0;end
			4'h6:begin UART_TX <= TX_DATA[5];TX_STATUS<=0;end
			4'h7:begin UART_TX <= TX_DATA[6];TX_STATUS<=0;end
			4'h8:begin UART_TX <= TX_DATA[7];TX_STATUS<=0;end
			default:begin UART_TX<=1;TX_STATUS<=1;end
		endcase
		if(count == 4'h9)
			count <= 4'h0;
		else	
			count <= count + 4'b1;
	end
endmodule
