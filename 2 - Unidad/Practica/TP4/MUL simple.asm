.data
NUM1: .word 6
NUM2: .word 7
RES:  .word 0
msg1: .string "NUM1 = "
msg2: .string "\nNUM2 = "
msg3: .string "\nResultado = "

.text
.globl main
main:
    la t0, NUM1
    lw t1, 0(t0)

    la t0, NUM2
    lw t2, 0(t0)

    mul t3, t1, t2

    la t0, RES
    sw t3, 0(t0)

    # Mostrar NUM1
    li a7, 4
    la a0, msg1
    ecall

    li a7, 1
    mv a0, t1
    ecall

    # Mostrar NUM2
    li a7, 4
    la a0, msg2
    ecall

    li a7, 1
    mv a0, t2
    ecall

    # Mostrar resultado
    li a7, 4
    la a0, msg3
    ecall

    li a7, 1
    mv a0, t3
    ecall

    li a7, 10
    ecall
