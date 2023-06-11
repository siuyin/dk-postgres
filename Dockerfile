FROM ubuntu:22.04
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y build-essential libreadline-dev zlib1g-dev
RUN adduser postgres
ADD postgresql-8.1.23.tar.gz /tmp/
RUN chown -R postgres:postgres /tmp/postgresql-8.1.23/
USER postgres
WORKDIR /tmp/postgresql-8.1.23/
RUN export CFLAGS=-fno-aggressive-loop-optimizations && ./configure && make -j8
RUN make check
