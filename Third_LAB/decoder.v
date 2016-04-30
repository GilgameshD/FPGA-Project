module BCD7(din, dout);
  input   [3 : 0] din;
  output  [6 : 0] dout;

  assign  dout = 
          (din == 4'h0) ? 7'b000_0001:
          (din == 4'h1) ? 7'b000_0110:
          (din == 4'h2) ? 7'b101_1011:
          (din == 4'h3) ? 7'b100_1111:
          (din == 4'h4) ? 7'b110_0110:
          (din == 4'h5) ? 7'b110_1101:
          (din == 4'h6) ? 7'b111_1101:
          (din == 4'h7) ? 7'b000_0111:
          (din == 4'h8) ? 7'b111_1111:
          (din == 4'h9) ? 7'b110_1111:
          7'b0;
endmodule


// use four leds to show one thousand numbers
module Decoder(inData, clkScan, AN, out);
  input [15 : 0] inData;       // four number (decimal)
  input clkScan;               // clock pulse
  output [6 : 0] out;          // every leds
  output [3 : 0] AN;           // choose the led
  reg [3 : 0] AN, everyData;

  // the initial value can be any one of these four cases
  initial AN = 4'b1101;
  
  // scan the led and choose one to light
  always @(posedge clkScan) begin
	  case(AN)
	   4'b1110 : begin 
       AN <= 4'b0111;
       everyData <= inData[15 : 12];
     end
	   4'b0111 : begin 
	     AN <= 4'b1011;
	     everyData <= inData[11 : 8]; 
	   end
	   4'b1011 : begin 
	     AN <= 4'b1101;
	     everyData <= inData[7 : 4];  
     end
	   4'b1101 : begin 
	     AN <= 4'b1110;
	     everyData <= inData[3 : 0];  
      end
	  endcase
  end
	
  BCD7 b(.din(everyData), .dout(out));	
endmodule
