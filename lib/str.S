#pragma once

# split a string on the selected char,
# the split happenes in place
# a0: str prt
# a1: str len
# a2: split char
splitstr:
	mv t1, a0
	li t0, 0
splitstr_loop:
	lb t2, 0(t1)
	bne t2, a2, splitstr_cont
	sb zero, 0(t1)
splitstr_cont:
	addi t0, t0, 1
	addi t1, t1, 1
	bne t0, a1, splitstr_loop
	ret

# get the length of a null terminated string, excl terminator
# a0: str ptr
strlen:
	mv t1, a0
strlen_loop:
	lb t2, 0(t1)
	beq t2, zero, strlen_end
	addi t1, t1, 1
	j strlen_loop
strlen_end:
	sub a0, t1, a0
	ret

# parse a usize out of a str
# a0: str ptr
# a1: str len
parse_usize:
	addi a1, a1, -1	# len
	li t2, 0		# result
	li t3, 1		# magnitude
	li t5, 10		# base
	li t6, 48		# lower bound
	li t1, 58		# upper bound
parse_usize_loop:
	# take the least significant unparsed digit
	add t0, a0, a1	
	lb t4, (t0)
	# check that it is a num, otherwise skip
	blt t4, t6, parse_usize_tail
	bge t4, t1, parse_usize_tail
	# turn it from the char repr into an actual num
	addi t4, t4, -48

	mul t4, t4, t3	# give right magnitude
	add t2, t2, t4	# add to result
	mul t3, t3, t5	# increase magnitude
parse_usize_tail:
	addi a1, a1, -1	# Next digit
	bgez a1, parse_usize_loop
parse_usize_end:
	mv a0, t2
	ret

# print a usize
# a0: usize
print_usize:
	add sp, sp, -16
	sd ra, 0(sp)
	sd s0, 8(sp)

	mv s0, a0
	li a0, 20
	call alloc

	li t1, 19	# counter 
	li t3, 10	# base
print_usize_loop:
	rem t4, s0, t3
	div s0, s0, t3

	addi t4, t4, 48
	add t5, a0, t1
	sb t4,0(t5)

	addi t1, t1, -1

	beqz s0, print_usize_end
	bltz t1, print_usize_end
	j print_usize_loop
print_usize_end:
	
	addi t1, t1, 1
	add a0, a0, t1
	li t2, 20
	sub a1, t2, t1
	call println

	lw ra, 0(sp)
	ld s0, 8(sp)
	add sp, sp, 16
	ret

