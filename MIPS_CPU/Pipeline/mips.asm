# when we reset, we are in kernel state, so we use jal and jr to change to user state
j       Main          # main funcyion
j       Interruption  # interrupt entrance
j       Exception     # exception entrance

# main function entrance
Main:
jal     KernelToUser
j       User

# set the PC value highest bit zero to go to user state
# $ra store the value of PC+4
KernelToUser:
andi    $ra,     $ra,     0xffff 
jr      $ra

# user process 
# includes some initial work and uart operate
User:
lui     $s7,     0x4000          # use $s7 to save peripheral base address

# display initialization
# digital tube vaue 0x00 ~ 0x0f
addi    $t0,     $zero,      0xc0   #0
sw      $t0,     0x00($zero)
addi    $t0,     $zero,      0xf9   #1
sw      $t0,     0x04($zero)
addi    $t0,     $zero,      0xa4   #2
sw      $t0,     0x08($zero)
addi    $t0,     $zero,      0xb0   #3
sw      $t0,     0x0c($zero)
addi    $t0,     $zero,      0x99   #4
sw      $t0,     0x10($zero)
addi    $t0,     $zero,      0x92   #5
sw      $t0,     0x14($zero)
addi    $t0,     $zero,      0x82   #6
sw      $t0,     0x18($zero)
addi    $t0,     $zero,      0xf8   #7
sw      $t0,     0x1c($zero)
addi    $t0,     $zero,      0x80   #8
sw      $t0,     0x20($zero)
addi    $t0,     $zero,      0x90   #9
sw      $t0,     0x24($zero)
addi    $t0,     $zero,      0x88   #a
sw      $t0,     0x28($zero)
addi    $t0,     $zero,      0x83   #b
sw      $t0,     0x2c($zero)
addi    $t0,     $zero,      0xc6   #c
sw      $t0,     0x30($zero)
addi    $t0,     $zero,      0xa1   #d
sw      $t0,     0x34($zero)
addi    $t0,     $zero,      0x86   #e
sw      $t0,     0x38($zero)
addi    $t0,     $zero,      0x8e   #f
sw      $t0,     0x3c($zero) 

# digital tube choose signal (0 means light)
sw      $zero,   0x50($zero)     # digital tube base address
addi    $t0,     $zero,      0x0e00 
sw      $t0,     0x54($zero)     # 0001
addi    $t0,     $zero,      0x0d00
sw      $t0,     0x58($zero)     # 0010
addi    $t0,     $zero,      0x0b00
sw      $t0,     0x5c($zero)     # 0100
addi    $t0,     $zero,      0x0700
sw      $t0,     0x60($zero)     # 1000

# UART operation
UARTWait:
sw      $zero,   0x20($s7)       # UART_CON

# read first byte
UART1Number:
# save in 40£¨hex£© = 64(dec) 64/4 = 16
# save in 44£¨hex£© = 68(dec) 68/4 = 17
lw      $t0,     0x20($s7)
andi    $t1,     $t0,         0x08      
beq     $t1,     $zero,       UART1Number   # if CON[3] !=1 return into loop
lw      $s0,     0x1c($s7)                  # read value from RX
andi    $t1,     $s0,         0x0f          # low 4 bits
sw      $t1,     0x40($zero)                # save to RAM
srl     $t0,     $s0,         4
andi    $t1,     $t0,         0x0f          # high 4 bits
sw      $t1,     0x44($zero)                # save to RAM

# read second byte
UART2Number: 
# save in 48£¨hex£© = 72(dec) 64/4 = 18
# save in 4c£¨hex£© = 76(dec) 68/4 = 19
lw      $t0,     0x20($s7)
andi    $t1,     $t0,         0x08
beq     $t1,     $zero,       UART2Number
lw      $s1,     0x1c($s7)
andi    $t1,     $s1,         0x0f       
sw      $t1,     0x48($zero)        
srl     $t0,     $s1,         4
andi    $t1,     $t0,         0x0f 
sw      $t1,     0x4c($zero)

# timer initialization
lui     $t0,     0xffff          # 2ms, 0xfff00000 into TH
addi    $t0,     $t0,     0x1111 # low 4 bits
sw      $zero,   8($s7)          # TCON = 0
sw      $t0,     0($s7)          # TH
lui     $t0,     0xffff          # put 0xffffffff into TL
addiu   $t0,     $t0,     0xffff # low 4 bits
sw      $t0,     4($s7)          # TL
addi    $t0,     $zero,   3
sw      $t0,     8($s7)          # TCON = 3

# get the result of greatest common divisor
Calculate: 
beq     $s1,     $zero,       ZERO
beq     $s0,     $zero,       ZERO
sll     $zero,   $zero,       0 # nop
slt     $s2,     $s0,         $s1
sll     $zero,   $zero,       0 # nop
beq     $s2,     $zero,       S0_BIGGER
# $s0 < s1
sub     $s1,     $s1,         $s0
j       Calculate

# $s0 >= $s1
S0_BIGGER:
sub     $s0,     $s0,         $s1
bne     $s0,     $zero,       Calculate   # not zero

# UART and LED write RAM to dispaly and send
sw      $s1,     0x18($s7)                # send UART
sw      $s1,     0x0c($s7)

# wait next UART value
j       UARTWait

#
##########################   independent functions below   ########################
#

# input number(s) is zero, directly display zero
ZERO:
sw      $zero,   0x18($s7)            # send UART
sw      $zero,   0x0c($s7)
j       UARTWait  # wait next UART value

# interruption handler function
Interruption:
lw      $t4,     0x50($zero)          # read the digital scan choose bit
lw      $t5,     0x40($t4)            # read UART data (low 4 bits) (max is f)
sll     $t5,     $t5,          2      # multiple by 4 (get its position)
lw      $t6,     0x00($t5)            # get the number (low 8 bits)
sll     $zero,   $zero,        0      # a nop to solve load-use 2 type
lw      $t3,     0x54($t4)            # get the digital scan choose number (high 4 bits)
add     $t2,     $t3, $t6             # add two number to get 12bits (port: digi)

sw      $t2,     0x14($s7)            # write RAM and display the number
addi    $t3,     $zero,        3
sw      $t3,     0x08($s7)            # TCON = 3

# after write we should add 4 to change a digital tube
# and 0c(00001100) to change the number which is bigger than 8 to zero
addi    $t4,     $t4,          4
andi    $t4,     $t4,          0x0c   
sw      $t4,     0x50($zero) 
jr      $k0

Exception:
j       Exception