# tipica suma que se suman direcciones

	.data
A: .word 150
B: .word 270

	.text
main:
	la t0, A
	la t1, B
	
	lw s0, 0(t0)
	lw s1, 0(t1)
	
	add a0, s0, s1
	li a7, 1
	ecall
	
	li a7, 10
	ecall
	