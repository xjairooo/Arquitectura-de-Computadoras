.data
arreglo:    .byte 4, 7, 12, 3, 8, 15, 22, 9, 18, 1
PAR:        .space 10
IMPAR:      .space 10

msg_par:    .string "\nNumeros pares: "
msg_impar:  .string "\nNumeros impares: "
salto:      .string "\n"

.text
.globl main
main:
    la t0, arreglo     # t0 = puntero al arreglo original
    la t1, PAR         # t1 = puntero al arreglo de pares
    la t2, IMPAR       # t2 = puntero al arreglo de impares
    li t3, 0           # índice general
    li t4, 0           # contador de pares
    li t5, 0           # contador de impares
    li s0, 10          # límite

loop:
    beq t3, s0, imprimir

    add t6, t0, t3     # dirección del byte actual
    lb s1, 0(t6)       # s1 = valor actual

    andi s2, s1, 1     # s2 = 0 si es par
    beq s2, zero, es_par

# ---- IMPAR ----
    add s3, t2, t5     # dirección IMPAR[t5]
    sb s1, 0(s3)
    addi t5, t5, 1
    j siguiente

# ---- PAR ----
es_par:
    add s3, t1, t4     # dirección PAR[t4]
    sb s1, 0(s3)
    addi t4, t4, 1

siguiente:
    addi t3, t3, 1
    j loop

# ---------- IMPRIMIR RESULTADOS ----------
imprimir:
    # Mensaje pares
    la a0, msg_par
    li a7, 4
    ecall

    li t3, 0
print_par:
    beq t3, t4, salto_linea
    add t6, t1, t3
    lb a0, 0(t6)
    li a7, 1
    ecall

    li a0, 32      # espacio
    li a7, 11
    ecall

    addi t3, t3, 1
    j print_par

salto_linea:
    la a0, salto
    li a7, 4
    ecall

    # Mensaje impares
    la a0, msg_impar
    li a7, 4
    ecall

    li t3, 0
print_impar:
    beq t3, t5, fin
    add t6, t2, t3
    lb a0, 0(t6)
    li a7, 1
    ecall

    li a0, 32
    li a7, 11
    ecall

    addi t3, t3, 1
    j print_impar

fin:
    li a7, 10
    ecall
