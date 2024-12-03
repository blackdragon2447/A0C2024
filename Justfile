build: build-day1

build-day1:
	riscv64-none-elf-clang -E day1/part1.S -o day1/build/part1.tmp.S
	riscv64-none-elf-as day1/build/part1.tmp.S -o day1/build/part1.o -g
	riscv64-none-elf-ld day1/build/part1.o -o day1/build/part1

	riscv64-none-elf-clang -E day1/part2.S -o day1/build/part2.tmp.S
	riscv64-none-elf-as day1/build/part2.tmp.S -o day1/build/part2.o -g
	riscv64-none-elf-ld day1/build/part2.o -o day1/build/part2

run-day1-1: build-day1
	qemu-riscv64 day1/build/part1

run-day1-2: build-day1
	qemu-riscv64 day1/build/part2

build-day2:
	riscv64-none-elf-clang -E day2/part1.S -o day2/build/part1.tmp.S
	riscv64-none-elf-as day2/build/part1.tmp.S -o day2/build/part1.o -g
	riscv64-none-elf-ld day2/build/part1.o -o day2/build/part1

	riscv64-none-elf-clang -E day2/part2.S -o day2/build/part2.tmp.S
	riscv64-none-elf-as day2/build/part2.tmp.S -o day2/build/part2.o -g
	riscv64-none-elf-ld day2/build/part2.o -o day2/build/part2

run-day2-1: build-day2
	qemu-riscv64 day2/build/part1

run-day2-2: build-day2
	qemu-riscv64 day2/build/part2
