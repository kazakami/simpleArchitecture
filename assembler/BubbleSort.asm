LI [0] 0
LD [0] 0([0])
LI [1] 1
MOV [2] [1]
ADDI [2] 1
LD [3] 0([1])
LD [4] 0([2])
CMP [4] [3]
BLT 2
ST [4] 0([1])
ST [3] 0([2])
ADDI [1] 1
CMP [1] [0]
BLT -12
B [0] -13
