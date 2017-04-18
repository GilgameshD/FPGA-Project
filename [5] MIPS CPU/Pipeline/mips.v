				//j       Main          # main funcyion
			7'h00:    Instruction <= {6'h02, 26'h0000003};
				//j       Interruption  # interrupt entrance
			7'h01:    Instruction <= {6'h02, 26'h000005d};
				//j       Exception     # exception entrance
			7'h02:    Instruction <= {6'h02, 26'h000006b};
				//jal     KernelToUser
			7'h03:    Instruction <= {6'h03, 26'h0000005};
				//j       User
			7'h04:    Instruction <= {6'h02, 26'h0000007};
				//andi    $ra,     $ra,     0xffff 
			7'h05:    Instruction <= {6'h0c, 5'd31, 5'd31, 16'hffff};
				//jr      $ra
			7'h06:    Instruction <= {6'h00, 5'd31, 21'h08};
				//lui     $s7,     0x4000          # use $s7 to save peripheral base address
			7'h07:    Instruction <= {6'h0f, 5'h00, 5'd23, 16'h4000};
				//addi    $t0,     $zero,      0xc0   #0
			7'h08:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00c0};
				//sw      $t0,     0x00($zero)
			7'h09:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0000};
				//addi    $t0,     $zero,      0xf9   #1
			7'h0a:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00f9};
				//sw      $t0,     0x04($zero)
			7'h0b:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0004};
				//addi    $t0,     $zero,      0xa4   #2
			7'h0c:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00a4};
				//sw      $t0,     0x08($zero)
			7'h0d:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0008};
				//addi    $t0,     $zero,      0xb0   #3
			7'h0e:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00b0};
				//sw      $t0,     0x0c($zero)
			7'h0f:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h000c};
				//addi    $t0,     $zero,      0x99   #4
			7'h10:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0099};
				//sw      $t0,     0x10($zero)
			7'h11:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0010};
				//addi    $t0,     $zero,      0x92   #5
			7'h12:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0092};
				//sw      $t0,     0x14($zero)
			7'h13:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0014};
				//addi    $t0,     $zero,      0x82   #6
			7'h14:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0082};
				//sw      $t0,     0x18($zero)
			7'h15:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0018};
				//addi    $t0,     $zero,      0xf8   #7
			7'h16:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00f8};
				//sw      $t0,     0x1c($zero)
			7'h17:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h001c};
				//addi    $t0,     $zero,      0x80   #8
			7'h18:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0080};
				//sw      $t0,     0x20($zero)
			7'h19:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0020};
				//addi    $t0,     $zero,      0x90   #9
			7'h1a:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0090};
				//sw      $t0,     0x24($zero)
			7'h1b:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0024};
				//addi    $t0,     $zero,      0x88   #a
			7'h1c:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0088};
				//sw      $t0,     0x28($zero)
			7'h1d:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0028};
				//addi    $t0,     $zero,      0x83   #b
			7'h1e:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0083};
				//sw      $t0,     0x2c($zero)
			7'h1f:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h002c};
				//addi    $t0,     $zero,      0xc6   #c
			7'h20:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00c6};
				//sw      $t0,     0x30($zero)
			7'h21:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0030};
				//addi    $t0,     $zero,      0xa1   #d
			7'h22:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h00a1};
				//sw      $t0,     0x34($zero)
			7'h23:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0034};
				//addi    $t0,     $zero,      0x86   #e
			7'h24:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0086};
				//sw      $t0,     0x38($zero)
			7'h25:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0038};
				//addi    $t0,     $zero,      0x8e   #f
			7'h26:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h008e};
				//sw      $t0,     0x3c($zero) 
			7'h27:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h003c};
				//sw      $zero,   0x50($zero)     # digital tube base address
			7'h28:    Instruction <= {6'h2b, 5'd00, 5'd00, 16'h0050};
				//addi    $t0,     $zero,      0x0e00 
			7'h29:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0e00};
				//sw      $t0,     0x54($zero)     # 0001
			7'h2a:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0054};
				//addi    $t0,     $zero,      0x0d00
			7'h2b:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0d00};
				//sw      $t0,     0x58($zero)     # 0010
			7'h2c:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0058};
				//addi    $t0,     $zero,      0x0b00
			7'h2d:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0b00};
				//sw      $t0,     0x5c($zero)     # 0100
			7'h2e:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h005c};
				//addi    $t0,     $zero,      0x0700
			7'h2f:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0700};
				//sw      $t0,     0x60($zero)     # 1000
			7'h30:    Instruction <= {6'h2b, 5'd00, 5'd08, 16'h0060};
				//sw      $zero,   0x20($s7)       # UART_CON
			7'h31:    Instruction <= {6'h2b, 5'd23, 5'd00, 16'h0020};
				//lw      $t0,     0x20($s7)
			7'h32:    Instruction <= {6'h23, 5'd23, 5'd08, 16'h0020};
				//andi    $t1,     $t0,         0x08      
			7'h33:    Instruction <= {6'h0c, 5'd08, 5'd09, 16'h0008};
				//beq     $t1,     $zero,       UART1Number   # if CON[3] !=1 return into loop
			7'h34:    Instruction <= {6'h04, 5'd09, 5'd00, 16'hfffd};
				//lw      $s0,     0x1c($s7)                  # read value from RX
			7'h35:    Instruction <= {6'h23, 5'd23, 5'd16, 16'h001c};
				//andi    $t1,     $s0,         0x0f          # low 4 bits
			7'h36:    Instruction <= {6'h0c, 5'd16, 5'd09, 16'h000f};
				//sw      $t1,     0x40($zero)                # save to RAM
			7'h37:    Instruction <= {6'h2b, 5'd00, 5'd09, 16'h0040};
				//srl     $t0,     $s0,         4
			7'h38:    Instruction <= {11'h00, 5'd16, 5'd08, 5'h04, 6'h02};
				//andi    $t1,     $t0,         0x0f          # high 4 bits
			7'h39:    Instruction <= {6'h0c, 5'd08, 5'd09, 16'h000f};
				//sw      $t1,     0x44($zero)                # save to RAM
			7'h3a:    Instruction <= {6'h2b, 5'd00, 5'd09, 16'h0044};
				//lw      $t0,     0x20($s7)
			7'h3b:    Instruction <= {6'h23, 5'd23, 5'd08, 16'h0020};
				//andi    $t1,     $t0,         0x08
			7'h3c:    Instruction <= {6'h0c, 5'd08, 5'd09, 16'h0008};
				//beq     $t1,     $zero,       UART2Number
			7'h3d:    Instruction <= {6'h04, 5'd09, 5'd00, 16'hfffd};
				//lw      $s1,     0x1c($s7)
			7'h3e:    Instruction <= {6'h23, 5'd23, 5'd17, 16'h001c};
				//andi    $t1,     $s1,         0x0f       
			7'h3f:    Instruction <= {6'h0c, 5'd17, 5'd09, 16'h000f};
				//sw      $t1,     0x48($zero)        
			7'h40:    Instruction <= {6'h2b, 5'd00, 5'd09, 16'h0048};
				//srl     $t0,     $s1,         4
			7'h41:    Instruction <= {11'h00, 5'd17, 5'd08, 5'h04, 6'h02};
				//andi    $t1,     $t0,         0x0f 
			7'h42:    Instruction <= {6'h0c, 5'd08, 5'd09, 16'h000f};
				//sw      $t1,     0x4c($zero)
			7'h43:    Instruction <= {6'h2b, 5'd00, 5'd09, 16'h004c};
				//lui     $t0,     0xffff          # 2ms, 0xfff00000 into TH
			7'h44:    Instruction <= {6'h0f, 5'h00, 5'd08, 16'hffff};
				//addi    $t0,     $t0,     0x1111 # low 4 bits
			7'h45:    Instruction <= {6'h08, 5'd08, 5'd08, 16'h1111};
				//sw      $zero,   8($s7)          # TCON = 0
			7'h46:    Instruction <= {6'h2b, 5'd23, 5'd00, 16'h0008};
				//sw      $t0,     0($s7)          # TH
			7'h47:    Instruction <= {6'h2b, 5'd23, 5'd08, 16'h0000};
				//lui     $t0,     0xffff          # put 0xffffffff into TL
			7'h48:    Instruction <= {6'h0f, 5'h00, 5'd08, 16'hffff};
				//addiu   $t0,     $t0,     0xffff # low 4 bits
			7'h49:    Instruction <= {6'h09, 5'd08, 5'd08, 16'hffff};
				//sw      $t0,     4($s7)          # TL
			7'h4a:    Instruction <= {6'h2b, 5'd23, 5'd08, 16'h0004};
				//addi    $t0,     $zero,   3
			7'h4b:    Instruction <= {6'h08, 5'd00, 5'd08, 16'h0003};
				//sw      $t0,     8($s7)          # TCON = 3
			7'h4c:    Instruction <= {6'h2b, 5'd23, 5'd08, 16'h0008};
				//beq     $s1,     $zero,       ZERO
			7'h4d:    Instruction <= {6'h04, 5'd17, 5'd00, 16'h000c};
				//beq     $s0,     $zero,       ZERO
			7'h4e:    Instruction <= {6'h04, 5'd16, 5'd00, 16'h000b};
				//sll     $zero,   $zero,       0 # nop
			7'h4f:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};
				//slt     $s2,     $s0,         $s1
			7'h50:    Instruction <= {6'h00, 5'd16, 5'd17, 5'd18, 11'h2a};
				//sll     $zero,   $zero,       0 # nop
			7'h51:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};
				//beq     $s2,     $zero,       S0_BIGGER
			7'h52:    Instruction <= {6'h04, 5'd18, 5'd00, 16'h0002};
				//sub     $s1,     $s1,         $s0
			7'h53:    Instruction <= {6'h00, 5'd17, 5'd16, 5'd17, 11'h22};
				//j       Calculate
			7'h54:    Instruction <= {6'h02, 26'h000004d};
				//sub     $s0,     $s0,         $s1
			7'h55:    Instruction <= {6'h00, 5'd16, 5'd17, 5'd16, 11'h22};
				//bne     $s0,     $zero,       Calculate   # not zero
			7'h56:    Instruction <= {6'h05, 5'd16, 5'd00, 16'hfff6};
				//sw      $s1,     0x18($s7)                # send UART
			7'h57:    Instruction <= {6'h2b, 5'd23, 5'd17, 16'h0018};
				//sw      $s1,     0x0c($s7)
			7'h58:    Instruction <= {6'h2b, 5'd23, 5'd17, 16'h000c};
				//j       UARTWait
			7'h59:    Instruction <= {6'h02, 26'h0000031};
				//sw      $zero,   0x18($s7)            # send UART
			7'h5a:    Instruction <= {6'h2b, 5'd23, 5'd00, 16'h0018};
				//sw      $zero,   0x0c($s7)
			7'h5b:    Instruction <= {6'h2b, 5'd23, 5'd00, 16'h000c};
				//j       UARTWait  # wait next UART value
			7'h5c:    Instruction <= {6'h02, 26'h0000031};
				//lw      $t4,     0x50($zero)          # read the digital scan choose bit
			7'h5d:    Instruction <= {6'h23, 5'd00, 5'd12, 16'h0050};
				//lw      $t5,     0x40($t4)            # read UART data (low 4 bits) (max is f)
			7'h5e:    Instruction <= {6'h23, 5'd12, 5'd13, 16'h0040};
				//sll     $t5,     $t5,          2      # multiple by 4 (get its position)
			7'h5f:    Instruction <= {11'h00, 5'd13, 5'd13, 5'h02, 6'h00};
				//lw      $t6,     0x00($t5)            # get the number (low 8 bits)
			7'h60:    Instruction <= {6'h23, 5'd13, 5'd14, 16'h0000};
				//sll     $zero,   $zero,        0      # a nop to solve load-use 2 type
			7'h61:    Instruction <= {11'h00, 5'd00, 5'd00, 5'h00, 6'h00};
				//lw      $t3,     0x54($t4)            # get the digital scan choose number (high 4 bits)
			7'h62:    Instruction <= {6'h23, 5'd12, 5'd11, 16'h0054};
				//add     $t2,     $t3, $t6             # add two number to get 12bits (port: digi)
			7'h63:    Instruction <= {6'h00, 5'd11, 5'd14, 5'd10, 11'h20};
				//sw      $t2,     0x14($s7)            # write RAM and display the number
			7'h64:    Instruction <= {6'h2b, 5'd23, 5'd10, 16'h0014};
				//addi    $t3,     $zero,        3
			7'h65:    Instruction <= {6'h08, 5'd00, 5'd11, 16'h0003};
				//sw      $t3,     0x08($s7)            # TCON = 3
			7'h66:    Instruction <= {6'h2b, 5'd23, 5'd11, 16'h0008};
				//addi    $t4,     $t4,          4
			7'h67:    Instruction <= {6'h08, 5'd12, 5'd12, 16'h0004};
				//andi    $t4,     $t4,          0x0c   
			7'h68:    Instruction <= {6'h0c, 5'd12, 5'd12, 16'h000c};
				//sw      $t4,     0x50($zero) 
			7'h69:    Instruction <= {6'h2b, 5'd00, 5'd12, 16'h0050};
				//jr      $k0
			7'h6a:    Instruction <= {6'h00, 5'd26, 21'h08};
				//j       Exception
			7'h6b:    Instruction <= {6'h02, 26'h000006b};
