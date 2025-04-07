	.data
arreglo:  .word 4, 15, 23, 34, 17
MINIMO:	  .word 0

.eqv TAMANIO, 5
	.text
main:
	# Inicializar los registros
	li a0, arreglo
	li a1, TAMANIO  # Longitud del arreglo
	
	lw t0, 0(a0)	# Carga el primer elemento
	addi t1, zero, 1	# Contador en 1
loop:
	bge t1, a1, fin	# Si contador >= longitud, salta a 'fin'
	
fin:
	
	li a7, 10
	ecall
	