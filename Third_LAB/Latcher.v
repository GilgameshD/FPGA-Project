// when the signal lock is 0, we can transfer
// when the signal is 1, keep the last number
module Latcher(latch, inData, outData);
  input latch;
  input [15 : 0] inData;
  output reg [15 : 0] outData;
   
  always @(latch, inData) begin
  	if(!latch)
    	outData <= inData;
  end
endmodule