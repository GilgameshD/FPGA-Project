module Syn_Addition_TB(KEY, clk, RESET, led, ano, SW1, SW2, SW3);
  input RESET, clk, KEY, SW1, SW2, SW3;
  output [6 : 0] led;
  output [3 : 0] ano;
  wire  [0 : 3] Q1, Q2, Q3;
  reg   [0 : 6] led;
  wire  [6 : 0] light1, light2, light3;
  wire  KEYOUT;

  // scan the led 
  assign ano[0] = 0;assign ano[1] = 1;assign ano[2] = 1;assign ano[3] = 1;

  // key simulate the clock pulse
  // use inside clock to get rid of shake
  debounce db(.clk(clk), .key_i(KEY), .key_o(KEYOUT));
  
  // substractor and addition
  Syn_Subtractor syn1(.CLK(KEYOUT), .QOUT(Q1), .RESET(RESET));
  Asyn_Addition asyn1(.CLK(KEYOUT), .QOUT(Q2), .RESET(RESET));
  Syn_Addition   syn2(.CLK(KEYOUT), .QOUT(Q3), .RESET(RESET));
  
  // get the number using BCD(hex)
  // use switch to choose 
  BCD7 bcd(Q1, light1); BCD7 bcd2(Q2, light2); BCD7 bcd3(Q3, light3);
  
  // display the number
  always @(posedge KEYOUT) begin
    if(SW1 && !SW2 && !SW3) led <= ~light1;
    if(SW2 && !SW1 && !SW3) led <= ~light2;
    if(SW3 && !SW1 && !SW2) led <= ~light3;
  end
endmodule
