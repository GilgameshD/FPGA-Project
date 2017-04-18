// DecimalCounter for clock when enable signal is true
module DecimalCounter(clk, enable, clear, out, num);
  input clk, enable, clear;
  output out;
  output [3 : 0] num;
  reg out;
  reg [3 : 0] num;
  
  always @(posedge clk or posedge clear) begin
    if(clear) begin
      out <= 0;
      num <= 0;
    end
    else if(enable) begin
      if(num == 4'b1001) begin  // reach the number 10
        num <= 0;
        out <= 1; 
      end
      else begin
        out <= 0; 
        num <= num + 4'b1;   // add 1
      end
    end
  end
endmodule


// using four decimal counter
module FourBitDecimalCounter(clk, clear, enable, num);
  input clk, clear, enable;
  output [15 : 0] num;
  wire c0, c1, c2, c3;
  wire [15 : 0] num;
  
  // asyn counter
  // when the low counter output a signal, the higer one counts
  DecimalCounter dc0(.clk(clk), 
                     .clear(clear), 
                     .enable(enable), 
                     .num(num[3 : 0]), 
                     .out(c0));
  DecimalCounter dc1(.clk(c0), 
                     .clear(clear), 
                     .enable(enable), 
                     .num(num[7 : 4]), 
                     .out(c1));
  DecimalCounter dc2(.clk(c1), 
                     .clear(clear), 
                     .enable(enable), 
                     .num(num[11 : 8]), 
                     .out(c2));
  DecimalCounter dc3(.clk(c2), 
                     .clear(clear), 
                     .enable(enable), 
                     .num(num[15 : 12]), 
                     .out(c3));
endmodule