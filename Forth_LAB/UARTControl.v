module UARTControl(sysclk, RX_STATUS, TX_STATUS, RX_DATA, TX_DATA, TX_EN);
	input sysclk;
	input RX_STATUS;
	input TX_STATUS;
	input [7 : 0] RX_DATA;
	output reg [7 : 0] TX_DATA;
	output reg TX_EN;

	reg rx_status;
	reg status;   //0 means nodata, 1 means data waiting
	wire [7 : 0] SendData;
	
	assign SendData = RX_DATA[7] ? ~RX_DATA : RX_DATA;

	initial	begin
		rx_status <= 1'b0;
		status <= 1'b0;
		TX_DATA <= 8'b0;
		TX_EN <= 1'b0;
	end
	
	always @(posedge sysclk) begin
		//received
		if (RX_STATUS && ~rx_status) begin
			if (TX_STATUS)
			begin
				TX_DATA <= SendData;
				TX_EN <= 1'b1;
			end
			else begin
				status <= 1'b1;
			end
		end
		else begin
			if (TX_EN)  //sent
				TX_EN <= 1'b0;
			if (status && TX_STATUS) begin
				TX_DATA <= SendData;
				TX_EN <= 1'b1;
				status <= 1'b0;
			end
		end
		rx_status <= RX_STATUS;
	end
endmodule