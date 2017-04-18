module Locker_TB();
  reg lock;
  reg [15:0] inData;
  wire [15:0] outData;

  initial begin
    lock <= 0;
    inData <= 0;
  end
  
  always #5 inData <= inData + 1'b1;
  always #10 lock = ~lock;
  
  Latcher la(lock, inData, outData);
endmodule
