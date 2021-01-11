ARG ARCH=
FROM debian:stable-slim AS builder

#COPY mlucas_v19/obj/Mlucas /usr/local/bin/Mlucas
COPY mlucas_v19.txz /mlucas_v19.txz
RUN apt update && apt-get install -y xz-utils gcc bash && tar xJf /mlucas_v19.txz && mkdir /mlucas_v19/obj
WORKDIR /mlucas_v19/obj
COPY build_script* ./
#RUN gcc -c -O3 -DUSE_AVX2 -DUSE_THREADS ../src/*.c && gcc -o Mlucas *.o -lm -lpthread -lrt 
RUN ./build_script_$(uname -m).sh

FROM debian:stable-slim

MAINTAINER Paul Novarese pvn@novarese.net
LABEL maintainer="pvn@novarese.net"
LABEL name="mlucas"
LABEL org.opencontainers.image.title="mlucas"
LABEL org.opencontainers.image.source="https://www.mersenneforum.org/mayer/README.html"
LABEL org.opencontainers.image.description="Code written by Ernst Mayer \
 \
https://www.mersenneforum.org/mayer/README.html\
 \
Usage: docker run pvnovarese/mlucas" 

COPY --from=builder /mlucas_v19/obj/Mlucas /usr/local/bin/Mlucas
HEALTHCHECK NONE
USER nobody
WORKDIR /tmp
CMD ["-s", "m"]
ENTRYPOINT ["/usr/local/bin/Mlucas"]
