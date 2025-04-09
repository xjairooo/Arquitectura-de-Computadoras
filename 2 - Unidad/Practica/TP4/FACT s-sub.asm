	.data
msg: .string "Ingrese un numero: "
res: .string "El factorial es: "

	.text
main:
    # Mostrar mensaje
    li a7, 4
    la a0, msg
    ecall

    # Leer número
    li a7, 5
    ecall
    mv t0, a0         # n

    li t1, 1          # factorial = 1
    li t2, 1          # i = 1

fact:
	# -- realiza fact --
    bgt t2, t0, fin
    mul t1, t1, t2
    addi t2, t2, 1
    j fact

fin:
    # Mostrar resultado
    li a7, 4
    la a0, res
    ecall
	
	# -- Imprime resultado --
    mv a0, t1
    li a7, 1
    ecall

    li a7, 10
    ecall
