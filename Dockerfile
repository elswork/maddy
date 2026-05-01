ARG BASEIMAGE=alpine:3.21.2
FROM golang:1.23-alpine AS build-env



RUN set -ex && \
    apk upgrade --no-cache --available && \
    apk add --no-cache build-base

WORKDIR /maddy

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN chmod +x build.sh && \
    mkdir -p /pkg/data && \
    cp maddy.conf.docker /pkg/data/maddy.conf && \
    ./build.sh --builddir /tmp --destdir /pkg/ --tags "docker" build install

FROM ${BASEIMAGE}

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="Eloy Lopez <elswork@gmail.com>" \
    org.opencontainers.image.title="maddy" \
    org.opencontainers.image.description="maddy is a composable all-in-one mail server" \
    org.opencontainers.image.vendor="Deft Work" \
    org.opencontainers.image.url="https://deft.work/maddy" \
    org.opencontainers.image.source="https://github.com/foxcpp/maddy" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.licenses=MIT

RUN set -ex && \
    apk upgrade --no-cache --available && \
    apk --no-cache add ca-certificates

WORKDIR /data
COPY --from=build-env /pkg/data/maddy.conf /data/maddy.conf
COPY --from=build-env /pkg/usr/local/bin/maddy /usr/local/bin/maddy

EXPOSE 25 143 993 587 465
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/maddy", "-config", "/data/maddy.conf"]
CMD ["run"]
