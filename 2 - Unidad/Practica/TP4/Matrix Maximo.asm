.data
matriz: .word 5, 3, 9, 2, 8, 1, 7, 4, 6
MAX:    .space 12
msg1:   .string "Matriz 3x3:\n"
msg2:   .string "Maximos por fila:\n"

.text
.globl main
main:
    # Preparar direcciones
    la s0, matriz       # base de matriz (registro guardado)
    la s1, MAX          # base de MAX (registro guardado)

    li t0, 0            # índice matriz
    li t1, 9            # tamaño total de matriz
    li t2, 3            # tamaño de fila (constante)

    # Mostrar mensaje inicial
    li a7, 4
    la a0, msg1
    ecall

    # Usar t3 para recorrer la matriz
    mv t3, s0

# Imprimir matriz 3x3
print_matrix:
    bge t0, t1, find_max
    lw a0, 0(t3)        # Cargar valor actual
    li a7, 1
    ecall

    li a0, 32           # espacio ' '
    li a7, 11
    ecall

    addi t3, t3, 4      # Incrementar puntero de matriz
    addi t0, t0, 1      # Incrementar contador

    # Verificar si necesitamos nueva línea
    li t4, 3            # constante para comparar
    rem t5, t0, t4      # t5 = t0 % 3
    beqz t5, newline
    j print_matrix

newline:
    li a0, 10           # salto de línea
    li a7, 11
    ecall
    j print_matrix

# Encontrar máximos por fila
find_max:
    mv t3, s0           # reiniciar puntero a matriz
    li t0, 0            # contador de filas

row_loop:
    bge t0, t2, print_max
    
    # Calcular offset de fila
    li t4, 3            # elementos por fila
    mul t5, t0, t4      # fila * 3
    slli t5, t5, 2      # convertir a bytes (×4)
    add t6, s0, t5      # dirección de inicio de fila

    # Cargar elementos de la fila
    lw a0, 0(t6)        # primer elemento
    lw a1, 4(t6)        # segundo elemento
    lw a2, 8(t6)        # tercer elemento

    # Encontrar máximo entre a0 y a1
    bge a0, a1, compare_third
    mv a0, a1

compare_third:
    bge a0, a2, store_max
    mv a0, a2

store_max:
    sw a0, 0(s1)        # guardar máximo en array MAX
    addi s1, s1, 4      # avanzar en array MAX
    addi t0, t0, 1      # siguiente fila
    j row_loop

# Imprimir máximos
print_max:
    li a7, 4
    la a0, msg2
    ecall

    la s1, MAX          # reiniciar puntero a MAX
    li t0, 0            # contador

print_loop:
    bge t0, t2, exit
    lw a0, 0(s1)
    li a7, 1
    ecall

    li a0, 10           # salto de línea
    li a7, 11
    ecall

    addi s1, s1, 4
    addi t0, t0, 1
    j print_loop

exit:
    li a7, 10
    ecall