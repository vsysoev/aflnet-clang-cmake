FROM ubuntu:focal
LABEL org.opencontainers.image.source=https://github.com/vsysoev/aflnet-clang-cmake

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt full-upgrade -y
RUN apt -y install --no-install-suggests --no-install-recommends \
    cmake gcc g++
RUN apt -y install --no-install-suggests --no-install-recommends \
    clang-12 llvm-12 llvm-12-dev
RUN apt -y install --no-install-suggests --no-install-recommends \
    git make

RUN apt -y install --no-install-suggests --no-install-recommends \
    graphviz-dev libcap-dev

WORKDIR /home
RUN git config --global http.sslverify false
RUN git clone https://github.com/aflnet/aflnet.git aflnet-src

WORKDIR /home/aflnet-src
RUN make clean all

ARG LLVM_CONFIG=/usr/lib/llvm-12/bin/llvm-config
ARG CC=/usr/lib/llvm-12/bin/clang
ARG CXX=/usr/lib/llvm-12/bin/clang++
ARG PATH=$PATH:/usr/lib/llvm-12/bin
ARG PREFIX=/home/aflnet
RUN cd llvm_mode && make
RUN PATH=$PATH:/usr/lib/llvm-12/bin make install
