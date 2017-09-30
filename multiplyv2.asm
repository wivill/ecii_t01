.include "beta.uasm"

// A little cache benchmarking program: adds N words from
// array A, then repeats.  The starting addresses for the
// program and the array A are set by the I and A symbols
// below.

. = 0
  BR(test)        // branch to the start of the benchmark

I = 0x20000        // location of benchmark program
A = 0x440        // starting address of matrix A
N = 16           // size of data region (in words)
NN = N*N
B = A + NN      // starting address of matrix B ([NxN] + Addr_A)
C = B + NN    // starting address of matrix C (Result matrix)
. = I            // start benchmark program here
test:
  CMOVE(NN-1,R0)    // index i
  CMOVE(NN-1,R1)    // index j
  CMOVE(NN-1,R2)    // index k
  CMOVE(NN-1,R3)    // index l
  CMOVE(N-1,R4)   // Counter
  CMOVE(N-1,R5)   // Counter
  CMOVE(0,R6)    // index result
  CMOVE(0,R7)    // C matrix index
  CMOVE(0,R8)   // Offset address container
  CMOVE(0,R9)   // Offset address container
  CMOVE(0,R10)  // Offset address container
  CMOVE(0,R11)  // Offset address container
  CMOVE(0,R12)  // Offset address container
  CMOVE(0,R13)  // Value in A
  CMOVE(0,R14)  // Value in B
  CMOVE(0,R15)  // Data to store
  CMOVE(NN-1,R16) // fill counter

fill: // literally fill matrix with data
  ST(R13,A,R0)
  ST(R14,B,R0)
  ST(R15,C,R0)
  SUBC(R16,1,R16)
  BEQ(R16,multi)
  BR(fill)

multi: // begins multiplication process. Offsets addresses
  MULC(R0,4,R8)
  MULC(R1,4,R9)
  MULC(R2,4,R10)
  MULC(R3,4,R11)
  MULC(R7,4,R12)
load: // Loads data from matrixes and multiplies it
  LD(R8,A,R13)
  LD(R10,B,R14)
  MUL(R13,R14,R6)
  ADD(R6,R15,R15)
  SUBC(R4,1,R4)
  BEQ(R4,store)
  SUBC(R8,4,R8) // offset i - 4 (column A)
  SUBC(R10,4*N,R10) // offset j - N*4 (row B)
  BR(load)
store:
  ST(R15,C,R7)
  SUBC(R7,1,R7)
  SUBC(R0,1,R0)
  SUBC(R1,1,R1)
  SUBC(R2,1,R2)
  SUBC(R3,1,R3)
  SUBC(R5,1,R5)
  CMOVE(N-1,R4)
  BEQ(R5,test)
  BR(multi)
  //BR(test)

// allocate space to hold array
//. = A
  STORAGE(12*NN)     // N words
//. = B
//  STORAGE(NN)
//. = C
//  STORAGE(NN)
