module TB();
  reg clk;
  wire [0 : 3] Q;
  reg RESET;
  
  initial begin
    clk = 0;
    RESET = 0;
  end

  // substractor and addition
  //Syn_Subtractor syn1(.CLK(clk), .QOUT(Q), .RESET(RESET));
  //Asyn_Addition asyn1(.CLK(clk), .QOUT(Q), .RESET(RESET));
  Syn_Addition   syn2(.CLK(clk), .QOUT(Q), .RESET(RESET));
   
  // display the number
  always #10 clk = ~clk;
  always #500 RESET = ~RESET;

endmodule


