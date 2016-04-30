// we use SW7 to choose the mode
// if the signal is a high frequency signal
// we divide it by 10
// and to show we have done this, using LED7 to bright.
module FrequencyChoose(signalIn, 
                       frequencyControl, 
                       signalOut, 
                       highFrequency);
  input signalIn, frequencyControl;
  output signalOut, highFrequency;
  
  reg divideFrequency;  // to remember the divided frequency 
  integer count;
  wire highFrequency;
  
  initial begin
    count <= 0;
    divideFrequency <= 0;
  end

  assign signalOut = (frequencyControl == 1)? divideFrequency : signalIn;
  assign highFrequency = frequencyControl;   // light the led 
  
  // we should count the number every 5 times
  // then the signal will be divided into 1/10
  always @(posedge signalIn) begin
    if(count == 4) begin
      count <= 0;
      divideFrequency <= ~divideFrequency;
    end
    else 
      count <= count + 1;
  end
endmodule
  
