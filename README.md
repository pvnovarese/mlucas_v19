# mlucas_v19

This repo is for building docker images for Ernst Mayer's mlucas code.

See https://www.mersenneforum.org/mayer/README.html

build script will build an image for aarch64 (armv8) using the pre-built binaries, and will build x86_64 image from source (I can't get the build from source to work correctly on arm yet)

the container is based on debian:stable-slim

the entrypoint script will look at /proc/cpuinfo and run the appropriate binary depending on what extensions are available on the available CPUs (on intel it looks for various AVX versions or SSE, on aarch64 it looks for asimd)

I recommend running the container with /tmp on your host (or some other directory that is writable by user "nobody" bind mounted to /tmp so you can easily save your mlucas.cfg file etc.
