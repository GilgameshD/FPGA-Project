module test(testmode, clk, modecontrol, highfreq, cathodes, AN);
  input [1 : 0] testmode;
  input clk;
  input modecontrol;
  output highfreq;
  output [6 : 0] cathodes;
  output [3 : 0] AN;
  wire sigin;
  
  // input four signals to be detected
  signalinput signalin(.testmode(testmode), 
                       .sysclk(clk), 
                       .sigin1(sigin));
  
  // the module of frequency detection
  frequency freq(.sigin(sigin), 
                 .testmode(testmode), 
                 .sysclk(clk), 
                 .modecontrol(modecontrol), 
                 .highfreq(highfreq), 
                 .cathodes(cathodes), 
                 .AN(AN));
endmodule
