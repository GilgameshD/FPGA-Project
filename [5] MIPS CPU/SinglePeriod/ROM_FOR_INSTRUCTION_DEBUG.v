module ROM (addr, data);

	input [31 : 0] addr;
	output [31 : 0] data;

	reg [31 : 0] data;

	// 8bits rom, the size is 2^8 = 256
	localparam ROM_SIZE = 256;
	reg [31 : 0] ROM_DATA [ROM_SIZE-1:0];

	always@(*)
		case(addr[9 : 2])	//Address Must Be Word Aligned.

			// j main
			8'd0:  data <= {6'b000010, 26'd3};
			// j interrupt 
			8'd1:  data <= {6'b000010, 26'd44};
			// j error
			8'd2:  data <= {6'b000010, 26'd2};

			///////////////////////   main   ///////////////////////////
			// firstly put two numbers into $a0 and $t2
			// use addi $a0 $zero 3
			// use addi $t2 $zero 2
			8'd3:  data <= {6'b001000, 5'd0 , 5'd4 , 16'h4000};
			8'd4:  data <= {6'b001000, 5'd4 , 5'd0, 16'd0};
			// (DONE)

			//////////////////////  test uart   /////////////////////
			// test UART_TX, firstly we should get the base address 0x40000000
			// we use lui to load 0x4000s
			8'd5:  data <= {6'b001111, 5'd0 , 5'd4, 16'h4000};
			// we use add to put the base address in $a0
			8'd6:  data <= {6'b001000, 5'd4 , 5'd4 , 16'h0018};
			// sw $a0, 0($0)
			8'd7:  data <= {6'b101011, 5'd4 , 5'd0, 16'd0};
			// (DONE)

			///////////////////////////////////////////////////////////////////
			// instructions below is the same format :xx $v1, $a0, $t2
			// addu $v1, $a0, $t2
			//8'd5:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100001};
			// sub  $v1, $a0, $t2
			//8'd6:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100010};
			// subu $v1, $a0, $t2
			//8'd7:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100011};
			// and  $v1, $a0, $t2
			//8'd8:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100100};
			// or   $v1, $a0, $t2
			//8'd9:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100101};
			// xor  $v1, $a0, $t2
			//8'd10:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100110};
			// nor  $v1, $a0, $t2
			//8'd11:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b100111};
			// sll  $v1, $a0, $t2
			//8'd12:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd1 , 6'b000000};
			// sra  $v1, $a0, $t2
			//8'd13:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd1 , 6'b000011};
			// srl $v1, $a0, $t2
			//8'd14:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd1 , 6'b000010};
			// slt  $v1, $a0, $t2
			//8'd15:  data <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'b101010};

			// instructions below is I-type
			// addiu $a1, $zero, 10
			//8'd16:  data <= {6'b001000, 5'd0 , 5'd5 , 16'd10};
			// andi $a1, $zero, 10
			//8'd17:  data <= {6'b001100, 5'd0 , 5'd5 , 16'd10};
			// slti $a1, $zero, 10
			//8'd18:  data <= {6'b001010, 5'd0 , 5'd10, 16'd10};
			// sltiu $a1, $zero, 10
			//8'd19:  data <= {6'b001011, 5'd0 , 5'd10, 16'd10};
			// sw $t2, 4($a0)
			//8'd20:  data <= {6'b101011, 5'd4 , 5'd10, 16'd4};
			// lw $t3, 4($a0)
			//8'd21:  data <= {6'b100011, 5'd4 , 5'd11, 16'd4};
			// lui$ $t3, 10
			//8'd22:  data <= {6'b001111, 5'd0 , 5'd11, 16'd10};

			// instructions below can jump to another address
			// beq (DONE)
			//8'd23:  data <= {6'b000100, 5'd4 , 5'd4 , 16'b1111111111111111};
			// bne (DONE)
			//8'd23:  data <= {6'b000101, 5'd4 , 5'd3 , 16'b1111111111111111};

			////////////////////////////////////////////////////////////////////////
			// blez
			//8'd23:  data <= {6'b000100, 5'd4 , 5'd4 , 16'd0};
			// bgtz
			//8'd26:  data <= {6'b000111, 5'd4 , 5'd4 , 16'd0};
			// bltz
			//8'd27:  data <= {6'b000001, 5'd4 , 5'd4 , 16'd0};
			///////////////   TO DO   ///////////////////////////////////////////////


			// jal (DONE)
			//8'd23:  data <= {6'b000011, 26'd23};
			// jr  (DONE) (jump to $rs) 
			//8'd23:  data <= {6'b000000, 5'd4 , 10'd0 , 5'd0, 6'b001000};
			// jalr (DONE) (jump to $rs and save the return address in $ra)
			//8'd23:  data <= {6'b000000, 5'd4 , 5'd0 , 5'd31, 5'd0, 6'b001001};
			// Loop:
			// j   (DONE)
			8'd8:   data <= {6'b000010, 26'd8};

			// interrupt address interface
			// set the timer and it is used for digital number scan
			8'd44: data <= {6'b000010, 26'd44};
			8'd45: data <= {6'b000010, 26'd44};
			default: data <= 32'h80000000;
		endcase

endmodule