module FrequencyChoose_TB();
  reg signalIn, frequencyControl;
  wire signalOut, highFrequency;

  initial begin
    signalIn <= 0;
    frequencyControl <= 0;
  end
  
  always #1 signalIn = ~signalIn;
  always #100 frequencyControl = ~frequencyControl;
    
  FrequencyChoose fc(.signalIn(signalIn), 
                     .signalOut(signalOut), 
                     .highFrequency(highFrequency), 
                     .frequencyControl(frequencyControl));
endmodule 
