	.data
arreglo: .word 36, 13, 21, 11, 75, 54, 23, 44, 34
MINIMO:	 .word 0

.eqv TAMANIO, 9
	.text
main:
	# Inicializar los registros
	la a0, arreglo
	li a1, TAMANIO  # Longitud del arreglo
	
	lw t0, 0(a0)	# Carga el primer elemento minimo
	addi t1, zero, 1	# Contador en 1
loop:
	bge t1, a1, fin	# Si contador >= longitud, salta a 'fin'
	slli t2, t1, 2	# Desplazamiento para la siguiente direccion de memoria
	add t2, a0, t2	# Aca obtiene el valor siguiente del array para comparar
	lw t3, 0(t2)	# Cargar elemento actual 
	
	bge t3, t0, next # Si elemento >= mínimo actual, saltar
    mv t0, t3         # Actualiza el mínimo	

next:
	addi t1, t1, 1	# Incrementa el contador
	j loop			
fin:
	la t4, MINIMO	# Carga la direccion de MINIMO
	sw t0, 0(t4)	# Guarda el valor minimo
	
	# Termina el programa
	li a7, 10
	ecall
	