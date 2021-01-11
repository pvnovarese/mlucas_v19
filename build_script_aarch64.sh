#!/bin/sh
#gcc -c -O3 -DUSE_SSE2 -DUSE_THREADS ../src/*.c
#gcc -c -O3 -DUSE_AVX -mavx -DUSE_THREADS ../src/*.c
#gcc -c -O3 -DUSE_AVX2 -mavx2 -DUSE_THREADS ../src/*.c
#gcc -c -O3 -DUSE_AVX512 -DUSE_THREADS ../src/*.c
gcc -c -O3 -DUSE_ARM_V8_SIMD -DUSE_THREADS ../src/*.c

gcc -o Mlucas *.o -lm -lpthread -lrt
