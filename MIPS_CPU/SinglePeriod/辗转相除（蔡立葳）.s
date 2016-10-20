j main                      # Normal boot: jump to main entry
j interrupt                 # Interrupt: jump to handling
dead:beq $0,$0,dead         # Exception: dead

main:
lui $s0,0x4000              # $s0: base address of peripherals

sw $0,0x40($0)              # 0x40(=64): scan counter (0~3)

sw $0, 0x08($s0)		    # Disable TCON

lui $t0,0xffff
sw $t0,0x00($s0)            # timer rate=1048576T (about 0.01s)

addi $t0, $0, 0xffff
sw $t0,0x04($s0)            # load TH as 0xffffffff

addi $t0, $0, 0x03	        # Enable the TimerIT
sw $t0, 0x08($s0)


addi $t0,$0,0x3F            # digit display
sw $t0,0($0)
addi $t0,$0,0x06
sw $t0,4($0)
addi $t0,$0,0x5B
sw $t0,8($0)
addi $t0,$0,0x4F
sw $t0,12($0)
addi $t0,$0,0x66
sw $t0,16($0)
addi $t0,$0,0x6D
sw $t0,20($0)
addi $t0,$0,0x7D
sw $t0,24($0)
addi $t0,$0,0x07
sw $t0,28($0)
addi $t0,$0,0x7F
sw $t0,32($0)
addi $t0,$0,0x6F
sw $t0,36($0)
addi $t0,$0,0x77
sw $t0,40($0)
addi $t0,$0,0x7C
sw $t0,44($0)
addi $t0,$0,0x39
sw $t0,48($0)
addi $t0,$0,0x5E
sw $t0,52($0)
addi $t0,$0,0x79
sw $t0,56($0)
addi $t0,$0,0x71
sw $t0,60($0)

# read $a0 and $a1 from UART
read_a0:
lw $t0,0x20($s0)
andi $t1,$t0,0x8
beq $t1,$0,read_a0
lw $a0,0x1c($s0)
read_a1:
lw $t0,0x20($s0)
andi $t1,$t0,0x8
beq $t1,$0,read_a1
lw $a1,0x1c($s0)

sw $a0,0x44($0)             # reserve a copy for display
sw $a1,0x48($0)

# The gcd function. $v0=gcd($a0,$a1)
add $t3,$0,$0               # t3: count of common 2's

loop_main:
bne $a1,$0,fi_a1_zero       # if(a1==0)v0=a0;break;
add $v0,$a0,$0
j end_main
fi_a1_zero:
bne $a0,$0,fi_a0_zero       # if(a0==0)v0=a1;break;
add $v0,$a1,$0
j end_main
fi_a0_zero:

loop_div2:
    andi $t0,$a0,1          # t0=a0%2;
    andi $t1,$a1,1          # t1=a1%2;
    and $t2,$t0,$t1
    bne $t2,$0,end_div2     # if(t0&&t1)break;

    bne $t0,$0,fi_div_a0    # if(!t0)a0/=2;
    srl $a0,$a0,1
    fi_div_a0:

    bne $t1,$0,fi_div_a1    # if(!t1)a1/=2;
    srl $a1,$a1,1
    fi_div_a1:

    or $t2,$t0,$t1          # if(!t0&&!t1)t3+=1;
    bne $t2,$0,fi_inc_t3
    addi $t3,$t3,1
    fi_inc_t3:

    j loop_div2
end_div2:

sltu $t0,$a0,$a1            # if(a0<a1)
beq $t0,$0,a0_ge_a1
subu $a1,$a1,$a0            # a1=(a1-a0)/2;
srl $a1,$a1,1
j fi_sub
a0_ge_a1:
subu $a0,$a0,$a1            # else a0=(a0-a1)/2;
srl $a0,$a0,1
fi_sub:

j loop_main
end_main:

loop_x2:
beq $t3,$0,end_x2           # v0<<=t3;
sll $v0,$v0,1
addi $t3,$t3,-1
j loop_x2
end_x2:

sw $v0,0x4c($s0)            # reserve a copy for display

# write v0 to UART
write:
lw $t0,0x20($s0)
andi $t1,$t0,0x4
beq $t1,$0,write
sw $v0,0x18($s0)

j read_a0

interrupt:

lui $s0,0x4000
lw $t0, 0x08($s0)
andi $t0, $t0, 0xfff9
sw $t0, 0x08($s0)		  #Disable the IT status


add $t0,$0,$0               # t0: bitset for display control
lw $s1,0x40($0)             # load scan counter

# Display layout:
# AN3     AN2     AN1     AN0
# a0_high a0_low  a1_high a1_low

andi $t1,$s1,2              # set 0-7 bits (the digit to display)
beq $t1,$0,load_a1          
lw $t2,0x44($0)
j end_load_a
load_a1:
lw $t2,0x48($0)
end_load_a:
addi $t2,$0,0xFF

andi $t1,$s1,1
beq $t1,$0,load_low4
andi $t2,$t2,0xF0
srl $t2,$t2,4
j end_load_4
load_low4:
andi $t2,$t2,0xF
end_load_4:

sll $t2,$t2,2
lw $t0,0($t2)

addi $t3,$0,0x100           # set 8-11 bits (where to display)
add $t1,$0,$s1
set_an:
beq $t1,$0,an_ok
sll $t3,$t3,1
addi $t1,$t1,-1
j set_an
an_ok:
or $t0,$t0,$t3

sw $t0,0x14($s0)            # send digit display to hardware
lw $t7,0x4c($0)
sw $t7,0x0c($s0)            # send LED display to hardware

addi $s1,$s1,1              # increase and save the scan counter
andi $s1,$s1,3
sw $s1,0x40($0)

lw $t0, 0x08($s0)
addi $s1, $0, 0x0002
or $t0, $t0, $s1
sw $t0, 0x08($s0)		  #Disable the IT status

jr $k0