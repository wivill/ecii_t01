.include "beta.uasm"

// A little cache benchmarking program: adds N words from
// array A, then repeats.  The starting addresses for the
// program and the array A are set by the I and A symbols
// below.

. = 0
  BR(test)        // branch to the start of the benchmark

I = 0x200        // location of benchmark program
A = 0x440        // starting address of matrix A
N = 16           // size of data region (in words)
NN = N*N
B = 4*NN + A       // starting address of matrix B ([NxN] + Addr_A)
C = 4*NN + B      // starting address of matrix C (Result matrix)
. = I            // start benchmark program here
test:
  CMOVE(NN-1,R0)    // index i
  CMOVE(NN-1,R1)    // index j
  CMOVE(NN-1,R2)    // index k
  CMOVE(NN-1,R3)    // index l
  CMOVE(N,R4)   // Counter
  CMOVE(N,R5)   // Counter
  CMOVE(0,R6)    // index result
  CMOVE(0,R7)    // C matrix index
  CMOVE(0,R8)   // Offset address container
  CMOVE(0,R9)   // Offset address container
  CMOVE(0,R10)  // Offset address container
  CMOVE(0,R11)  // Offset address container
  CMOVE(0,R12)  // Offset address container
  CMOVE(0,R13)  // Value in A
  CMOVE(0,R14)  // Value in B
multi:
  MULC(R0,4,R8)
  MULC(R1,4,R9)
  MULC(R2,4,R10)
  MULC(R3,4,R11)
  MULC(R7,4,R12)
load:
  LD(R8,A,R13)
  LD(R10,B,R14)
  MUL(R13,R14,R6)
store:
  ST(R6,C,R7)


  BR(test)

// allocate space to hold array
. = A
  STORAGE(4*NN)     // N words
//. = B
//  STORAGE(NN)
//. = C
//  STORAGE(NN)
