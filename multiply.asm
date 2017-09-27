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
B = 4*NN + A        // starting address of matrix B ([NxN] + Addr_A)
C = 4*NN + B        // starting address of matrix C (Result matrix)
. = I            // start benchmark program here
test:
  CMOVE(N,R0)    // initialize outloop index i
  CMOVE(N,R1)    // inner_loop index j
  CMOVE(0,R2)    // temporary result containers
  CMOVE(0,R7)    // mult Result
  CMOVE(0,R8)    // A final index
  CMOVE(0,R9)    // B final index
  CMOVE(N,R10)   // Last row index
  CMOVE(N,R11)   // Last column index
                 // R3 and R5 contain values in A and B, respectively
                 // R4 and R6 contain addresses converted to byte offset
  MUL(R0,R1,R12) // R12 contains full size of C result matrix
  SUBC(R12,1,R12)
  SUBC(R0,1,R0)
  SUBC(R1,1,R1)

loop:
  MULC(R0,N,R8)
  MULC(R1,N,R9)
  ADD(R8,R10,R8)
  ADD(R9,R11,R9)
multi:
  MULC(R8,4,R4)
  MULC(R9,4,R6)
  LD(R4,A,R3)
  LD(R6,B,R5)
  MUL(R3,R5,R7)
store:
  ADD(R7,R2,R2)
  ST(R12,C,R2)
  SUBC(R11,1,R11)
  SUBC(R10,1,R10)
  SUBC(R8,1,R8)
  SUBC(R9,1,R9)
  BNE(R11,multi)
  SUBC(R0,1,R0)
  SUBC(R1,1,R1)
  BNE(R0,loop)
  SUBC(R12,1,R12)
  BNE(R12,loop)

  BR(test)

// allocate space to hold array
. = A
  STORAGE(4*NN)     // N words
//. = B
//  STORAGE(NN)
//. = C
//  STORAGE(NN)
