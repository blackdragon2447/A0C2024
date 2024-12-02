#pragma once

#include "./str.S"
#include "./mem.S"
#include "./vec.S"

.equ STDIN,		0
.equ STDOUT,	1
.equ STDERR,	2

# print a string to the screen
# a0: string_ptr
# a1: string_len
print:
	mv a2, a1
	mv a1, a0
	li a0, STDOUT
	li a7, 64
	ecall
	ret

# print a string to the screen and appends a newline
# a0: string_ptr
# a1: string_len
println:
	addi sp, sp, -16
	sd ra, 8(sp)

	call print

	la t0, 10
	sd t0, (sp)
	mv a0, sp
	li a1, 1
	call print

	ld ra, 8(sp)
	addi sp, sp, 16
	ret

# read from stdin into a buffer
# a0: buf ptr
# a1: buf len
# ret(a0): nr of bytes read
read_in:
	mv a2, a1
	mv a1, a0
	li a0, STDIN
	li a7, 63
	ecall
	ret

# read a line from stdin into a buffer
# a0: buf ptr
# a1: buf len
# ret(a0): nr of bytes read
read_line:
	addi sp, sp, -40
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32(sp)

	mv s0, a0
	mv s1, a1
	li s2, 0	# nr of bytes read

read_line_loop:
	mv a0, s0
	li a1, 1
	call read_in
	beqz a0, read_line_end
	lb t1, 0(s0)
	li t2, 10
	beq t1, t2, read_line_end
	addi s2, s2, 1
	addi s0, s0, 1
	j read_line_loop

read_line_end:

	mv a0, s2

	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	addi sp, sp, 40
	ret

# exit the program
# a0: exit code
exit:
	li a7, 93
	ecall

