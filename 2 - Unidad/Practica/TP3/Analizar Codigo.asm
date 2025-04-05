# ¿Qué hace este código?
# El codigo realiza una cuenta regresiva desde 10 hasta 0
	.text
	
	# x0: Registro zero (siempre vale 0)
	addi x3, x0, 10	# Inicializa x3 con valor 10
a:
	addi x3,x3,-1	# Decrementa x3 en -1
	bgt x3,x0, a	# Salta a 'a' si x3 > 0
	
	# Termina el programa
	li a7, 10	
	ecall
	
# -- Definicion (bgt) --
# bgt (Branch if Greater Than) es una pseudoinstrucción 
# en RISC-V que significa:

# - Salta si el valor del primer registro es mayor que el valor
# del segundo registro

# Sintaxis: bgt rs1, rs2, label
