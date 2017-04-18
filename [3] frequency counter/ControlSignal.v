module ControlSignal(clkControl, testMode, modeControl, enable, clear, latch);
  input clkControl, modeControl;
  input [1 : 0] testMode;
  output enable, clear, latch;
  reg enable, clear, latch;

  // remeber last modes
  reg [1 : 0]oldMode;
  reg oldModeControl;

  initial begin
    enable <= 0;
    clear <= 1;
    latch <= 1;
  end

  // every time when the clk reaches
  always @(posedge clkControl) begin
  // when mode changed we should count  
    if(testMode != oldMode || oldModeControl != modeControl) begin  
      latch <= 0;    // dont lock
      clear <= 0;    // clear to be ready to count
      enable <= 1;   // start to count
      // mode changed
      oldMode <= testMode;
      oldModeControl <= modeControl;
    end
    else begin
      enable <= 0; // disable to count
      clear <= 1;  // don't clear
      latch <= 1;  // lock the number
    end
  end
endmodule