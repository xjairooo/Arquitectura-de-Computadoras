# Por Valor = pasa el contenido del dato y NO se puede modificar
# NUM1 : 6 y NUM2: 7, se pasan esos datos
# Por Referencia: pasa la direccion de esos datos y SI se puede modificar	
	.data
NUM1: .word 6
NUM2: .word 7
RES:  .word 0
msg1: .string "NUM1 = "
msg2: .string "\nNUM2 = "
msg3: .string "\nResultado = "

	.text

main:
    la a0, NUM1
    la a1, NUM2

    call MUL_REF

    la t0, RES
    sw a2, 0(t0)

    # Mostrar NUM1
    li a7, 4
    la a0, msg1
    ecall

    li a7, 1
    la t0, NUM1
    lw a0, 0(t0)
    ecall

    # Mostrar NUM2
    li a7, 4
    la a0, msg2
    ecall

    li a7, 1
    la t0, NUM2
    lw a0, 0(t0)
    ecall

    # Mostrar resultado
    li a7, 4
    la a0, msg3
    ecall

    li a7, 1
    mv a0, a2
    ecall

    li a7, 10
    ecall

# SUBRUTINA MUL_REF (por referencia, osea la direccion de los valores)
MUL_REF:
    lw t0, 0(a0)
    lw t1, 0(a1)
    mul a2, t0, t1
    ret
