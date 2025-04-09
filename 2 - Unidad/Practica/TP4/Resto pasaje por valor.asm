	.data
A:	.word 23
B:	.word 5
	
	.text
main:
	# Carga la direccion
	la t0, A
	la t1, B
	# Guarda el valor
	lw s0, 0(t0)
	lw s1, 0(t1)
	
	call RESTO
	
	# Transferir el resto a a0, para imprimir
	mv a0, s0
	li a7, 1
	ecall
	
	# termina el programa
	li a7, 10
	ecall

# ------------------------------------------
# Subrutina RESTO
# Entrada: s0 = numerador, s1 = denominador
# Salida: s0 = resto (numerador % denominador)
# ------------------------------------------# Subrutina
RESTO:	
	beqz s1, resto_error
	
	# rem = "remainder", calcula el resto de una division entera con signo.
	rem s0, s0, s1	# s0 = s0 % s1, s0 contendra el error
	ret	
resto_error:
	li s0, -1		# Valor especial de error
	ret
	