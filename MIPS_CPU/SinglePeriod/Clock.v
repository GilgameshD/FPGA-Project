// input the clock pulse and get two subclk
// one is for control and the other is for UART
module Clock(SystemClk, clk, clk_baud);
	  
    input SystemClk;
  	output reg clk, clk_baud;
  	
  	integer count;
    reg [8 : 0] divide;
    
  	initial begin
      clk = 0;
      clk_baud = 0;
      count = 0;
      divide = 9'b0_0000_0001;
  	end
  
  	always @(posedge SystemClk) begin
      	//if(count == 1) begin
        //  	count = 0;
          	clk = ~clk;
      	//end
      	//else
        //	count = count + 1;

        if(divide==9'b1_0100_0110) begin
          clk_baud =~clk_baud;
          divide = 9'b0_0000_0001;
        end
        else begin 
          divide = divide + 9'b0_0000_0001;
        end
    end
endmodule
