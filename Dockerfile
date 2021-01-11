ARG ARCH=
FROM debian:stable-slim AS builder

COPY mlucas_v19.txz /mlucas_v19.txz
RUN apt update && apt-get install -y xz-utils gcc bash && tar xJf /mlucas_v19.txz && mkdir /mlucas_v19/obj
WORKDIR /mlucas_v19/obj
COPY build_script* ./
# we'll run the build script based on uname -m (though I 
# need to update this to just have one big script and pass 
# the arch target as an argument
RUN ./build_script_$(uname -m).sh

# final stage
FROM debian:stable-slim

MAINTAINER Paul Novarese pvn@novarese.net
LABEL maintainer="pvn@novarese.net"
LABEL name="mlucas"
LABEL org.opencontainers.image.title="mlucas"
LABEL org.opencontainers.image.source="https://www.mersenneforum.org/mayer/README.html"
LABEL org.opencontainers.image.description="Code written by Ernst Mayer \
 \
https://www.mersenneforum.org/mayer/README.html \
https://github.com/pvnovarese/mlucas_v19 \
 \
Usage: docker run pvnovarese/mlucas \
default option is '-s m' which will run a single-threaded self-test and dump a mlucas.cfg \
file in /tmp (so you may want to bind mount here)." 

COPY --from=builder /mlucas_v19/obj/Mlucas /usr/local/bin/Mlucas
HEALTHCHECK NONE
USER nobody
WORKDIR /tmp
CMD ["-s", "m"]
ENTRYPOINT ["/usr/local/bin/Mlucas"]
