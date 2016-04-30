module ControlSignal(clkControl, testMode, modeControl, enable, clear, latch);
  input clkControl, modeControl;
  input [1 : 0] testMode;
  output enable, clear, latch;
  reg enable, clear, latch;

  // remeber last modes
  reg [1 : 0]oldMode;
  reg oldModeControl;

  reg ifCount;

  initial begin
  	ifCount <= 0;
    enable <= 0;
    clear <= 1;
    latch <= 1;
	oldModeControl <= 0;
  end

  // every time when the clk reaches
  always @(posedge clkControl) begin
  	// when mode changed we should count  
  	if(testMode != oldMode || oldModeControl != modeControl) begin	
		ifCount = 0;
	end
  	if(!ifCount) begin
		enable <= 1;   // start to count
		clear <= 0;    // clear last number
		latch <= 0;    // don't latch
		ifCount <= 1;  // have already counted

		// mode changed
		oldMode <= testMode;
		oldModeControl <= modeControl;
	end
	// changes has been finished 
    else/* if (ifCount && testMode == oldMode && oldModeControl == modeControl)*/ begin
		enable <= 0; // disable to count
		clear <= 1;  // don't clear
		latch <= 1;  // latch exist number
	end
  end
endmodule

