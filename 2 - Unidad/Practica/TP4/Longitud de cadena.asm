	.data
prompt:     .asciz "Ingrese una cadena: "
buffer:     .space 256     # Espacio para la cadena ingresada
result_msg: .asciz "La longitud de la cadena es: "

	.text
main:
    # Imprimir prompt
    li a7, 4
    la a0, prompt
    ecall
    
    # Leer cadena del usuario
    li a7, 8
    la a0, buffer
    li a1, 256
    ecall
    
    # Llamar a la función len
    la a0, buffer
    jal ra, len
    
    # Guardar el resultado
    mv t0, a0
    
    # Imprimir mensaje de resultado
    li a7, 4
    la a0, result_msg
    ecall
    
    # Imprimir la longitud
    li a7, 1
    mv a0, t0
    ecall
    
    # Salir del programa
    li a7, 10
    ecall

# Función len(pcad) - recursiva
# Entrada: a0 - puntero a la cadena
# Salida: a0 - longitud de la cadena
len:
    addi sp, sp, -8       # Reservar espacio en la pila
    sw ra, 4(sp)           # Guardar dirección de retorno
    sw a0, 0(sp)           # Guardar puntero actual
    
    lbu t0, 0(a0)          # Cargar el carácter actual
    beqz t0, base_case     # Si es cero, hemos llegado al final
    
    # Llamada recursiva
    addi a0, a0, 1         # Mover al siguiente carácter
    jal ra, len
    
    addi a0, a0, 1         # Incrementar el contador
    j return
    
base_case:
    li a0, 0               # Caso base: longitud 0
    
return:
    lw t0, 0(sp)           # Restaurar puntero
    lw ra, 4(sp)           # Restaurar dirección de retorno
    addi sp, sp, 8         # Liberar espacio de pila
    ret