# Vec:
# void*: data
# usize: size
# usize: capacity

# creates a new vector, the vector is represented by a 24 
# byte fat pointer and is returned on the stack 
# the vector always is a vector of doublewords
new_vec:
	addi sp, sp, -32
	sd ra, 0(sp)

	li a0, 4 # initial capacity
	call alloc
	sd a0, 24(sp) # data ptr
	sd zero, 16(sp) # size
	li t0, 4
	sd t0, 8(sp) # capacity

	ld ra, 0(sp)
	addi sp, sp, 8
	ret

# Pushes an element to the end of the vec
# a0: ptr to the vec
# a1: byte to push
push_vec:
	addi sp, sp, -40
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32(sp)

	mv s3, a0

	ld t0, 0(s3) # capacity
	ld s1, 8(s3) # size
	ld s2, 16(s3) # data
	bne t0, s1, push_vec_push
	mv s0, a1
	li a1, 4
	call expand_vec
	# reload here since expand_vec changed things
	ld s2, 16(s3) # data
	mv a1, s0

push_vec_push:
	li t1, 8
	mul t1, t1, s1
	add t0, t1, s2
	sd a1, (t0)
	addi s1, s1, 1
	sd s1, 8(s3)

	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	addi sp, sp, 40
	ret

# returns a 1 if the vec is empty, 0 otherwise
# a0: ptr to the vec
empty_vec:
	ld t0, 8(a0) # size
	beqz t0, empty_vec_pass
	li a0, 0
	ret
empty_vec_pass:
	li a0, 1
	ret

# Pops an element off of the end of the vec
# a0: ptr to the vec
pop_vec:
	ld t0, 8(a0) # size
	addi t0, t0, -1
	sd t0, 8(a0) # size

	li t1, 8
	mul t0, t0, t1 # offset of element
	ld t1, 16(a0) # data
	add t0, t0, t1
	ld a0, 0(t0)
	ret

# increases the capacity of a vec by cap 
# a0: ptr to the vec
# a1: cap
expand_vec:
	addi sp, sp, -32
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)

	ld t0, 0(a0) # capacity
	ld s2, 8(a0) # size
	ld s1, 16(a0) # data

	mv s0, a0		# save the ptr to the vec
	add a0, t0, a1	# calculate new capacity
	sw a0, 0(s0)	# save the new capacity
	li t1, 8		# num bytes is 8*cap
	mul a0, a0, t1	#
	call alloc		# allocate new buffer
	sw a0, 16(s0)	# store the new data pointer

	mv a1, s1		# data ptr is src
	li t1, 8		# num bytes is 8*size
	mul s2, s2, t1	#
	mv a2, s2
	call memcpy		# copy buffer

	mv a0, s1		# deallocate old buffer
	mv a1, s2		#
	call dealloc	# 

	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	addi sp, sp, 32
	ret

# sort a vec, smallest to largest
# a0: the vec
# # a1: index of highest already sorted element
sort_vec:
	addi sp, sp, -48
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32(sp)
	sd s4, 40(sp)

	mv s0, a0
	# mv s1, a1

	ld s1, 8(s0) # size
	ld s2, 16(s0) # data

	li s3, 1 # outer loop index
sort_vec_outer:

	mv s4, s3 # inner loop counter
sort_vec_inner:
	li t0, 8		# width of element
	mul t0, t0, s4	# offset of element
	add t0, t0, s2	# addr of element
	ld t1, 0(t0)	# load elements
	ld t2, -8(t0)

	bge t1, t2, sort_vec_outer_cont
	mv a0, t0
	call sort_vec_swap

sort_vec_inner_cont:
	addi s4, s4, -1
	blt zero, s4, sort_vec_inner

sort_vec_outer_cont:
	addi s3, s3, 1
	blt s3, s1, sort_vec_outer

sort_vec_end:
	ld ra, 0(sp)
	ld s0, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	ld s4, 40(sp)
	addi sp, sp, 48
	ret

sort_vec_swap:
	ld t0, 0(a0)
	ld t1, -8(a0)
	sd t1, 0(a0)
	sd t0, -8(a0)
	ret
