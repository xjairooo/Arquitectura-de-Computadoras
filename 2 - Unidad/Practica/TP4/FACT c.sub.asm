	.data
msg: .string "Ingrese un numero: "
res: .string "El factorial es: "

	.text

main:
    # Mostrar mensaje
    li a7, 4
    la a0, msg
    ecall

    # Leer numero (resultado queda en a0)
    li a7, 5
    ecall
    mv a1, a0        # Guardar el valor leido en a1 (n)

    mv a0, a1        # Pasar n como argumento a FACT
    call FACT        # Resultado se devuelve en a0

    mv a1, a0        # Guardar resultado para impresion

    # Mostrar mensaje
    li a7, 4
    la a0, res
    ecall

    # Mostrar resultado (a1)
    mv a0, a1
    li a7, 1
    ecall

    li a7, 10
    ecall

# ------------------------
# SUBRUTINA FACT
# Entrada: a0 = n
# Salida: a0 = n!
# ------------------------
FACT:
    li t0, 1          # i = 1
    li t1, 1          # factorial = 1
loop_fact:
    bgt t0, a0, end_fact
    mul t1, t1, t0
    addi t0, t0, 1
    j loop_fact
end_fact:
    mv a0, t1         # devolver resultado en a0
    ret
