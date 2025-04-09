	.data
A:	.word 20	# (numerador)
B:	.word 4		# (denominador)

	
	.text
main:
	
	la t0, A	# t0 <- la direccion de A
	la t1, B	# t1 <- la direccion de B
	
	lw s0, 0(t0)	# s0 <- El valor t0 (20)
	lw s1, 0(t1)	# s1 <- El valor t0 (4)
	
	# 1. Reservar espacio en la pila (sp) para el numerador
	addi sp, sp, -4	# Reservamos 4 bytes en la pila
	
	#2. Guardar el valor de s0 (numerador) en la cima de la pila pq es LIFO
	sw s0, 0(sp)	 
	
	#3. Reservar espacio en la pila (sp) para el denominador
	addi sp, sp, -4	# Reservamos 4 bytes en la pila
	
	#4. Guardar el valor de s1 (denominador) en la cima de la pila pq es LIFO
	sw s1, 0(sp)	 

# --- Ejemplo en como se ve en la pila ---

#   ↓ Dirección más baja
#   ---------------------
#   |    denominador    |  <- sp (ahora)
#   ---------------------
#   |    numerador      |
#   ---------------------

	call DIV	# Llama a subrutina
	
	# Resultado queda en la cima de la pila (cargarlo en registro)
	lw a0, 0(sp)
	#Limpiar la pila
	addi sp, sp, 4
	
	# Imprimir resultado
	li a7, 1
	ecall
	
	# Termina el programa
	li a7, 10
	ecall
# Subrutina de division
DIV:	
	# Extraemos los valores de la pila
	lw s0, 0(sp)         # t0 = denominador
	addi sp, sp, 4       # "quitamos" el denominador
	lw s1, 0(sp)         # t1 = numerador
	addi sp, sp, 4       # "quitamos" el numerador
	
	# Validar si ¿s0, == 0?, salta
	beqz s0, div_zero
	
	# Division s2 = s1 / s0
	div s2, s1, s0
	
	# Guardar rersultado en la pila (reservar espacio)
	addi sp, sp, -4
	sw s2, 0(sp)
	
	ret
	
div_zero:
	li a0, 9999	# Valor error
	addi sp, sp, -4
	sw a0, 0(sp)
	
	ret
				
			