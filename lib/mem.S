#pragma once

.equ PROT_NONE, 0
.equ PROT_READ, 1
.equ PROT_WRITE, 2
.equ PROT_EXEC, 4

.equ MAP_PRIVATE, 0x0002
.equ MAP_ANON, 0x0020

# allocate a chunk of memory
# a0: requested size
# ret(a0): ptr to memory
alloc:
	mv a1, a0
	li a0, 0
	ori a2, zero, PROT_READ
	ori a2, a2, PROT_WRITE
	ori a3, zero, MAP_PRIVATE
	ori a3, a3, MAP_ANON
	li a7, 222
	ecall
	ret

# deallocate a chunk of memory
# a0: ptr
# a1: size
# ret(a0): error (0 on success)
dealloc:
	li a7, 215
	ecall
	ret
	
# copy num bytes from src to dest
# a0: dest
# a1: src
# a2: num
memcpy:
	li t0, 0
memcpy_loop:
	lb t1, (a1)
	sb t1, (a0)
	addi t0, t0, 1
	addi a1, a1, 1
	addi a0, a0, 1
	blt t0, a2, memcpy_loop
	ret

# swap usize in src and dest
# a0: src
# a1: dest
swap:
	ld t0, (a0)
	ld t1, (a1)
	sd t1, (a0)
	sd t0, (a1)
	ret
