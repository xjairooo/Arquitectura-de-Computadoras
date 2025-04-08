	.data
arreglo: .half 0x0000, 0x0008, 0x0007, 0x000F, 0x0010, 
			   0x0018, 0x0020, 0x0028, 0x0030, 0x0038
size:	 .word 10
suma:	 .word 0

	.text
main:
	la a0, arreglo      # Carga la direccion base del arreglo en a0
    la t0, size         # Carga la direccion de 'size' en t0
    lw a1, 0(t0)        # Lee el valor de size (10) a a1

    li a2, 0            # Inicializa contador (i = 0) en a2
    li a3, 0            # Inicializa acumulador (suma = 0) en a3 
loop:
	# 1. Verificar condicion de salida del bucle
    # Compara el indice actual (a2) con el tamaño (a1)
    # Si a2 >= a1, salta a 'end' para terminar
	bge a2, a1, fin	# if (i >= size), salta a 'fin'
	
    # 2. Calculo de direccion del elemento
    # Multiplica i * 2 (tamaño de half-word)
    # y calcula dirección efectiva
    # 1 porque 1 bit equivale a multiplicar por 2
    slli t0, a2, 1      # t0 = i * 2 (offset en bytes)
    add t1, a0, t0      # t1 = direccion de array[i] (a0 + offset)

	# Carga el half-word (16 bits con extension de signo)
    lh t2, 0(t1)        # t2 = valor de array[i]
	
	# -- Verificar del bit 3 --
    # Aplica mascara 0x0008 (0000 0000 0000 1000)
    # para comprobar si el bit 3 está activo
    andi t3, t2, 0x0008 # t3 = t2 & 0x0008
    beqz t3, skip       # if (bit 3 == 0) salta a 'skip'
	
	# Acumulación del valor
    # Si (bit 3 == 1) suma
    # Solo suma si el bit 3 estaba activado
    add a3, a3, t2      # suma += array[i]

skip:
	# Incremento el indice
	addi a2, a2, 1		#i++
	j loop

fin:	
	# Almacenamiento del resultado
    la t0, suma		# Carga direccion de 'suma'
    sw a3, 0(t0)    # t0 = Guarda resultado en memoria
	
	# Imprimir resultado
	mv a0, a3		# Mueve el resultado a a0
	li a7, 1		# Codigo de syscall para imprimir entero		
	ecall

	# Termina el programa
	li a7, 10
	ecall