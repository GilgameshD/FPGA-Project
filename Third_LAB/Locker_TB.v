module Locker_TB();
  reg lock;
  reg [15:0] in;
  wire [15:0] out;

  initial begin
    lock <= 0;
    in <= 0;
  end
  
  always #5 in <= in + 1'b1;
  always #10 lock = ~lock;
  
  Locker lc(.in(in), .out(out), .lock(lock));
endmodule
