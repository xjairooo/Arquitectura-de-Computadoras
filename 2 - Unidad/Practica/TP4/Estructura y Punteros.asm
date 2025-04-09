.data
    # Definición de la estructura Persona
    # Campos: nombre (32 bytes), edad (4 bytes), altura (4 bytes)
    persona:      .space 40
    
    # Mensajes para el usuario
    msg_nombre:    .asciz "Ingrese el nombre: "
    msg_edad:      .asciz "Ingrese la edad: "
    msg_altura:    .asciz "Ingrese la altura (cm): "
    msg_resultado: .asciz "\nDatos de la persona:\n"
    msg_nombre_p:  .asciz "Nombre: "
    msg_edad_p:    .asciz "Edad: "
    msg_altura_p:  .asciz "Altura: "
    newline:       .asciz "\n"
    error_msg:     .asciz "Error: Dirección de estructura inválida\n"
    
    # Buffer para entrada de texto
    buffer:       .space 32

.text
.globl main

# Función crear_persona
# Argumentos:
# a0: dirección donde almacenar la estructura (no puede ser cero)
# a1: dirección de la cadena con el nombre
# a2: edad
# a3: altura
crear_persona:
    # Verificar dirección válida
    beqz a0, error_direccion_invalida
    
    # Guardar nombre (copiar byte a byte)
    mv t0, a0       # t0 = dirección de la estructura
    mv t1, a1       # t1 = dirección del nombre de entrada
    
    li t2, 0        # contador
    li t3, 31       # máximo de caracteres (32-1 para el null)
    
copy_name_loop:
    beq t2, t3, copy_name_done  # si llegamos al máximo, terminar
    lb t4, 0(t1)                # cargar byte del nombre de entrada
    beqz t4, copy_name_done     # si es null, terminar
    sb t4, 0(t0)                # almacenar byte en la estructura
    addi t0, t0, 1              # avanzar puntero estructura
    addi t1, t1, 1              # avanzar puntero nombre entrada
    addi t2, t2, 1              # incrementar contador
    j copy_name_loop
    
copy_name_done:
    sb zero, 0(t0)  # asegurar terminación null
    
    # Almacenar edad (a 32 bytes del inicio)
    sw a2, 32(a0)
    
    # Almacenar altura (a 36 bytes del inicio)
    sw a3, 36(a0)
    
    ret

# Función imprimir_persona
# Argumentos:
# a0: dirección de la estructura Persona
imprimir_persona:
    # Guardar registros que modificaremos
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    
    mv s0, a0  # guardar dirección de la estructura
    
    # Imprimir mensaje de resultado
    la a0, msg_resultado
    li a7, 4
    ecall
    
    # Imprimir nombre
    la a0, msg_nombre_p
    li a7, 4
    ecall
    
    mv a0, s0  # dirección del nombre en la estructura
    li a7, 4
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Imprimir edad
    la a0, msg_edad_p
    li a7, 4
    ecall
    
    lw a0, 32(s0)  # cargar edad
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Imprimir altura
    la a0, msg_altura_p
    li a7, 4
    ecall
    
    lw a0, 36(s0)  # cargar altura
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    # Restaurar registros
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    
    ret

error_direccion_invalida:
    # Manejar el error
    la a0, error_msg
    li a7, 4
    ecall
    li a7, 10
    ecall

# Función principal
main:
    # Guardar ra en la pila
    addi sp, sp, -4
    sw ra, 0(sp)
    
    # Pedir nombre
    la a0, msg_nombre
    li a7, 4
    ecall
    
    la a0, buffer
    li a1, 32
    li a7, 8
    ecall
    
    # Eliminar el newline al final del nombre
    la t0, buffer
remove_newline:
    lb t1, 0(t0)
    beqz t1, remove_done
    li t2, '\n'
    beq t1, t2, found_newline
    addi t0, t0, 1
    j remove_newline
found_newline:
    sb zero, 0(t0)  # reemplazar newline con null
    
remove_done:
    # Pedir edad
    la a0, msg_edad
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s0, a0  # guardar edad en s0
    
    # Pedir altura
    la a0, msg_altura
    li a7, 4
    ecall
    
    li a7, 5
    ecall
    mv s1, a0  # guardar altura en s1
    
    # Crear persona
    la a0, persona  # dirección de la estructura
    la a1, buffer   # dirección del nombre
    mv a2, s0       # edad
    mv a3, s1       # altura
    jal crear_persona
    
    # Imprimir persona
    la a0, persona
    jal imprimir_persona
    
    # Restaurar ra y terminar
    lw ra, 0(sp)
    addi sp, sp, 4
    li a7, 10
    ecall