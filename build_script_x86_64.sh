#!/bin/sh
#gcc -c -O3 -DUSE_SSE2 -DUSE_THREADS ../src/*.c
#gcc -c -O3 -DUSE_AVX -mavx -DUSE_THREADS ../src/*.c
gcc -c -O3 -DUSE_AVX2 -mavx2 -DUSE_THREADS ../src/*.c
#gcc -c -O3 -DUSE_AVX512 -march=skylake-avx512 -DUSE_THREADS ../src/*.c
#gcc -c -O3 -DUSE_AVX512 -march=knl -DUSE_THREADS ../src/*.c

gcc -o Mlucas *.o -lm -lpthread -lrt
