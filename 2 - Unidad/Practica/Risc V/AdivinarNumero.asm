.data
msg_bienvenida: .asciz "¡Bienvenido a 'Adivina el número'!\nIntroduce un número entre 1 y 100: "
msg_mayor:      .asciz "El número objetivo es MAYOR.\nIntenta de nuevo: "
msg_menor:      .asciz "El número objetivo es MENOR.\nIntenta de nuevo: "
msg_ganaste:     .asciz "¡Correcto! ¡Has adivinado el número!\n"
input_buffer:   .space 32

.text
.globl main

main:
    # Configuración de semilla aleatoria
    li a7, 30
    ecall
    mv a1, a0
    li a0, 0
    li a7, 40
    ecall

    # Generar número aleatorio 1-100
    li a7, 42
    li a1, 100
    ecall
    addi s0, a0, 1       # s0 = número objetivo

    # Mostrar mensaje inicial
    la a0, msg_bienvenida
    li a7, 4
    ecall

game_loop:
    # Leer entrada del usuario
    li a7, 8
    la a0, input_buffer
    li a1, 32
    ecall

    # Convertir a número
    jal atoi

    # Comparar con el objetivo
    beq a0, s0, win
    blt a0, s0, hint_mayor
    bgt a0, s0, hint_menor

hint_mayor:
    la a0, msg_mayor
    li a7, 4
    ecall
    j game_loop

hint_menor:
    la a0, msg_menor
    li a7, 4
    ecall
    j game_loop

win:
    la a0, msg_ganaste
    li a7, 4
    ecall
    li a7, 10
    ecall

# Función atoi mejorada
atoi:
    li t0, 0             # Resultado
    la t1, input_buffer   # Cargar dirección del buffer
    li t3, 10            # Base decimal
    li t4, '0'           # Límite inferior
    li t5, '9'           # Límite superior

atoi_loop:
    lb t2, 0(t1)         # Cargar byte actual
    beqz t2, atoi_end    # Fin si es null
    
    blt t2, t4, atoi_next  # Si < '0'
    bgt t2, t5, atoi_next  # Si > '9'
    
    sub t2, t2, t4       # Convertir a número
    mul t0, t0, t3
    add t0, t0, t2

atoi_next:
    addi t1, t1, 1       # Siguiente carácter
    j atoi_loop

atoi_end:
    mv a0, t0
    ret