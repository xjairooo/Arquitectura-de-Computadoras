	.data
# .word = reserva espacios de 4 bytes (1 palabra en RISC-V) para cada entero.
TABLA:	.word 5, 12, 7, 3, 9, 8, 23, 35, 11, 15 	# Arreglo de 10 enteros
X:		.word 18									# Valor a comparar
# Inicia en 0 porque el programa lo incrementara durante el bucle.
CANT:	.word 0										# Resultado del conteo
# RES es un arreglo de 10 enteros (como TABLA), pero no lo inicializamos con valores fijos.
RES: 	.space 40									# Reserva 40 bytes (10 × 4 bytes) sin asignar valores iniciales.

	.text
main:
    # Inicializacion de registros
    la a0, TABLA      # a0 = direccion de TABLA
    la a1, RES        # a1 = direccion de RES
    la t1, X		  # t1 = direccion de X
    lw a2, 0(t1)      # a2 = valor de X (18)
    li a3, 10  		  # a3 = tamaño fijo (10)
    li a4, 0          # a4 = contador de numero mayores
    li t0, 0          # t0 = indice (i)
    
loop:	
	bge t0, a3, fin_loop	# Si i >= 10, salir del bucle
	# Cargar TABLA[i] en un registro temporal
    lw t1, 0(a0)            # t1 = valor actual de TABLA
	ble t1, a2, menor_igual # Si TABLA[i] <= X, saltar a "menor_igual"
	
	# En caso si TABLA[i] > X:
    li t2, 1               # t2 = 1
    sw t2, 0(a1)           # RES[i] = 1
    addi a4, a4, 1         # Incrementar contador (a4 += 1)
    j next_iter            # Saltar a "next_iter"

menor_igual:
	 # En caso TABLA[i] <= X:
    sw zero, 0(a1)         # RES[i] = 0
    
next_iter:
	# Actualiza las direcciones e indice
	addi a0, a0, 4         # Mover a0 al siguiente elemento de TABLA
    addi a1, a1, 4         # Mover a1 al siguiente elemento de RES
    addi t0, t0, 1         # Incrementar indice (i += 1)
    j loop                 # Repetir bucle
	
fin_loop:
	# Guardar el resultado en CANT
    la t3, CANT          # Cargar direccion de CANT en t3
    sw a4, 0(t3)         # Almacenar el valor de a4 (contador) en CANT

	# Termina el programa
	li a7, 10
	ecall
