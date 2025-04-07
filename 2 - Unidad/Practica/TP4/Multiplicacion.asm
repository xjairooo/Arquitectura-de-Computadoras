	.data
msg1:	.asciz"Ingrese un numero: "
resultado:	.asciz"Resultado: "
newline:	.asciz"\n"
.eqv MAX, 10 # Fin de bucle (10)
.eqv BASE, 1 # Inicio del bucle (1)

	.text
main:
	# Pedir el valor a multiplicar 
	la a0, msg1
	li a7, 4
	ecall
	
	# Leer el numero entero
	li a7, 5
	ecall
	mv t0, a0
	
	li t1, BASE
	li t2, MAX
loop:
	bgt t1, t2, fin 	# Si multiplicador > 10, salta a 'fin'
	mul t3, t0, t1
	
	# Imprime el resultado
	la a0, resultado
	li a7, 4
	ecall
	
	# Imprime el valor del resultado (t2)
	mv a0, t3
	li a7, 1
	ecall
	
	# Salto de linea
	la a0, newline
	li a7, 4
	ecall
	
	addi t1, t1, 1	#Incrementa el contador
	j loop
	
fin:
	li a7, 10
	ecall			
		