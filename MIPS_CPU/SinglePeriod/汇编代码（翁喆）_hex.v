				//j SysInit     #System Initialize
			8'h00:    Instruction <= 32'h08000003;
				//j IRQHandler  #IRQHandler
			8'h01:    Instruction <= 32'h0800004b;
				//j Exception   #Exceptions
			8'h02:    Instruction <= 32'h08000058;
				//lui  $s7, 0x4000 #外设地址 $s7内保存的是基地址
			8'h03:    Instruction <= 32'h3c174000;
				//sw   $zero, 0x20($s7) #UART_CON
			8'h04:    Instruction <= 32'haee00020;
				//lw   $t0, 0x20($s7)
			8'h05:    Instruction <= 32'h8ee80020;
				//andi $t1, $t0, 0x08
			8'h06:    Instruction <= 32'h31090008;
				//beq  $t1, $zero, UART1   # 如果CON[3] ！= 1则继续循环
			8'h07:    Instruction <= 32'h1120fffd;
				//lw   $s0, 0x1c($s7)      # 储存输入的值
			8'h08:    Instruction <= 32'h8ef0001c;
				//andi $t1, $s0, 0x0f      # 低4位
			8'h09:    Instruction <= 32'h3209000f;
				//sw   $t1, 0x40($zero)    # 0x10
			8'h0a:    Instruction <= 32'hac090040;
				//srl  $t0, $s0, 4
			8'h0b:    Instruction <= 32'h00104102;
				//andi $t1, $t0, 0x0f      # 高4位
			8'h0c:    Instruction <= 32'h3109000f;
				//sw   $t1, 0x44($zero)    # 0x11
			8'h0d:    Instruction <= 32'hac090044;
				//lw   $t0, 0x20($s7)
			8'h0e:    Instruction <= 32'h8ee80020;
				//andi $t1, $t0, 0x08
			8'h0f:    Instruction <= 32'h31090008;
				//beq  $t1, $zero, UART2
			8'h10:    Instruction <= 32'h1120fffd;
				//lw   $s1, 0x1c($s7)
			8'h11:    Instruction <= 32'h8ef1001c;
				//andi $t1, $s1, 0x0f #低4位
			8'h12:    Instruction <= 32'h3229000f;
				//sw   $t1, 0x48($zero) #0x12
			8'h13:    Instruction <= 32'hac090048;
				//srl  $t0, $s1, 4
			8'h14:    Instruction <= 32'h00114102;
				//andi $t1, $t0, 0x0f #高4位
			8'h15:    Instruction <= 32'h3109000f;
				//sw   $t1, 0x4c($zero) #0x13
			8'h16:    Instruction <= 32'hac09004c;
				//addi $t0, $zero, 0x40 #0
			8'h17:    Instruction <= 32'h20080040;
				//sw   $t0, 0x00($zero)
			8'h18:    Instruction <= 32'hac080000;
				//addi $t0, $zero, 0x79 #1
			8'h19:    Instruction <= 32'h20080079;
				//sw   $t0, 0x04($zero)
			8'h1a:    Instruction <= 32'hac080004;
				//addi $t0, $zero, 0x24 #2
			8'h1b:    Instruction <= 32'h20080024;
				//sw   $t0, 0x08($zero)
			8'h1c:    Instruction <= 32'hac080008;
				//addi $t0, $zero, 0x30 #3
			8'h1d:    Instruction <= 32'h20080030;
				//sw   $t0, 0x0c($zero)
			8'h1e:    Instruction <= 32'hac08000c;
				//addi $t0, $zero, 0x19 #4
			8'h1f:    Instruction <= 32'h20080019;
				//sw   $t0, 0x10($zero)
			8'h20:    Instruction <= 32'hac080010;
				//addi $t0, $zero, 0x12 #5
			8'h21:    Instruction <= 32'h20080012;
				//sw   $t0, 0x14($zero)
			8'h22:    Instruction <= 32'hac080014;
				//addi $t0, $zero, 0x02 #6
			8'h23:    Instruction <= 32'h20080002;
				//sw   $t0, 0x18($zero)
			8'h24:    Instruction <= 32'hac080018;
				//addi $t0, $zero, 0x78 #7
			8'h25:    Instruction <= 32'h20080078;
				//sw   $t0, 0x1c($zero)
			8'h26:    Instruction <= 32'hac08001c;
				//addi $t0, $zero, 0x00 #8
			8'h27:    Instruction <= 32'h20080000;
				//sw   $t0, 0x20($zero)
			8'h28:    Instruction <= 32'hac080020;
				//addi $t0, $zero, 0x10 #9
			8'h29:    Instruction <= 32'h20080010;
				//sw   $t0, 0x24($zero)
			8'h2a:    Instruction <= 32'hac080024;
				//addi $t0, $zero, 0x08 #a
			8'h2b:    Instruction <= 32'h20080008;
				//sw   $t0, 0x28($zero)
			8'h2c:    Instruction <= 32'hac080028;
				//addi $t0, $zero, 0x03 #b
			8'h2d:    Instruction <= 32'h20080003;
				//sw   $t0, 0x2c($zero)
			8'h2e:    Instruction <= 32'hac08002c;
				//addi $t0, $zero, 0x46 #c
			8'h2f:    Instruction <= 32'h20080046;
				//sw   $t0, 0x30($zero)
			8'h30:    Instruction <= 32'hac080030;
				//addi $t0, $zero, 0x21 #d
			8'h31:    Instruction <= 32'h20080021;
				//sw   $t0, 0x34($zero)
			8'h32:    Instruction <= 32'hac080034;
				//addi $t0, $zero, 0x06 #e
			8'h33:    Instruction <= 32'h20080006;
				//sw   $t0, 0x38($zero)
			8'h34:    Instruction <= 32'hac080038;
				//addi $t0, $zero, 0x0e #f
			8'h35:    Instruction <= 32'h2008000e;
				//sw   $t0, 0x3c($zero)
			8'h36:    Instruction <= 32'hac08003c;
				//sw   $zero, 0x50($zero)
			8'h37:    Instruction <= 32'hac000050;
				//addi $t0, $zero, 0x0100
			8'h38:    Instruction <= 32'h20080100;
				//sw   $t0, 0x54($zero)
			8'h39:    Instruction <= 32'hac080054;
				//addi $t0, $zero, 0x0200
			8'h3a:    Instruction <= 32'h20080200;
				//sw   $t0, 0x58($zero)
			8'h3b:    Instruction <= 32'hac080058;
				//addi $t0, $zero, 0x0400
			8'h3c:    Instruction <= 32'h20080400;
				//sw   $t0, 0x5c($zero)
			8'h3d:    Instruction <= 32'hac08005c;
				//addi $t0, $zero, 0x0800
			8'h3e:    Instruction <= 32'h20080800;
				//sw   $t0, 0x60($zero)
			8'h3f:    Instruction <= 32'hac080060;
				//lui  $t0, 0xfffe    # -100000, 2ms, FFFE7960（分两次装载） 50Hz扫描频率
			8'h40:    Instruction <= 32'h3c08fffe;
				//addi $t0, $t0, 0x7960
			8'h41:    Instruction <= 32'h21087960;
				//sw   $zero, 8($s7)  # TCON = 0
			8'h42:    Instruction <= 32'haee00008;
				//sw   $t0,   0($s7)  # TH
			8'h43:    Instruction <= 32'haee80000;
				//lui  $t0,  0xffff
			8'h44:    Instruction <= 32'h3c08ffff;
				//addi $t0,  $t0, 0xffff 
			8'h45:    Instruction <= 32'h2108ffff;
				//sw   $t0, 4($s7)    # TL
			8'h46:    Instruction <= 32'haee80004;
				//addi $t0, $zero, 3
			8'h47:    Instruction <= 32'h20080003;
				//sw   $t0, 8($s7)   #TCON = 3
			8'h48:    Instruction <= 32'haee80008;
				//jal Kernel2User
			8'h49:    Instruction <= 32'h0c000059;
				//j   User
			8'h4a:    Instruction <= 32'h0800005b;
				//lw   $t4, 0x50($zero) #$t4是显示第几位
			8'h4b:    Instruction <= 32'h8c0c0050;
				//lw   $t5, 0x40($t4)
			8'h4c:    Instruction <= 32'h8d8d0040;
				//sll  $t5, $t5, 2
			8'h4d:    Instruction <= 32'h000d6880;
				//lw   $t6, 0x00($t5)   #显示值
			8'h4e:    Instruction <= 32'h8dae0000;
				//lw   $t5, 0x54($t4)   #对应高位
			8'h4f:    Instruction <= 32'h8d8d0054;
				//add  $t6, $t5, $t6    #对应值
			8'h50:    Instruction <= 32'h01ae7020;
				//sw   $t6, 0x14($s7)
			8'h51:    Instruction <= 32'haeee0014;
				//addi $t6, $zero, 3
			8'h52:    Instruction <= 32'h200e0003;
				//sw   $t6, 0x08($s7) #TCON = 3
			8'h53:    Instruction <= 32'haeee0008;
				//addi $t4, $t4, 4
			8'h54:    Instruction <= 32'h218c0004;
				//andi $t4, $t4, 0x0c
			8'h55:    Instruction <= 32'h318c000c;
				//sw   $t4, 0x50($zero)
			8'h56:    Instruction <= 32'hac0c0050;
				//jr   $k0
			8'h57:    Instruction <= 32'h03400008;
				//j Exception
			8'h58:    Instruction <= 32'h08000058;
				//andi $ra, $ra, 0xffff 
			8'h59:    Instruction <= 32'h33ffffff;
				//jr $ra
			8'h5a:    Instruction <= 32'h03e00008;
				//beq $s1, $zero, ZERO
			8'h5b:    Instruction <= 32'h1220000a;
				//beq $s0, $zero, ZERO
			8'h5c:    Instruction <= 32'h12000009;
				//slt $s2, $s0, $s1
			8'h5d:    Instruction <= 32'h0211902a;
				//beq $s2, $zero, s0>=s1
			8'h5e:    Instruction <= 32'h12400002;
				//sub $s1, $s1, $s0
			8'h5f:    Instruction <= 32'h02308822;
				//j User
			8'h60:    Instruction <= 32'h0800005b;
				//sub $s0, $s0, $s1
			8'h61:    Instruction <= 32'h02118022;
				//bne $s0, $zero, User #不为0
			8'h62:    Instruction <= 32'h1600fff8;
				//sw $s1, 0x18($s7) 
			8'h63:    Instruction <= 32'haef10018;
				//sw $s1, 0x0c($s7)
			8'h64:    Instruction <= 32'haef1000c;
				//j UARTWait
			8'h65:    Instruction <= 32'h08000004;
				//sw $zero, 0x14($s7)
			8'h66:    Instruction <= 32'haee00014;
				//sw $zero, 0x0c($s7)
			8'h67:    Instruction <= 32'haee0000c;
				//j UARTWait
			8'h68:    Instruction <= 32'h08000004;
