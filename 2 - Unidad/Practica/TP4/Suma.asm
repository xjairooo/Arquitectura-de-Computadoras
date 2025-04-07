	.data
msg1:	.asciz "Ingrese el primer numero: "
msg2:	.asciz "Ingrese el segundo numero: "
resultado:	.asciz "La suma es: "

	.text
main:
	# Imprime el primer mensaje
	la a0, msg1	# Carga la direccion del String en a0
	li a7, 4 	# Codigo syscall para imprimir String
	ecall		# Realiza el syscall
	
	# Leer el primer valor (por defecto el valor se guarda en a0),
	# a0 es el registro donde se devuelve el resultado de una syscall
	li a7, 5 	# Codigo syscall para leer entero
	ecall		# Realiza syscall (el valor se guardo en a0)
	mv t0, a0	# Transfiere el primer valor de a0 -> t0
	
	# Imprime el segundo mensaje
	la a0, msg2	# Carga la direccion del String en a0
	li a7, 4 	# Codigo syscall para imprimir String
	ecall		# Realiza el syscall
	
	# Leer el segundo valor
	li a7, 5 	# Codigo syscall para leer entero
	ecall		# Realiza syscall (el valor se guardo en a0)
	mv t1, a0	# Transfiere el primer valor de a0 -> t1
	
	# Sumar los dos numeros
	add t2, t0, t1	# t2 = t0 + t1
	
	# Imprime el mensaje de resultado
	la a0, resultado 	# Carga la direccion del String de resultado
	li a7, 4 	# Codigo syscall para imprimir String
	ecall		# Realiza la syscall
	
	# Imprime el resultado de la suma
	mv a0, t2	# Mueve el resultado de la suma de t2 -> a0
	li a7, 1 	# Codigo syscall para imprimir entero
	ecall		# Realiza la syscall
	
	# Termina el programa
	li a7, 10	
	ecall