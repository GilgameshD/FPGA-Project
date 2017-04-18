module serialDetect(x, clk, rst, z, outData);
  input x;
  input clk;
  input rst;
  output z;
  output [5 : 0] outData;
  reg [5 : 0] outData;
 
  assign z = (outData == 6'b101011) ? 1'b1:1'b0;
 
  always @ (posedge clk or negedge rst) begin
    if(!rst)
      outData <= 6'd0;
    else
      outData <= {outData[5 : 0], x};
  end
endmodule 