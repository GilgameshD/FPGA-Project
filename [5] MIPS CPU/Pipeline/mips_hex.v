				//j       Main          # main funcyion
			8'h00:    Instruction <= 32'h08000003;
				//j       Interruption  # interrupt entrance
			8'h01:    Instruction <= 32'h0800005d;
				//j       Exception     # exception entrance
			8'h02:    Instruction <= 32'h0800006b;
				//jal     KernelToUser
			8'h03:    Instruction <= 32'h0c000005;
				//j       User
			8'h04:    Instruction <= 32'h08000007;
				//andi    $ra,     $ra,     0xffff 
			8'h05:    Instruction <= 32'h33ffffff;
				//jr      $ra
			8'h06:    Instruction <= 32'h03e00008;
				//lui     $s7,     0x4000          # use $s7 to save peripheral base address
			8'h07:    Instruction <= 32'h3c174000;
				//addi    $t0,     $zero,      0xc0   #0
			8'h08:    Instruction <= 32'h200800c0;
				//sw      $t0,     0x00($zero)
			8'h09:    Instruction <= 32'hac080000;
				//addi    $t0,     $zero,      0xf9   #1
			8'h0a:    Instruction <= 32'h200800f9;
				//sw      $t0,     0x04($zero)
			8'h0b:    Instruction <= 32'hac080004;
				//addi    $t0,     $zero,      0xa4   #2
			8'h0c:    Instruction <= 32'h200800a4;
				//sw      $t0,     0x08($zero)
			8'h0d:    Instruction <= 32'hac080008;
				//addi    $t0,     $zero,      0xb0   #3
			8'h0e:    Instruction <= 32'h200800b0;
				//sw      $t0,     0x0c($zero)
			8'h0f:    Instruction <= 32'hac08000c;
				//addi    $t0,     $zero,      0x99   #4
			8'h10:    Instruction <= 32'h20080099;
				//sw      $t0,     0x10($zero)
			8'h11:    Instruction <= 32'hac080010;
				//addi    $t0,     $zero,      0x92   #5
			8'h12:    Instruction <= 32'h20080092;
				//sw      $t0,     0x14($zero)
			8'h13:    Instruction <= 32'hac080014;
				//addi    $t0,     $zero,      0x82   #6
			8'h14:    Instruction <= 32'h20080082;
				//sw      $t0,     0x18($zero)
			8'h15:    Instruction <= 32'hac080018;
				//addi    $t0,     $zero,      0xf8   #7
			8'h16:    Instruction <= 32'h200800f8;
				//sw      $t0,     0x1c($zero)
			8'h17:    Instruction <= 32'hac08001c;
				//addi    $t0,     $zero,      0x80   #8
			8'h18:    Instruction <= 32'h20080080;
				//sw      $t0,     0x20($zero)
			8'h19:    Instruction <= 32'hac080020;
				//addi    $t0,     $zero,      0x90   #9
			8'h1a:    Instruction <= 32'h20080090;
				//sw      $t0,     0x24($zero)
			8'h1b:    Instruction <= 32'hac080024;
				//addi    $t0,     $zero,      0x88   #a
			8'h1c:    Instruction <= 32'h20080088;
				//sw      $t0,     0x28($zero)
			8'h1d:    Instruction <= 32'hac080028;
				//addi    $t0,     $zero,      0x83   #b
			8'h1e:    Instruction <= 32'h20080083;
				//sw      $t0,     0x2c($zero)
			8'h1f:    Instruction <= 32'hac08002c;
				//addi    $t0,     $zero,      0xc6   #c
			8'h20:    Instruction <= 32'h200800c6;
				//sw      $t0,     0x30($zero)
			8'h21:    Instruction <= 32'hac080030;
				//addi    $t0,     $zero,      0xa1   #d
			8'h22:    Instruction <= 32'h200800a1;
				//sw      $t0,     0x34($zero)
			8'h23:    Instruction <= 32'hac080034;
				//addi    $t0,     $zero,      0x86   #e
			8'h24:    Instruction <= 32'h20080086;
				//sw      $t0,     0x38($zero)
			8'h25:    Instruction <= 32'hac080038;
				//addi    $t0,     $zero,      0x8e   #f
			8'h26:    Instruction <= 32'h2008008e;
				//sw      $t0,     0x3c($zero) 
			8'h27:    Instruction <= 32'hac08003c;
				//sw      $zero,   0x50($zero)     # digital tube base address
			8'h28:    Instruction <= 32'hac000050;
				//addi    $t0,     $zero,      0x0e00 
			8'h29:    Instruction <= 32'h20080e00;
				//sw      $t0,     0x54($zero)     # 0001
			8'h2a:    Instruction <= 32'hac080054;
				//addi    $t0,     $zero,      0x0d00
			8'h2b:    Instruction <= 32'h20080d00;
				//sw      $t0,     0x58($zero)     # 0010
			8'h2c:    Instruction <= 32'hac080058;
				//addi    $t0,     $zero,      0x0b00
			8'h2d:    Instruction <= 32'h20080b00;
				//sw      $t0,     0x5c($zero)     # 0100
			8'h2e:    Instruction <= 32'hac08005c;
				//addi    $t0,     $zero,      0x0700
			8'h2f:    Instruction <= 32'h20080700;
				//sw      $t0,     0x60($zero)     # 1000
			8'h30:    Instruction <= 32'hac080060;
				//sw      $zero,   0x20($s7)       # UART_CON
			8'h31:    Instruction <= 32'haee00020;
				//lw      $t0,     0x20($s7)
			8'h32:    Instruction <= 32'h8ee80020;
				//andi    $t1,     $t0,         0x08      
			8'h33:    Instruction <= 32'h31090008;
				//beq     $t1,     $zero,       UART1Number   # if CON[3] !=1 return into loop
			8'h34:    Instruction <= 32'h1120fffd;
				//lw      $s0,     0x1c($s7)                  # read value from RX
			8'h35:    Instruction <= 32'h8ef0001c;
				//andi    $t1,     $s0,         0x0f          # low 4 bits
			8'h36:    Instruction <= 32'h3209000f;
				//sw      $t1,     0x40($zero)                # save to RAM
			8'h37:    Instruction <= 32'hac090040;
				//srl     $t0,     $s0,         4
			8'h38:    Instruction <= 32'h00104102;
				//andi    $t1,     $t0,         0x0f          # high 4 bits
			8'h39:    Instruction <= 32'h3109000f;
				//sw      $t1,     0x44($zero)                # save to RAM
			8'h3a:    Instruction <= 32'hac090044;
				//lw      $t0,     0x20($s7)
			8'h3b:    Instruction <= 32'h8ee80020;
				//andi    $t1,     $t0,         0x08
			8'h3c:    Instruction <= 32'h31090008;
				//beq     $t1,     $zero,       UART2Number
			8'h3d:    Instruction <= 32'h1120fffd;
				//lw      $s1,     0x1c($s7)
			8'h3e:    Instruction <= 32'h8ef1001c;
				//andi    $t1,     $s1,         0x0f       
			8'h3f:    Instruction <= 32'h3229000f;
				//sw      $t1,     0x48($zero)        
			8'h40:    Instruction <= 32'hac090048;
				//srl     $t0,     $s1,         4
			8'h41:    Instruction <= 32'h00114102;
				//andi    $t1,     $t0,         0x0f 
			8'h42:    Instruction <= 32'h3109000f;
				//sw      $t1,     0x4c($zero)
			8'h43:    Instruction <= 32'hac09004c;
				//lui     $t0,     0xffff          # 2ms, 0xfff00000 into TH
			8'h44:    Instruction <= 32'h3c08ffff;
				//addi    $t0,     $t0,     0x1111 # low 4 bits
			8'h45:    Instruction <= 32'h21081111;
				//sw      $zero,   8($s7)          # TCON = 0
			8'h46:    Instruction <= 32'haee00008;
				//sw      $t0,     0($s7)          # TH
			8'h47:    Instruction <= 32'haee80000;
				//lui     $t0,     0xffff          # put 0xffffffff into TL
			8'h48:    Instruction <= 32'h3c08ffff;
				//addiu   $t0,     $t0,     0xffff # low 4 bits
			8'h49:    Instruction <= 32'h2508ffff;
				//sw      $t0,     4($s7)          # TL
			8'h4a:    Instruction <= 32'haee80004;
				//addi    $t0,     $zero,   3
			8'h4b:    Instruction <= 32'h20080003;
				//sw      $t0,     8($s7)          # TCON = 3
			8'h4c:    Instruction <= 32'haee80008;
				//beq     $s1,     $zero,       ZERO
			8'h4d:    Instruction <= 32'h1220000c;
				//beq     $s0,     $zero,       ZERO
			8'h4e:    Instruction <= 32'h1200000b;
				//sll     $zero,   $zero,       0 # nop
			8'h4f:    Instruction <= 32'h00000000;
				//slt     $s2,     $s0,         $s1
			8'h50:    Instruction <= 32'h0211902a;
				//sll     $zero,   $zero,       0 # nop
			8'h51:    Instruction <= 32'h00000000;
				//beq     $s2,     $zero,       S0_BIGGER
			8'h52:    Instruction <= 32'h12400002;
				//sub     $s1,     $s1,         $s0
			8'h53:    Instruction <= 32'h02308822;
				//j       Calculate
			8'h54:    Instruction <= 32'h0800004d;
				//sub     $s0,     $s0,         $s1
			8'h55:    Instruction <= 32'h02118022;
				//bne     $s0,     $zero,       Calculate   # not zero
			8'h56:    Instruction <= 32'h1600fff6;
				//sw      $s1,     0x18($s7)                # send UART
			8'h57:    Instruction <= 32'haef10018;
				//sw      $s1,     0x0c($s7)
			8'h58:    Instruction <= 32'haef1000c;
				//j       UARTWait
			8'h59:    Instruction <= 32'h08000031;
				//sw      $zero,   0x18($s7)            # send UART
			8'h5a:    Instruction <= 32'haee00018;
				//sw      $zero,   0x0c($s7)
			8'h5b:    Instruction <= 32'haee0000c;
				//j       UARTWait  # wait next UART value
			8'h5c:    Instruction <= 32'h08000031;
				//lw      $t4,     0x50($zero)          # read the digital scan choose bit
			8'h5d:    Instruction <= 32'h8c0c0050;
				//lw      $t5,     0x40($t4)            # read UART data (low 4 bits) (max is f)
			8'h5e:    Instruction <= 32'h8d8d0040;
				//sll     $t5,     $t5,          2      # multiple by 4 (get its position)
			8'h5f:    Instruction <= 32'h000d6880;
				//lw      $t6,     0x00($t5)            # get the number (low 8 bits)
			8'h60:    Instruction <= 32'h8dae0000;
				//sll     $zero,   $zero,        0      # a nop to solve load-use 2 type
			8'h61:    Instruction <= 32'h00000000;
				//lw      $t3,     0x54($t4)            # get the digital scan choose number (high 4 bits)
			8'h62:    Instruction <= 32'h8d8b0054;
				//add     $t2,     $t3, $t6             # add two number to get 12bits (port: digi)
			8'h63:    Instruction <= 32'h016e5020;
				//sw      $t2,     0x14($s7)            # write RAM and display the number
			8'h64:    Instruction <= 32'haeea0014;
				//addi    $t3,     $zero,        3
			8'h65:    Instruction <= 32'h200b0003;
				//sw      $t3,     0x08($s7)            # TCON = 3
			8'h66:    Instruction <= 32'haeeb0008;
				//addi    $t4,     $t4,          4
			8'h67:    Instruction <= 32'h218c0004;
				//andi    $t4,     $t4,          0x0c   
			8'h68:    Instruction <= 32'h318c000c;
				//sw      $t4,     0x50($zero) 
			8'h69:    Instruction <= 32'hac0c0050;
				//jr      $k0
			8'h6a:    Instruction <= 32'h03400008;
				//j       Exception
			8'h6b:    Instruction <= 32'h0800006b;
