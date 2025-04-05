# Suma de los primeros N números naturales: Escribir un programa que calcule la
# suma de los primeros N números naturales.

	.text
main:
	li a0, 10        # Carga el valor de N (10 en este caso)
	li t0, 0         # Inicializa el acumulador de suma a 0
	li t1, 1         # Inicializa el contador a 1

suma:
	add t0, t0, t1   # Suma el valor actual del contador al acumulador
	addi t1, t1, 1   # Incrementa el contador en 1
	ble t1, a0, suma # Repite mientras el t1 ≤ a0 sino salta a suma
	
	li a7, 10        # Prepara la llamada al sistema para terminar
	ecall            # Termina la ejecucion del programa
