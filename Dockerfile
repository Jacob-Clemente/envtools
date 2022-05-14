# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y gcc

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libjpeg-dev

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libpng-dev

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libtiff-dev

## Add source code to the build stage.
ADD . /envtools
WORKDIR /envtools

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN gcc envremap.c -ltiff -ljpeg -lpng -lz -lm -o envremap

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /envtools/envremap /
COPY --from=builder /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.5
COPY --from=builder /usr/lib/x86_64-linux-gnu/libwebp.so.6 /usr/lib/x86_64-linux-gnu/libwebp.so.6
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjbig.so.0 /usr/lib/x86_64-linux-gnu/libjbig.so.0
COPY --from=builder /usr/lib/x86_64-linux-gnu/libjpeg.so.8 /usr/lib/x86_64-linux-gnu/libjpeg.so.8


