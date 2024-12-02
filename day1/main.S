#include "../lib/lib.S"

.text
.global _start

_start:

	call new_vec # list 0
	call new_vec # list 1

	li a0, 128
	call alloc
	mv s0, a0

main_read_loop:

	mv a0, s0
	li a1, 128
	call read_line

	beqz a0, main_read_loop_done

	mv a1, a0
	mv a0, s0
	call split_line 
	mv s1, a0

	mv a0, s0
	li a1, 5
	call parse_usize
	mv a1, a0
	addi a0, sp, 24
	call push_vec

	mv a0, s1
	li a1, 5
	call parse_usize
	mv a1, a0
	addi a0, sp, 0
	call push_vec

	j main_read_loop

main_read_loop_done:

	addi a0, sp, 24
	li a1, 0
	call sort_vec

	li a1, 0
	addi a0, sp, 0
	call sort_vec

	li s5, 0

main_sub_loop:
	addi a0, sp, 24
	call empty_vec
	mv s0, a0

	addi a0, sp, 0
	call empty_vec
	mv s1, a0

	and t0, s0, s1
	
	bnez t0, main_sub_loop_done

	addi a0, sp, 24
	call pop_vec
	mv s0, a0

	addi a0, sp, 0
	call pop_vec
	mv s1, a0

	blt s1, s0, main_sub_left
	j main_sub_right

main_sub_left:
	sub t1, s0, s1
	j main_dist_push

main_sub_right:
	sub t1, s1, s0
	j main_dist_push

main_dist_push:
	add s5, s5, t1

	j main_sub_loop

main_sub_loop_done:

	mv a0, s5
	call print_usize

	li a0, 0
	call exit




# split a line on "   ", if str is null terminated, then so is str2 
# str1 always is
# a0: str ptr
# a1: str len
# ret(a0): str2 start
split_line:
	li t0, 0	# loop counter
	li t1, 0	# space counter
	li t4, 32	# space char
	li t5, 3	# expected nr of spaces
	mv t2, a0	# addr of str
split_line_loop:
	lb t3, 0(t2)
	bne t3, t4, split_line_cont
	addi t1, t1, 1
	beq t1, t5, split_line_end
	beq t0, a1, split_line_fail
split_line_cont:
	addi t0, t0, 1
	addi t2, t2, 1
	j split_line_loop
split_line_fail:
	li a0, -1
	ret
split_line_end:
	addi a0, t2, 1
	ret

.data
hello_world:
	.string "Hello AoC!\0"
sep:
	.string "##########\0"
