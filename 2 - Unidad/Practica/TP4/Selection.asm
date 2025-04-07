.data
arreglo:    .word 36, 13, 21, 11, 75, 54, 23, 44, 34   # Arreglo original
RES:        .word 0, 0, 0, 0, 0, 0, 0, 0, 0           # Arreglo para el resultado
TAMANIO:    .word 9                                   # Tamaño del arreglo

.text
main:
    # Copiar arreglo a RES (para no modificar el original)
    la a0, arreglo    # Dirección de arreglo
    la a1, RES        # Dirección de RES
    lw a2, TAMANIO    # Tamaño
    jal copiar_arreglo # Llamamos a la función de copia

    # Ordenar RES de menor a mayor (Selection Sort simplificado)
    la a0, RES        # Ahora trabajamos sobre RES
    lw a1, TAMANIO    # Tamaño
    jal ordenar       # Llamamos a la función de ordenamiento

    # Terminar programa
    li a7, 10
    ecall

# --- Función para copiar arreglo ---
copiar_arreglo:
    mv t0, zero       # Contador i = 0
loop_copia:
    bge t0, a2, fin_copia  # Si i >= tamaño, terminar
    slli t1, t0, 2    # i * 4 (desplazamiento en bytes)
    add t2, a0, t1    # Dirección de arreglo[i]
    lw t3, 0(t2)      # Valor de arreglo[i]
    add t4, a1, t1    # Dirección de RES[i]
    sw t3, 0(t4)      # RES[i] = arreglo[i]
    addi t0, t0, 1    # i++
    j loop_copia
fin_copia:
    ret               # Retornar

# --- Función para ordenar (Selection Sort) ---
ordenar:
    mv t0, zero       # i = 0
loop_externo:
    addi t5, a1, -1   # tamaño - 1
    bge t0, t5, fin_ordenar  # Si i >= tamaño-1, terminar
    mv t1, t0         # min_idx = i (asumimos que el mínimo está en i)
    addi t2, t0, 1    # j = i + 1
loop_interno:
    bge t2, a1, intercambiar  # Si j >= tamaño, ir a intercambiar
    # Cargar RES[j]
    slli t3, t2, 2    # j * 4
    add t3, a0, t3    # Dirección de RES[j]
    lw t4, 0(t3)      # t4 = RES[j]
    # Cargar RES[min_idx]
    slli t5, t1, 2    # min_idx * 4
    add t5, a0, t5    # Dirección de RES[min_idx]
    lw t6, 0(t5)      # t6 = RES[min_idx]
    # Comparar
    bge t4, t6, siguiente_j  # Si RES[j] >= RES[min_idx], saltar
    mv t1, t2         # min_idx = j (nuevo mínimo encontrado)
siguiente_j:
    addi t2, t2, 1    # j++
    j loop_interno
intercambiar:
    beq t0, t1, siguiente_i  # Si i == min_idx, no intercambiar
    # Intercambiar RES[i] y RES[min_idx]
    slli t3, t0, 2    # i * 4
    add t3, a0, t3    # Dirección de RES[i]
    lw t4, 0(t3)      # t4 = RES[i]
    slli t5, t1, 2    # min_idx * 4
    add t5, a0, t5    # Dirección de RES[min_idx]
    lw t6, 0(t5)      # t6 = RES[min_idx]
    sw t6, 0(t3)      # RES[i] = RES[min_idx]
    sw t4, 0(t5)      # RES[min_idx] = RES[i]
siguiente_i:
    addi t0, t0, 1    # i++
    j loop_externo
fin_ordenar:
    ret               # Retornar