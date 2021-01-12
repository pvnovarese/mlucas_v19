#!/bin/bash

echo "DEBUG: pwd is " ${PWD}

ARCH=$(uname -m)
echo "DEBUG: arch detected: "${ARCH}

echo "DEBUG: copy entrypoint"
cp /mlucas_v19_entrypoint.sh /usr/local/bin/mlucas_v19_entrypoint.sh

if [ ${ARCH} == "x86_64" ]; then
    echo "DEBUG: building "${ARCH}
    tar xJf /mlucas_v19.txz
    mkdir /mlucas_v19/obj
    cd /mlucas_v19/obj

    #build sse2
    gcc -c -O3 -DUSE_SSE2 -DUSE_THREADS ../src/*.c
    gcc -o mlucas-sse2 *.o -lm -lpthread -lrt
    cp mlucas-sse2 /usr/local/bin/mlucas-sse2
    rm *.o

    #build avx
    gcc -c -O3 -DUSE_AVX -mavx -DUSE_THREADS ../src/*.c
    gcc -o mlucas-avx *.o -lm -lpthread -lrt
    cp mlucas-avx /usr/local/bin/mlucas-avx
    rm *.o

    #build avx2
    gcc -c -O3 -DUSE_AVX2 -mavx2 -DUSE_THREADS ../src/*.c
    gcc -o mlucas-avx2 *.o -lm -lpthread -lrt
    cp mlucas-avx2 /usr/local/bin/mlucas-avx2
    rm *.o

    #build avx512-skylake
    gcc -c -O3 -DUSE_AVX512 -march=skylake-avx512 -DUSE_THREADS ../src/*.c
    gcc -o mlucas-avx512 *.o -lm -lpthread -lrt
    cp mlucas-avx512 /usr/local/bin/mlucas-avx512
    rm *.o

    #build avx512-knl
    #I've got this commented out since I don't have any access to
    #intel phi hardware, but it ... should work?
    #gcc -c -O3 -DUSE_AVX512 -march=knl -DUSE_THREADS ../src/*.c
    #gcc -o mlucas-avx512-knl *.o -lm -lpthread -lrt
    #cp mlucas-avx512-knl /usr/local/bin/mlucas-avx512-knl
    #rm *.o

    cp /mlucas_v19/src/primenet.py /usr/local/bin/primenet.py
else
    if [ ${ARCH} == "aarch64" ]; then
        # building arm is problematic so I'm just using ernst's
        # precompiled binaries, but if I were going to actual build
        # we would do something like this:
        # gcc -c -O3 -DUSE_ARM_V8_SIMD -DUSE_THREADS ../src/*.c
        # gcc -o Mlucas *.o -lm -lpthread -lrt
        # instead, we'll just unpack the txz files and move these
        # binaries into position
        echo "DEBUG: building "${ARCH}
        tar xJf /mlucas_v19_c2simd.txz
        tar xJf /mlucas_v19_nosimd.txz
        cp /mlucas_v19_nosimd /usr/local/bin/mlucas-nosimd
        cp /mlucas_v19_c2simd /usr/local/bin/mlucas-c2simd
        cp /primenet.py /usr/local/bin/primenet.py
    fi
fi





