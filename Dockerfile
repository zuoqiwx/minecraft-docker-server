FROM --platform=linux/amd64 openjdk:jdk
EXPOSE 25565

ARG version=1.19.3
ENV JVM_MEMORY_MAX=1G
ENV JVM_MEMORY_START=1G

COPY . /minecraft
VOLUME [ "/minecraft/server" ]

WORKDIR /minecraft
ENTRYPOINT [ "bash", "start.sh" ]
