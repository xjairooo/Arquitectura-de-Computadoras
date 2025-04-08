	.data
arreglo: .byte	4, 7, 12, 3, 8, 15, 22, 9, 18, 1		# Arreglo de 10 bytes 1 c/u
PAR:	 .space 10	# Reservamos 10 bytes para numeros pares
IMPAR:	 .space 10	# Reservamos 10 bytes para numeros impares

msg_par: 	.asciz "\nNumeros pares: "
msg_impar:	.asciz "\nNumeros impares: "
nextline:	.asciz "\n"

	.text
main:
	la t0, arreglo	# t0 = direccion de 'arreglo'
	la t1, PAR 		# t1 = direccion de PAR
	la t2, IMPAR 	# t2 = direccion de IMPAR 
	
	# Indice/Contadores
	li t3, 0        # Inicializa el indice general (t3 = 0) 
	li t4, 0        # Inicializa el contador de pares (t4 = 0)
	li t5, 0        # Inicializa el contador de impares (t5 = 0)
	
	# Limite
	li s0, 10		# Limite del arreglo (s0 = 10)
	
loop:
    # ------------------------------------------------------------
    # 1. Verificar si ya se recorrio todo el arreglo
    # ------------------------------------------------------------
    # Compara el indice actual (t3) con el limite (s0 = 10).
    # Si son iguales, salta a 'imprimir' para mostrar los resultados.
    # ------------------------------------------------------------
    beq t3, s0, imprimir     # if (t3 == 10) goto imprimir;

    # ------------------------------------------------------------
    # 2. Calcular la direccion del elemento actual en el arreglo
    # ------------------------------------------------------------
    # t0 = direccion base del arreglo.
    # t3 = indice actual (0 a 9).
    # t6 = guarda la direccion del elemento arreglo[t3].
    # Ejemplo: Si t3 = 2, t6 = t0 + 2 (apunta al 3er elemento, 12).
    # ------------------------------------------------------------
    add t6, t0, t3           # t6 = t0 + t3;

    # ------------------------------------------------------------
    # 3. Leer el valor actual del arreglo (1 byte)
    # ------------------------------------------------------------
    # Carga el byte en la direccion t6 y lo guarda en s1.
    # s1 = valor de arreglo[t3].
    # Ejemplo: Si arreglo[0] = 4, entonces s1 = 4.
    # ------------------------------------------------------------
    lb s1, 0(t6)             # s1 = *t6;

    # ------------------------------------------------------------
    # 4. Determinar si el numero es par o impar
    # ------------------------------------------------------------
    # AND con 1: s2 = s1 & 1.
    # - Si el resultado es 0: el numero es par (LSB = 0).
    # - Si el resultado es 1: el numero es impar (LSB = 1).
    # Ejemplo:
    #   12 (1100) & 1 = 0 → par.
    #   7 (0111) & 1 = 1 → impar.
    # ------------------------------------------------------------
    andi s2, s1, 1           # s2 = s1 & 1;

    # ------------------------------------------------------------
    # 5. Saltar a 'es_par' si el numero es par (s2 == 0)
    # ------------------------------------------------------------
    # Si s2 == 0, el numero es par y salta a 'es_par'.
    # Si no, continua con el código para impares.
    # ------------------------------------------------------------
    beq s2, zero, es_par     # if (s2 == 0) goto es_par;
	
	# --- IMPAR ---
	# ------------------------------------------------------------
    # 1. Calcular la direccion donde se guardara el numero impar
    # ------------------------------------------------------------
    # t2 = direccion base del arreglo IMPAR
    # t5 = contador de impares (inicia en 0)
    # s3 = direccion de IMPAR[t5]
    # Ejemplo: si t5 = 0, s3 = t2 + 0 (primera posicion libre en IMPAR)
    # ------------------------------------------------------------
    add s3, t2, t5			# s3 = t2 + t5
    
	# ------------------------------------------------------------
	# 2. Guardar el numero impar en el arreglo IMPAR
	# ------------------------------------------------------------
	# s1 = valor impar actual (ejemplo: 7).
	# Lo guarda en la direccion calculada (s3).
	# Ejemplo: Si s1 = 7, IMPAR[0] = 7.
	# ------------------------------------------------------------
	sb s1, 0(s3)       # *s3 = s1;
	
	# ------------------------------------------------------------
	# 3. Incrementar el contador de impares
	# ------------------------------------------------------------
	# t5 = t5 + 1.
	# Asi, la próxima vez que se guarde un impar, ira en IMPAR[1].
	# ------------------------------------------------------------
	addi t5, t5, 1     # t5++;
	
	j siguiente

	# ---- PAR ----
es_par:
	# ------------------------------------------------------------
	# 1. Calcular la direccion donde se guardara el número par
	# ------------------------------------------------------------
	# t1 = direccion base del arreglo PAR.
	# t4 = contador de pares (inicia en 0).
	# s3 = direccion de PAR[t4].
	# Ejemplo: Si t4 = 0, s3 = t1 + 0 (primera posicion libre en PAR).
	# ------------------------------------------------------------
	add s3, t1, t4     # s3 = t1 + t4;
	
	# ------------------------------------------------------------
	# 2. Guardar el numero par en el arreglo PAR
	# ------------------------------------------------------------
	# s1 = valor par actual (ejemplo: 4).
	# Lo guarda en la direccion calculada (s3).
	# Ejemplo: Si s1 = 4, PAR[0] = 4.
	# ------------------------------------------------------------
	sb s1, 0(s3)       # *s3 = s1;
	
	# ------------------------------------------------------------
	# 3. Incrementar el contador de pares
	# ------------------------------------------------------------
	# t4 = t4 + 1.
	# Así, la proxima vez que se guarde un par, ira en PAR[1].
	# ------------------------------------------------------------
	addi t4, t4, 1     # t4++;
		
siguiente:
	addi t3, t3, 1
	j loop
	
	# -- Imprimir resultados --
imprimir:
	# Mensaje pares
	la a0, msg_par
	li a7, 4
	ecall
	
	li t3, 0 	# Reinicia t3 para usarlo como indice
print_par:
	beq t3, t4, salto_linea 	# Si t3 == t4 (total de pares), salta
	add t6, t1, t3			# t6 = direccion de PAR[t3]
	lb a0, 0(t6) 			# a0 = valor de PAR[t3]
	li a7, 1
	ecall
	
	# Espacio entre numeros
	li a0, 32				# 32 = ASCII para espacio (' ')
	li a7, 11				# Codigo syscall para imprimir caracter
	ecall
	
	# Incremento
	addi t3, t3, 1	# t3++
	j print_par
	
salto_linea:
	la a0, nextline
	li a7, 4
	ecall
	
	la a0, msg_impar
	li a7, 4
	ecall
	
	# Reinicio t3 como indice
	li t3, 0
print_impar:
    beq t3, t5, fin      # Si t3 == t5 (contador de impares), termina
    add t6, t2, t3       # t6 = direccion de IMPAR[t3]
    lb a0, 0(t6)         # a0 = valor de IMPAR[t3]
    li a7, 1             # Syscall para imprimir entero
    ecall                # Imprime el número

    li a0, 32            # Espacio
    li a7, 11            # Syscall para imprimir carácter
    ecall                # Imprime ' '

    addi t3, t3, 1       # t3++
    j print_impar        # Repite el bucle

fin:
	li a7, 10
	ecall