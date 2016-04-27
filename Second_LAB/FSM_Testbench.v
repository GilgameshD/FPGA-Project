module FSM_TB();
  reg clk, rst;
  reg [24 : 0] data;
  wire z, x;
  wire [2 : 0] state;
 
  assign x = data[24];
 
  initial begin
    clk = 0;
    rst = 1;
    #30 rst = 0;
    data = 25'b0010_1011_0101_1100_0101_01100;
  end
  
  // left shift the serial
  always #20 clk = ~clk;
  always @ (posedge clk) #2 data = {data[23 : 0], data[24]};
    
  FSM U1(.x(x), .z(z), .clk(clk), .state(state), .rst(rst));
endmodule


