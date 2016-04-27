module Asyn_Addition(CLK, RESET, QOUT);
  input CLK, RESET;
  output [0 : 3] QOUT;
  reg [0 : 3] QOUT;
  reg [0 : 3] temp;
  
  always @(negedge RESET or posedge CLK)
    if(~RESET) begin
      QOUT[0] = 0;QOUT[1] = 0;QOUT[2] = 0;QOUT[3] = 0;
      temp[0] = QOUT[0];temp[1] = QOUT[1];temp[2] = QOUT[2];temp[3] = QOUT[3];
    end
    else begin
      QOUT[3] = ~QOUT[3];
      if(temp[3] == 1 && QOUT[3] == 0)
        QOUT[2] = ~QOUT[2];
      if(temp[2] == 1 && QOUT[2] == 0)
        QOUT[1] = ~QOUT[1];
      if(temp[1] == 1 && QOUT[1] == 0)
        QOUT[0] = ~QOUT[0];
      temp[0] = QOUT[0];temp[1] = QOUT[1];temp[2] = QOUT[2];temp[3] = QOUT[3];
    end
endmodule
