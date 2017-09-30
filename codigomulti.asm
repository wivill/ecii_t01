.include "beta.uasm"

// A little cache benchmarking program: adds N words from
// array A, then repeats.  The starting addresses for the
// program and the array A are set by the I and A symbols
// below.

. = 0
  BR(test)        // branch to the start of the benchmark

I = 0x10000        // location of benchmark program
A = 0x004        // starting address of array A
B = 0x1004
C = 0x2004
N = 1024           // size of data region (in words)
M = 32

. = I            // start benchmark program here
test:
  CMOVE(N,R0)    // R0 = 9 -> Limite
  CMOVE(0,R2)	// Contador i

load:            // add up elements in array
  SUBC(R2, N, R5) // R5 = 9 - R2 => 9 - i
  BEQ(R5, EndLoad) // R5=0 => EndLoad
  MULC(R2,4,R3) // R3 = 4*R2 => 4*i
  ST(R2,A,R3)  // A[4*i] = R2
  ST(R3,B,R3)  //B[4*i] = R3
  ADDC(R2, 1, R2) // i+1
  BR(load) // PC = load

EndLoad:

Multiplicar:
	CMOVE(M,R0)    // R0 = 3 -> Limite
	CMOVE(0,R1)    // R1 = i
	CMOVE(0,R2)    // R2 = j
	CMOVE(0,R3)    // R3 = k

loop1:
	SUBC(R1, M, R6) // R6 = 3 - i
  BEQ(R6, test) // R6=0 => PC = loop3
	SUBC(R3, M, R6) // R6 = 3 - k
  BEQ(R6, loop3) // R6=0 => PC = loop3
	SUBC(R2, M, R6) // R6 = 3 - j
  BEQ(R6, loop2) // R6=0 => PC = loop2
	MULC(R1,M,R4) //R4 = 3*R1 => 3*i
	MULC(R2,M,R5) //R5 = 3*R2 => 3*j
	ADD(R2,R4,R4) // R4 = R2 + 3*R1 => j+3*i
	ADD(R3,R5,R5) // R5 = R1 + 3*R2 => k+3*j
	MULC(R4,4,R4) // R4 = 4*R4
	MULC(R5,4,R5) // R5 = 4*R5
	LD(R4,A,R7) // R7 = A[R4]
	LD(R5,B,R8) // R8 = B[R5]
	MUL(R7,R8,R9) // R9 = A[R4]*B[R5]
	ADD(R9,R10,R10) //R10=R10+R9
	ADDC(R2, 1, R2) //j+1
	BR(loop1)


loop2:
	MULC(R1,M,R4) //R4 = 3*R1 => 3*i
	ADD(R3,R4,R4) //R4 = k + 3*i
	MULC(R4,4,R4) // R4 = 4*R4
	ST(R10,C,R4) // C[R4] = R10
	CMOVE(0,R10)    // j = 0
	CMOVE(0,R2)    // j = 0
	ADDC(R3, 1, R3) //k+1
	BR(loop1)

loop3:
	CMOVE(0,R2) // j=0
	CMOVE(0,R3) // k=0
	ADDC(R1, 1, R1) //i+1
	BR(loop1)

EndLoops:


  BR(test)       // perform test again!

// allocate space to hold array
//. = A
  STORAGE(N)     // N words
