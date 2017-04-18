module Syn_Addition(CLK, RESET, QOUT);
  input CLK, RESET;
  output [0 : 3] QOUT;
  reg [0 : 3] QOUT;

  always @(negedge RESET or posedge CLK)
    if(~RESET) begin
        QOUT[0] = 0;QOUT[1] = 0;QOUT[2] = 0;QOUT[3] = 0;
    end
    else begin
      if(QOUT[1] == 1 && QOUT[2] == 1 && QOUT[3] == 1)
        QOUT[0] = ~QOUT[0];
      if(QOUT[2] == 1 && QOUT[3] == 1)
        QOUT[1] = ~QOUT[1];
      if(QOUT[3] == 1)
        QOUT[2] = ~QOUT[2];
      QOUT[3] = ~QOUT[3];
    end
endmodule
