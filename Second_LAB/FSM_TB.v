module FSM_TB(clk, KEY_CLK, INDATA, OUTDATA, STATE, RESET);
  input clk, KEY_CLK, INDATA, RESET;
  output OUTDATA;
  output [2 : 0] STATE;
  wire KEY_CLK_OUT;

  // prevent the shake of key
  debounce db(.clk(clk), .key_i(KEY_CLK), .key_o(KEY_CLK_OUT));
  FSM fsm(.x(INDATA), 
  		  .z(OUTDATA), 
  		  .clk(KEY_CLK_OUT), 
  		  .rst(RESET), 
  		  .state(STATE));
endmodule