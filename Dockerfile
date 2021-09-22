ARG AZCOPY_VERSION
ARG GO_VERSION=1.17
ARG ALPINE_VERSION=3.14

FROM golang:$GO_VERSION-alpine$ALPINE_VERSION as build
ENV GOARCH=arm64 GOOS=linux
WORKDIR /azcopy
ARG AZCOPY_VERSION
RUN wget RUN wget "https://github.com/Azure/azure-storage-azcopy/archive/v10.12.2.tar.gz" -O src.tgz --no-check-certificate
RUN tar xf src.tgz --strip 1 
RUN go build -o azcopy 
RUN ./azcopy --version

FROM alpine:$ALPINE_VERSION as release
ARG AZCOPY_VERSION
LABEL name="docker-azcopy"
LABEL version="$AZCOPY_VERSION"
LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
COPY --from=build /azcopy/azcopy /usr/local/bin
WORKDIR /WORKDIR
CMD [ "azcopy" ]
