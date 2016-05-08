module FourBitDecimalCounter_TB();
  reg clk;
  wire [15 : 0] num;
  reg reset;
  
  initial begin
    clk <= 0;
    reset <= 1;
    #10 reset = ~reset;
  end

  always #1 clk <= ~clk;
  
  FourBitDecimalCounter dc(.clk(clk), .clear(reset), .enable(1), .num(num));
endmodule
  


