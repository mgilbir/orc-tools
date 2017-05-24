FROM ubuntu:16.04 as builder
MAINTAINER Owen O'Malley <owen@hortonworks.com>
RUN apt-get update
RUN apt-get install -y \
  cmake \
  default-jdk \
  gcc \
  g++ \
  git \
  make \
  tzdata \
  maven
WORKDIR /root
RUN git clone https://github.com/apache/orc.git -b master && \
  mkdir orc/build && \
  cd orc/build && \
  cmake .. && \
  make package test-out
RUN cd orc/build && make install 

FROM ubuntu:16.04
RUN apt-get update && apt-get install -y tzdata
COPY --from=builder /usr/local/./LICENSE                    /usr/local/LICENSE
COPY --from=builder /usr/local/./NOTICE                     /usr/local/NOTICE
COPY --from=builder /usr/local/include/orc/orc-config.hh    /usr/local/include/orc/orc-config.hh
COPY --from=builder /usr/local/include/orc/ColumnPrinter.hh /usr/local/include/orc/ColumnPrinter.hh
COPY --from=builder /usr/local/include/orc/Int128.hh        /usr/local/include/orc/Int128.hh
COPY --from=builder /usr/local/include/orc/MemoryPool.hh    /usr/local/include/orc/MemoryPool.hh
COPY --from=builder /usr/local/include/orc/OrcFile.hh       /usr/local/include/orc/OrcFile.hh
COPY --from=builder /usr/local/include/orc/Reader.hh        /usr/local/include/orc/Reader.hh
COPY --from=builder /usr/local/include/orc/Type.hh          /usr/local/include/orc/Type.hh
COPY --from=builder /usr/local/include/orc/Vector.hh        /usr/local/include/orc/Vector.hh
COPY --from=builder /usr/local/lib/libz.a                   /usr/local/lib/libz.a
COPY --from=builder /usr/local/lib/libprotobuf.a            /usr/local/lib/libprotobuf.a
COPY --from=builder /usr/local/lib/libsnappy.a              /usr/local/lib/libsnappy.a
COPY --from=builder /usr/local/lib/liblz4.a                 /usr/local/lib/liblz4.a
COPY --from=builder /usr/local/lib/liborc.a                 /usr/local/lib/liborc.a
COPY --from=builder /usr/local/bin/orc-contents             /usr/local/bin/orc-contents
COPY --from=builder /usr/local/bin/orc-metadata             /usr/local/bin/orc-metadata
COPY --from=builder /usr/local/bin/orc-statistics           /usr/local/bin/orc-statistics
