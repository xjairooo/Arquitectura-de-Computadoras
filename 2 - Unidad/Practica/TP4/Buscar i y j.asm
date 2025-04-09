	.data
matriz: .word 1, 2, 3, 4,
              5, 6, 7, 8,
              9, 10, 11, 12

msg_entrada_i: .string "Ingrese fila i (0-2): "
msg_entrada_j: .string "Ingrese columna j (0-3): "
msg_salida:    .string "Valor en (i,j): "

	.text
main:
    # Mostrar e ingresar i
    li a7, 4
    la a0, msg_entrada_i
    ecall

    li a7, 5       # leer entero
    ecall
    mv a3, a0      # guardar i

    # Mostrar e ingresar j
    li a7, 4
    la a0, msg_entrada_j
    ecall

    li a7, 5       # leer entero
    ecall
    mv a4, a0      # guardar j

    # Setear otros parámetros
    la a0, matriz  # base de matriz
    li a1, 3       # n = filas
    li a2, 4       # m = columnas

    call obtener_elemento

    # Mostrar resultado
    li a7, 4
    la a0, msg_salida
    ecall

    mv a0, a5
    li a7, 1
    ecall

    li a7, 10
    ecall

# ---------------------------------------
# Subrutina: obtener_elemento
# Entrada:
#   a0 = base matriz (indice)
#   a1 = n (filas) — no se usa aquí
#   a2 = m (columnas)
#   a3 = i
#   a4 = j
# Salida:
#   a5 = matriz[i][j]
# ---------------------------------------
obtener_elemento:
    mul t0, a3, a2     # i * m
    add t0, t0, a4     # i * m + j
    slli t0, t0, 2     # offset en bytes
    add t1, a0, t0     # dirección matriz[i][j]
    lw a5, 0(t1)       # cargar valor
    ret
