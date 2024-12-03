#include "../lib/lib.S"

.text
.global _start

_start:

	li a0, 128
	call alloc

	addi sp, sp, -8
	sd a0, 0(sp)

	li s3, 0 # safe count

read_loop:

	call new_vec

	ld s0, 24(sp)
	mv a0, s0
	li a1, 128
	call read_line

	beqz a0, main_end

	mv a1, a0
	mv a0, s0
	li a2, 32
	call splitstr

parse_num_loop:
	mv a0, s0
	call strlen
	mv s1, a0

	add t0, s0, s1
	addi t0, t0, -1
	li t1, 10
	lb t2, (t0)
	beq t1, t2, parse_num_loop_tail

	mv a0, s0
	mv a1, s1
	call parse_usize

	mv a1, a0
	mv a0, sp
	call push_vec

	add s0, s0, s1
	addi s0, s0, 1

	j parse_num_loop

parse_num_loop_tail:
	mv a0, s0
	mv a1, s1
	addi a1, a1, -1
	call parse_usize

	mv a1, a0
	mv a0, sp
	call push_vec

	li t0, 0
	li t1, 1
	li t2, 3

	ld s0, 8(sp)	# size
	ld s1, 16(sp)	# data
	li s2, 1		# index

	addi s1, s1, 8
	ld t3, -8(s1)
	ld t4, 0(s1)
	blt t3, t4, check_lt
	blt t4, t3, check_gt
	j check_loop_fail
check_lt:
	li t0, 1
	sub t4, t4, t3
	blt t4, t1, check_loop_fail
	blt t2, t4, check_loop_fail

	addi s2, s2, 1
	j check_loop
check_gt:
	li t0, 0
	sub t4, t3, t4
	blt t4, t1, check_loop_fail
	blt t2, t4, check_loop_fail

	addi s2, s2, 1
	j check_loop
check_loop:
	addi s1, s1, 8
	ld t3, -8(s1)
	ld t4, 0(s1)
	bnez t0, check_loop_lt
	j check_loop_gt
check_loop_lt:
	sub t4, t4, t3
	blt t4, t1, check_loop_fail
	blt t2, t4, check_loop_fail
	j check_loop_tail

check_loop_gt:
	sub t4, t3, t4
	blt t4, t1, check_loop_fail
	blt t2, t4, check_loop_fail
	j check_loop_tail

check_loop_tail:

	addi s2, s2, 1
	blt s2, s0, check_loop
	addi s3, s3, 1

check_loop_fail:

	mv a0, sp
	call drop_vec
	addi sp, sp, 24 # our vec is on the stack so we need to pop it, as 
					# drop vec only deallocates the vecs buffer

	j read_loop

main_end:

	mv a0, s3
	call print_usize

	li a0, 0
	call exit
