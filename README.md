# mlucas_v19

This repo is for building docker images for Ernst Mayer's mlucas code.

See https://www.mersenneforum.org/mayer/README.html

build scripts for arm32v7, arm64v8 (aarch64) and x86_64 are fairly straightforward, I should probably spend about 10 minutes to combine those into one script

for intel builds, please look at the build script and select the options that match your particular processor.  if you're not sure which one you should be using, note that Ernst's README has details.

the container is based on debian:stable-slim

I recommend running the container with /tmp on your host (or some other directory that is writable by user "nobody" bind mounted to /tmp so you can easily save your mlucas.cfg file etc.
