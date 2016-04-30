module ControlSignal_TB();
  reg clkControl;
  wire enable, lock, reset;
  
  initial begin
      clkControl <= 0;
  end
  
  always #10 clkControl = ~clkControl;
    
  ControlSignal cont(.clkControl(clkControl), .enable(enable), .reset(reset), .lock(lock));
endmodule
