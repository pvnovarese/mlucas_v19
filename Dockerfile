ARG ARCH=
FROM debian:stable-slim AS builder

COPY mlucas_v19* /
RUN apt update && apt-get install -y xz-utils gcc
WORKDIR /
RUN /mlucas_v19_build_script.sh

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

COPY --from=builder /usr/local/bin/* /usr/local/bin/
HEALTHCHECK NONE
USER nobody
WORKDIR /tmp
CMD ["-s", "m"]
ENTRYPOINT ["/usr/local/bin/mlucas_v19_entrypoint.sh"]
