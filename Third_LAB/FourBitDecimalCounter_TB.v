module FourBitDecimalCounter_TB();
  reg clk;
  wire [3 : 0] num;
  reg reset;
  
  initial begin
    clk <= 0;
    reset <= 1;
  end

  always #10 clk <= ~clk;
  always #1000 reset = ~reset;
  
  DecimalCounter dc(.clk(clk), .reset(reset), .enable(1), .num(num));
endmodule
  


