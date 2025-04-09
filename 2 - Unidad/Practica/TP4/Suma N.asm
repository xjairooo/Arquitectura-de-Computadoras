	.data
prompt: .asciz "n: "
res:    .asciz "Suma: "

	.text

main:
    la a0, prompt      # Pedir n
    li a7, 4
    ecall
    
    li a7, 5           # Leer n
    ecall
    
    # Llamar función
    call suma_n        
    
    mv t0, a0          # Guardar resultado
    la a0, res         # Mostrar resultado
    li a7, 4
    ecall
    
    # Imprime el valor
    mv a0, t0
    li a7, 1
    ecall
    
    li a7, 10          # Salir
    ecall

suma_n:
	# lo que va hacer primero es de
    li t0, 1
    blt a0, t0, ret0   # Caso base n <= 0, retorna 0
    
    addi sp, sp, -8    # Reservar espacio en pila (8 bytes)
	sw ra, 0(sp)       # Guardar dirección de retorno
	sw a0, 4(sp)       # Guardar parámetro n actual
    
    # Llamada recursiva (suma_n(n-1))
    addi a0, a0, -1    # n-1
    call suma_n        # Llamada recursiva
    # Restaurar contexto
    lw t1, 4(sp)    # Recuperar n original
    add a0, a0, t1  # suma = suma_n(n-1) + n
    lw ra, 0(sp)    # Recuperar dirección de retorno
    addi sp, sp, 8  # Liberar espacio en pila
    ret

ret0:
    li a0, 0           # Retornar 0
    ret