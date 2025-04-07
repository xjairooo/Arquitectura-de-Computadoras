	.data
msg1:		.asciz"Ingrese un numero: "
resultado:	.asciz"Resultado: "
newline:		.asciz"\n"
.eqv MAX, 10 # Fin de bucle (10)
.eqv BASE, 1 # Inicio del bucle (1)

	.text
main:
	# Imprime que ingrese un numero
	la a0, msg1	# Carga la direccion del String en a0
	li a7, 4	# Codigo syscall para imprimir un String
	ecall		# Realiza el syscall
	
	# Leer el numero entero
	li a7, 5	# Codigo syscall para leer un entero
	ecall		# Realiza el syscall
	mv t0, a0	# Transfiere el valor al registro t0 <- a0(por defecto)
	
	# Transfiere las constantes en los registros
	li t1, BASE	# t1 <- BASE (1)
	li t2, MAX	# t2 <- MAX (10)
loop:
	bgt t1, t2, fin 	# Si multiplicador > 10, salta a 'fin'
	mul t3, t0, t1		# Sino, realiza la multiplicacion t3 = t0 * t1
	
	# Imprime el resultado (String)
	la a0, resultado
	li a7, 4	# Codigo syscall para imprimir un string
	ecall
	
	# Imprime el valor del resultado (t2)
	mv a0, t3	# a0 <- t3 transfiere el resultado para imprimir
	li a7, 1	# Codigo syscall para imprimir un Entero
	ecall
	
	# Salto de linea
	la a0, newline
	li a7, 4
	ecall
	
	addi t1, t1, 1	#Incrementa el contador
	j loop
	
fin:
	#Termina el programa
	li a7, 10
	ecall			
		
