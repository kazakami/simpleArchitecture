#Makefile
all:ALU_test.out Memory_test.out MUX_test.out

vcd: aluTest.vcd Memory.vcd muxTest.vcd

aluTest.vcd: ALU_test.out
	vvp ALU_test.out
Memory.vcd: Memory_test.out
	vvp Memory_test.out
muxTest.vcd: MUX_test.out
	vvp MUX_test.out

ALU_test.out: src/ALU.v test/ALUTest.v
	iverilog -o ALU_test.out -s ALUTEST src/ALU.v test/ALUTest.v
Memory_test.out: src/Memory.v test/MemoryTest.v
	iverilog -o Memory_test.out -s MEMORYTEST src/Memory.v test/MemoryTest.v
MUX_test.out: src/MUX.v test/MUXTest.v
	iverilog -o MUX_test.out -s MUXTEST src/MUX.v test/MUXTest.v



clean:
	rm -f *.out *.vcd
