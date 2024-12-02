build: build-day1

build-day1:
	mkdir day1/build
	riscv64-none-elf-clang -E day1/main.S -o day1/build/main.tmp.S
	riscv64-none-elf-as day1/build/main.tmp.S -o day1/build/main.o -g
	riscv64-none-elf-ld day1/build/main.o -o day1/build/main

run-day1: build-day1
	qemu-riscv64 day1/build/main
