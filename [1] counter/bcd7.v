module BCD7(din, dout);
  input [3 : 0] din;
  output [6 : 0] dout;

  assign dout=(din == 0) ? 7'b000_0001:
              (din == 1) ? 7'b100_1111:
              (din == 2) ? 7'b001_0010:
              (din == 3) ? 7'b000_0110:
              (din == 4) ? 7'b100_1100:
              (din == 5) ? 7'b010_0100:
              (din == 6) ? 7'b010_0000:
              (din == 7) ? 7'b000_1111:
              (din == 8) ? 7'b111_1111:
              (din == 9) ? 7'b111_1011:
              (din == 10)? 7'b111_0111:  // hex a
              (din == 11)? 7'b001_1111:  // hex b
              (din == 12)? 7'b100_1110:  // hex c 
              (din == 13)? 7'b011_1101:  // hex d
              (din == 14)? 7'b100_1111:  // hex e
              (din == 15)? 7'b100_0111:  // hex f
              7'b0; 
endmodule