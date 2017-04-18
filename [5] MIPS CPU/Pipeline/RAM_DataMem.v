module RAM_DataMem(clk,       read,     write,  address,
                   writedata, readdata, reset);

      input clk;
      input read;
      input write;
      input [31 : 0] address;
      input [31 : 0] writedata;
      input reset;

      output reg [31 : 0] readdata;

      parameter RS = 256;
      reg [31 : 0] RAM_DATA[RS - 1 : 0];

      reg flag1;
      always @(*) begin
        flag1 = (address < RS) && read;
      end

      always @(*) begin
        if(flag1 == 1) begin
          readdata = RAM_DATA[address[31 : 2]];
        end
        else begin
          readdata = 32'b0;
        end
      end

      reg flag2;
      always @(*) begin
        flag2 = (address < RS) && write;
      end

      always @(posedge clk) begin
        if(flag2 == 1) begin
          RAM_DATA[address[31:2]]=writedata;
        end
      end
endmodule
