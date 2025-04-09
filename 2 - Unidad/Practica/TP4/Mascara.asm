	.data
A:      .word 0x1000, 0x1008, 0x2010, 0x3000, 0x4008, 0x5001, 0x6000, 0x7008
        .word 0x9000, 0xA008, 0xB000, 0xC008, 0xD000, 0xE008, 0xF000
B:      .word  0x1000, 0xAAAA, 0xBBBB, 0xCCCC, 0xDDDD, 0xEEEE, 0xFFFF, 0x1234
        .word  0x9000, 0xA008, 0xB000, 0xC008, 0xD000, 0xE008, 0xF000

size:   .word 15			# Tamaño de los arreglos
mask:   .word 0x1008        # Mascara para bits 3 y 12

	.text
main:
    # Cargar direcciones
    la t0, A                  # t0 = direccion base de A
    la t1, B                  # t1 = direccion base de B
    
    # Cargar size y mask usando 
    la t2, size               # t2 = direccion de size
    lw t2, 0(t2)              # t2 = valor de size
    la t3, mask               # t3 = direccion de mask
    lw t3, 0(t3)              # t3 = valor de mask
    
    li t4, 0                  # Contador i = 0 para el loop

loop:
    bge t4, t2, imprimir_resultado # Si i >= size, ir a imprimir
    
    # Calcular direccion de A[i]
    slli t5, t4, 2            # t5 = i * 4 (offset), calcula el dezplamiento
    # Si t0 = 0x1000 y i = 1 → t6 = 0x1004 (direccion de A[1]).
    add t6, t0, t5            # t6 = dirección de A[i]
    lw a0, 0(t6)              # a0 = A[i], que va a cargar el valor
    
    # Verificar bits con mascara
    and a1, a0, t3  	         # Aplicar mascara, t3 = mask y a0 = el valor
	# Al aplicar la mask y cumpla con 3 y 12, el entero seria igual a la mascara
	# Ya q es un and y luego sirve para comparar
    li a2, 0x1008             	 # a2 = para comparar con la palabra nueva (a1)
    bne a1, a2, saltar_remplazo  # a1 == a2 Si no coincide, saltar
    
    # Reemplazar A[i] con B[i]
    add t5, t1, t5	# t5 = dirección de B[i]
    lw a0, 0(t5)	# a0 = B[i]
    sw a0, 0(t6)	# A[i] = B[i]

saltar_remplazo:
    addi t4, t4, 1	# i++, para loop
    j loop

imprimir_resultado:
    # Imprimir arreglo A
    li t4, 0		# Reiniciar contador para el siguiente loop
print_loop:
	# Imprimir resultados
    bge t4, t2, fin	# Si i >= size, terminar
    
    slli t5, t4, 2	# Calcular offset
    add t6, t0, t5	# Direccion de A[i]
    lw a0, 0(t6)	# Cargar A[i] y en a0 porque asi imprime
    li a7, 1		# Servicio de impresion de entero
    ecall
    
    # Imprimir espacio
    li a0, ' '		# Codigo ASCII para espacio
    li a7, 11		# Servicio de impresion de caracter
    ecall
    
    addi t4, t4, 1	# Incrementar contador
    j print_loop

fin:
    # Nueva linea final
    li a0, '\n'		# Codigo ASCII para nueva linea
    li a7, 11
    ecall
    
    # Terminar programa
    li a7, 10
    ecall

# --- VALORES INICIALES ---
# A: 0x1000, 0x1008, 0x2010, 0x3000, 0x4008, 0x5001, 0x6000, 0x7008, 0x9000, 0xA008, 0xB000, 0xC008, 0xD000, 0xE008, 0xF000
# B: 0x1000, 0xAAAA, 0xBBBB, 0xCCCC, 0xDDDD, 0xEEEE, 0xFFFF, 0x1234, 0x9000, 0xA008, 0xB000, 0xC008, 0xD000, 0xE008, 0xF000

# --- CONVERSIÓN A DECIMAL ---
# A[0] = 0x1000 = 4096
# A[1] = 0x1008 = 4104 (Cumple máscara 0x1008, se reemplaza con B[1] = 0xAAAA = 43690)
# A[2] = 0x2010 = 8208
# A[3] = 0x3000 = 12288
# A[4] = 0x4008 = 16392
# A[5] = 0x5001 = 20481
# A[6] = 0x6000 = 24576
# A[7] = 0x7008 = 28680
# A[8] = 0x9000 = 36864
# A[9] = 0xA008 = 40968
# A[10] = 0xB000 = 45056
# A[11] = 0xC008 = 49160
# A[12] = 0xD000 = 53248
# A[13] = 0xE008 = 57352
# A[14] = 0xF000 = 61440

# --- SALIDA ESPERADA CON REEMPLAZOS ---
# 4096 43690 8208 12288 16392 20481 24576 28680 36864 40968 45056 49160 53248 57352 61440

# Notas importantes:
# 1. Solo A[1] = 0x1008 cumple exactamente con la máscara 0x1008 (bits 3 y 12 en 1)
# 2. A[7] = 0x7008 NO cumple (solo tiene bit 3 en 1) por lo que NO se reemplaza
# 3. Todos los demás valores se mantienen iguales
# 4. El único cambio visible será A[1] que pasa de 4104 a 43690