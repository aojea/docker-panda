FROM ubuntu:14.04
MAINTAINER Itsuugo <itsuugo@gmail.com>

RUN echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
RUN gpg --keyserver keys.gnupg.net --recv 886DDD89
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN apt-get update -qq &&\
    apt-get install -y build-essential &&\
    apt-get build-dep qemu &&\
    apt-get install -y \
    nasm \
    libssl-dev \
    libpacap-dev \
    subversion \
    curl \
    autoconf \
    libtool

RUN mkdir /panda
# Install LVM
RUN cd /panda; svn checkout http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_33/final/ llvm
RUN cd /panda/llvm/tools ; svn checkout http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_33/final/ clang
RUN cd /panda/llvm/tools/clang/tools ; svn checkout
http://llvm.org/svn/llvm-project/clang-tools-extra/tags/RELEASE_33/final/ extra
RUN cd /panda/llvm ; CC=gcc-4.7 CXX=g++-4.7 ./configure --enable-optimized --disable-assertions --enable-targets=x86 && REQUIRES_RTTI=1 make -j $(nproc)
# Install Distorm
RUN cd /panda ; svn checkout http://distorm.googlecode.com/svn/trunk/ distorm
RUN cd /panda/distorm/make/linux ; make && make install
RUN cd /panda/distorm/include ; cp * /usr/local/include
# Install Protocol buffers C style
RUN mkdir /software
RUN cd /software ; git clone https://github.com/google/protobuf.git
RUN cd /software/protobuf ; sh ./autogen.sh && ./configure --disable-shared && make && make install
RUN cd /software ; git clone https://github.com/protobuf-c/protobuf-c.git
RUN cd /software/protobuf-c ; sh ./autogen.sh && ./configure --disable-shared && make && make install
# Install Pycparser
RUN cd /software ; git clone https://github.com/eliben/pycparser.git
RUN cd /software/pycparser ; python setup.py install
# Install qemu
RUN cd qemu ; ./build.sh


# Ports
EXPOSE 8118
EXPOSE 9050
EXPOSE 9053


