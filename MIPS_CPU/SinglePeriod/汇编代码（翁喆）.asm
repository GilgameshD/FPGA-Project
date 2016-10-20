
#########    Vectors    #########

j SysInit     #System Initialize
j IRQHandler  #IRQHandler
j Exception   #Exceptions

#########    SysInit    #########

SysInit: #此部分无中断，不会被打断，使用临时变量
#使用了$t0~$t1，存储到$s0和$s1，外设地址$s7

lui  $s7, 0x4000 #外设地址 $s7内保存的是基地址

UARTWait:
sw   $zero, 0x20($s7) #UART_CON

UART1: #接收第一个字节 0x10~0x11
#保存在40（hex） = 64（dec） 64/4 = 16
#保存在44（hex） = 68  68/4 = 17
lw   $t0, 0x20($s7)
andi $t1, $t0, 0x08
beq  $t1, $zero, UART1   # 如果CON[3] ！= 1则继续循环
lw   $s0, 0x1c($s7)      # 读出输入的值
andi $t1, $s0, 0x0f      # 低4位
sw   $t1, 0x40($zero)    # 0x10
srl  $t0, $s0, 4
andi $t1, $t0, 0x0f      # 高4位
sw   $t1, 0x44($zero)    # 0x11

UART2: #接收第二个字节 0x12~0x13
#保存在40（hex） = 72（dec） 72/4 = 18
#保存在44（hex） = 76  76/4 = 19
lw   $t0, 0x20($s7)
andi $t1, $t0, 0x08
beq  $t1, $zero, UART2
lw   $s1, 0x1c($s7)
andi $t1, $s1, 0x0f #低4位
sw   $t1, 0x48($zero) #0x12
srl  $t0, $s1, 4
andi $t1, $t0, 0x0f #高4位
sw   $t1, 0x4c($zero) #0x13

#数码管0x00~0x0f
addi $t0, $zero, 0xc0 #0
sw   $t0, 0x00($zero)
addi $t0, $zero, 0xf9 #1
sw   $t0, 0x04($zero)
addi $t0, $zero, 0xa4 #2
sw   $t0, 0x08($zero)
addi $t0, $zero, 0xb0 #3
sw   $t0, 0x0c($zero)
addi $t0, $zero, 0x99 #4
sw   $t0, 0x10($zero)
addi $t0, $zero, 0x92 #5
sw   $t0, 0x14($zero)
addi $t0, $zero, 0x82 #6
sw   $t0, 0x18($zero)
addi $t0, $zero, 0xf8 #7
sw   $t0, 0x1c($zero)
addi $t0, $zero, 0x80 #8
sw   $t0, 0x20($zero)
addi $t0, $zero, 0x90 #9
sw   $t0, 0x24($zero)
addi $t0, $zero, 0x88 #a
sw   $t0, 0x28($zero)
addi $t0, $zero, 0x83 #b
sw   $t0, 0x2c($zero)
addi $t0, $zero, 0xc6 #c
sw   $t0, 0x30($zero)
addi $t0, $zero, 0xa1 #d
sw   $t0, 0x34($zero)
addi $t0, $zero, 0x86 #e
sw   $t0, 0x38($zero)
addi $t0, $zero, 0x8e #f
sw   $t0, 0x3c($zero)

sw   $zero, 0x50($zero)

# 数码管片选信号
addi $t0, $zero, 0x0e00 # 1
sw   $t0, 0x54($zero)
addi $t0, $zero, 0x0d00 # 2
sw   $t0, 0x58($zero)
addi $t0, $zero, 0x0b00 # 4 
sw   $t0, 0x5c($zero) 
addi $t0, $zero, 0x0700 # 8
sw   $t0, 0x60($zero)

####################################################################
jal Kernel2User
#TimerInit
lui  $t0, 0xfffe    # -100000, 2ms, FFFE7960（分两次装载） 50Hz扫描频率
addi $t0, $t0, 0x7960
sw   $zero, 8($s7)  # TCON = 0
sw   $t0,   0($s7)  # TH
######################33
lui   $t0, 0xffff  
addiu $t0, $t0, 0xffff
#############################
sw   $t0,   4($s7)  # TL
addi $t0,   $zero, 3
sw   $t0,   8($s7)   #TCON = 3
j   User
######################################################################

#########   IRQHandler  #########

IRQHandler:
#中断处理，使用了$t4~$t6（12,13,14），同样不会被打断
##################################################
lw   $t4, 0x50($zero) # 记录片选位
lw   $t5, 0x40($t4)   # 读取串口获得的数据的一半
sll  $t5, $t5, 2      # 乘 4（内存是4的倍数）
lw   $t6, 0x00($t5)   # 显示值（显示数字）
lw   $t5, 0x54($t4)   # 对应高位（片选数字）
add  $t6, $t5, $t6    # 相加获得对应值

# 写入数码管的值
sw   $t6, 0x14($s7)

addi $t6, $zero, 3
sw   $t6, 0x08($s7)   # TCON = 3

addi $t4, $t4, 4
#############################
# 与上0c高两位的值不变
andi $t4, $t4, 0x0c   # 超过4就清零（0x0c = 12）
sw   $t4, 0x50($zero) # 每一次写入之后下一次换一个数码管
jr   $k0

#########   Exception   #########

Exception:
j Exception

#########  Kernel2User  #########

# 将最高位置0，进入用户态 (返回原地址)
Kernel2User:
andi $ra, $ra, 0xffff 
jr $ra

#########     User      #########
# 求最大公约数的部分

User: #使用$s0~$s6
beq $s1, $zero, ZERO
beq $s0, $zero, ZERO
slt $s2, $s0, $s1
beq $s2, $zero, s0>=s1

s0<s1:
sub $s1, $s1, $s0
j User

s0>=s1:
sub $s0, $s0, $s1
bne $s0, $zero, User #不为0

# 串口和LED的显示写内存
sw $s1, 0x18($s7) 
sw $s1, 0x0c($s7)

# 循环等待下一次的串口值
j UARTWait

# 结果为0，直接写内存用串口和LED显示
ZERO:
sw $zero, 0x18($s7)
sw $zero, 0x0c($s7)
j UARTWait