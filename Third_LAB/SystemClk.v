// input the clock pulse and get two subclk
// one is used as control signal
// the other is used as scan signal to show the leds
module SystemClk(clk, clkControl, clkScan);
  input clk;
  output clkControl, clkScan;
  reg sigmentation1, sigmentation2;
  integer count1, count2;

  // scan signal is 1KHz
  // control signal is 1Hz
  assign clkScan = sigmentation1;
  assign clkControl = sigmentation2;
  
  initial begin
      sigmentation1 <= 0;
      sigmentation2 <= 0;
      count1 <= 0;
      count2 <= 0;
  end
  
  // every two times the signal reverse we get one period
  // 1KHz signal for control
  always @(posedge clk) begin
      if(count1 == 49999) begin
          count1 <= 0;
          sigmentation1 <= ~sigmentation1;
      end
      else
        count1 <= count1 + 1;
  end

  // 1Hz clock used for scan
  always @(posedge sigmentation1) begin
      if(count2 == 499) begin 
          count2 <= 0;
          sigmentation2 <= ~sigmentation2;
      end
      else
        count2 <= count2 + 1;
  end
endmodule
