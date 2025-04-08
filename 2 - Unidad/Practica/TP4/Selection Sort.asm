	.data 
arreglo:	.word 36, 13, 21, 11, 75, 54, 23, 44, 34
RES:        .word 0, 0, 0, 0, 0, 0, 0, 0, 0

mensaje_minimo:	.asciz "El valor minimo es: "
mensaje_res:	.asciz "\nArreglo ordenado: "
nextline:		.asciz "\n"
	.text
main:
	# Cargar direcciones de los arreglos
	la s0, arreglo	# s0 = dirección base del arreglo original
	la s1, RES		# s1 = dirección base del arreglo resultado (ordenado)
    
    # Configurar tamaño y contadores
    li t0, 0	    # t0 = indice para RES (inicia en 0)
    li t1, 9		# t1 = tamaño del arreglo (constante, 9 elementos)
    li s2, 0		# s2 = valor minimo global (inicia en 0)
   
bucle_externo:
	beq t0, t1, imprimir_resultado	 # Si t0 == t1, salir a imprimir
	
    # --- Inicializar busqueda del minimo ---
    li t2, 0 		# t2 = indice para buscar el minimo (0 a 8)
    li t3, 0		# t3 = posicion del minimo (se actualizara)
    li t4, 9999		# t4 = valor minimo temporal (inicializando alto)
    
    # Llamamos a la subrutina que busca el minimo
    j buscar_minimo        
    
buscar_minimo:
    beq t2, t1, guardar_minimo		# Si t2 == t1, guardar minimo
    
    # Calcular direccion de arreglo[t2]
    slli t5, t2, 2	# t5 = offset (t2 * 4)
    add t6, s0, t5	# t6 = dirección de arreglo[t2]
    lw s4, 0(t6)	# s4 = valor de arreglo[t2]
    
    bge s4, t4, continuar_busqueda	# Si s4 >= t4, ignoramos
    mv t4, s4		# t4 = nuevo minimo temporal
    mv t3, t2		# t3 = posicion del nuevo mínimo

continuar_busqueda:
	 # Incrementamos el indice de busqueda (t2) y repetimos
    addi t2, t2, 1
    j buscar_minimo

guardar_minimo:
	# Guardar el valor minimo (t4) en RES[t0]
	slli t5, t0, 2	# t5 = offset (t0 * 4, porque son words)
	add t6, s1, t5	# t6 = dirección de RES[t0] (s1 + offset)
	sw t4, 0(t6)	# Guardamos t4 en RES[t0]
	
	# Guardar el minimo global (solo en la primera iteracion)
	beq t0, zero, guardar_minimo_global
	
	# Si no es la primera iteracion, saltamos a marcar como usado
    j marcar_usado

guardar_minimo_global:
	mv s2, t4		# Guarda el primer minimo en s2 (para imprimir)
	j marcar_usado

marcar_usado:
    # Marcamos el elemento usado en arreglo[t3] con 9999 (para ignorarlo en futuras busquedas)
    slli t5, t3, 2         # t5 = offset del mínimo (t3 * 4)
    add t6, s0, t5         # t6 = direccion de arreglo[t3]
    li s4, 9999            # Valor "infinito" para marcar como usado
    sw s4, 0(t6)           # Lo guardamos en arreglo[t3]
    
    # Incrementamos el indice de RES (t0) y repetimos el bucle
    addi t0, t0, 1
    j bucle_externo
    
# ---------- Imprimir resultados ----------
imprimir_resultado:
    # Imprimir mensaje del minimo
    la a0, mensaje_minimo
    li a7, 4
    ecall
    
    # Imprimir valor minimo
    mv a0, s2
    li a7, 1
    ecall
    
    # Salto de linea
    la a0, nextline
    li a7, 4
    ecall
    
    # Imprimir mensaje del arreglo ordenado
    la a0, mensaje_res
    li a7, 4
    ecall
    
    # Imprimir RES
    li t2, 0               # t2 = indice de impresion
    la t3, RES             # t3 = dirección base de RES

loop_imprimir:
    beq t2, t1, fin        # Si t2 == t1, terminar
    
    slli t5, t2, 2         # t5 = offset
    add t6, t3, t5         # t6 = dirección de RES[t2]
    lw a0, 0(t6)           # Cargar valor
    li a7, 1               # Imprimir entero
    ecall
    
    # Imprimir espacio
    li a0, 32              # ASCII para espacio
    li a7, 11
    ecall
    
    addi t2, t2, 1         # Incrementar indice
    j loop_imprimir

fin:
    li a7, 10              # Exit
    ecall
    