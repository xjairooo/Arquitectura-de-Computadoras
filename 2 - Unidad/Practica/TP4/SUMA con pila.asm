	.data
A: .word 150
B: .word 270

	.text
main:
	# Cargar A y B desde memoria
	la t0, A
	la t1, B
	
	lw s0, 0(t0)
	lw s1, 0(t1)
	
	# Pasar los parametros
	addi sp, sp, -4	# Reserva 4 bytes en la pila
	sw s0, 0(sp)	# Push A
	
	addi sp, sp, -4	# Reserva 4 bytes en la pila
	sw s1, 0(sp)	# Push B
	
	call SUM32
	
	# Cargamos el valor (resultado)
	lw a0, 0(sp)
	li a7, 1
	ecall
	
	li a7, 10 
	ecall
	
SUM32:
	# Extraemos los valores de la pila
	lw t0, 0(sp)	# t0 = B
	addi sp, sp, 4
	
	lw t1, 0(sp)	# t0 = A
	addi sp, sp, 4
	
	# sumar
	add t2, t1, t0
	
	# Devolver el valor con la pila
	addi sp, sp, -4	# Reserva 4 bytes
	sw t2, 0(sp)	# Carga el resultado en la cima de la pila 
	
	ret
	