module ControlSignal(clkControl, testMode, modeControl, enable, clear, latch);
  input clkControl, modeControl;
  input [1 : 0] testMode;
  output enable, clear, latch;
  reg enable, clear, latch;
  reg [1 : 0]oldMode;
  reg oldModeControl;

  integer flag;

  initial begin
    enable <= 0;
    clear <= 1;
    latch <= 1;
	flag <= 0;
	oldModeControl <= 0;
  end
  always @(posedge clkControl) begin
  	if(!flag) begin
		enable <= 1; // start to count
		clear <= 0;
		latch <= 0;
		flag <= 1;
		oldMode <= testMode; // have already counted
		oldModeControl <= modeControl;
	end
    else if (flag && testMode == oldMode && oldModeControl == modeControl) begin
		enable <= 0;
		clear <= 1;  // clear to zero
		latch <= 1;
	end
	// when testMode changed 
	else if(testMode != oldMode || oldModeControl != modeControl) begin	
		flag = 0;
	end
  end
endmodule

