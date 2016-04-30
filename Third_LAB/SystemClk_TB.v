module SystemClk_TB();
  reg clk;
  wire clkControl, clkScan;

  initial begin
    clk <= 0;
  end

  always #1 clk <= ~clk;
  SystemClk inst(.clk(clk), .clkControl(clkControl), .clkScan(clkScan));
  
endmodule
  
