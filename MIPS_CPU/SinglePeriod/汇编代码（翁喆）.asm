
#########    Vectors    #########

j SysInit     #System Initialize
j IRQHandler  #IRQHandler
j Exception   #Exceptions

#########    SysInit    #########

SysInit: #�˲������жϣ����ᱻ��ϣ�ʹ����ʱ����
#ʹ����$t0~$t1���洢��$s0��$s1�������ַ$s7

lui  $s7, 0x4000 #�����ַ $s7�ڱ�����ǻ���ַ

UARTWait:
sw   $zero, 0x20($s7) #UART_CON

UART1: #���յ�һ���ֽ� 0x10~0x11
#������40��hex�� = 64��dec�� 64/4 = 16
#������44��hex�� = 68  68/4 = 17
lw   $t0, 0x20($s7)
andi $t1, $t0, 0x08
beq  $t1, $zero, UART1   # ���CON[3] ��= 1�����ѭ��
lw   $s0, 0x1c($s7)      # ���������ֵ
andi $t1, $s0, 0x0f      # ��4λ
sw   $t1, 0x40($zero)    # 0x10
srl  $t0, $s0, 4
andi $t1, $t0, 0x0f      # ��4λ
sw   $t1, 0x44($zero)    # 0x11

UART2: #���յڶ����ֽ� 0x12~0x13
#������40��hex�� = 72��dec�� 72/4 = 18
#������44��hex�� = 76  76/4 = 19
lw   $t0, 0x20($s7)
andi $t1, $t0, 0x08
beq  $t1, $zero, UART2
lw   $s1, 0x1c($s7)
andi $t1, $s1, 0x0f #��4λ
sw   $t1, 0x48($zero) #0x12
srl  $t0, $s1, 4
andi $t1, $t0, 0x0f #��4λ
sw   $t1, 0x4c($zero) #0x13

#�����0x00~0x0f
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

# �����Ƭѡ�ź�
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
lui  $t0, 0xfffe    # -100000, 2ms, FFFE7960��������װ�أ� 50Hzɨ��Ƶ��
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
#�жϴ���ʹ����$t4~$t6��12,13,14����ͬ�����ᱻ���
##################################################
lw   $t4, 0x50($zero) # ��¼Ƭѡλ
lw   $t5, 0x40($t4)   # ��ȡ���ڻ�õ����ݵ�һ��
sll  $t5, $t5, 2      # �� 4���ڴ���4�ı�����
lw   $t6, 0x00($t5)   # ��ʾֵ����ʾ���֣�
lw   $t5, 0x54($t4)   # ��Ӧ��λ��Ƭѡ���֣�
add  $t6, $t5, $t6    # ��ӻ�ö�Ӧֵ

# д������ܵ�ֵ
sw   $t6, 0x14($s7)

addi $t6, $zero, 3
sw   $t6, 0x08($s7)   # TCON = 3

addi $t4, $t4, 4
#############################
# ����0c����λ��ֵ����
andi $t4, $t4, 0x0c   # ����4�����㣨0x0c = 12��
sw   $t4, 0x50($zero) # ÿһ��д��֮����һ�λ�һ�������
jr   $k0

#########   Exception   #########

Exception:
j Exception

#########  Kernel2User  #########

# �����λ��0�������û�̬ (����ԭ��ַ)
Kernel2User:
andi $ra, $ra, 0xffff 
jr $ra

#########     User      #########
# �����Լ���Ĳ���

User: #ʹ��$s0~$s6
beq $s1, $zero, ZERO
beq $s0, $zero, ZERO
slt $s2, $s0, $s1
beq $s2, $zero, s0>=s1

s0<s1:
sub $s1, $s1, $s0
j User

s0>=s1:
sub $s0, $s0, $s1
bne $s0, $zero, User #��Ϊ0

# ���ں�LED����ʾд�ڴ�
sw $s1, 0x18($s7) 
sw $s1, 0x0c($s7)

# ѭ���ȴ���һ�εĴ���ֵ
j UARTWait

# ���Ϊ0��ֱ��д�ڴ��ô��ں�LED��ʾ
ZERO:
sw $zero, 0x18($s7)
sw $zero, 0x0c($s7)
j UARTWait