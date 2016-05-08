module ControlSignal_TB();
  reg clkControl;
  wire enable, lock, reset;
  reg testMode, modeControl;
  
  initial begin
      clkControl <= 0;
      testMode <= 0;
      modeControl <= 0;
  end
  
  always #1 clkControl = ~clkControl;
  always #100 testMode =~ testMode;
  always #200 modeControl =~ modeControl;
    
  ControlSignal cs(clkControl, testMode, modeControl, enable, clear, latch);
endmodule
