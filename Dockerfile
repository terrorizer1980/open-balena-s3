FROM balena/open-balena-base:armv7-fin

EXPOSE 80

VOLUME /export

ENV GO_VERSION 1.10.8
ENV GO_SHA256 6fdbc67524fc4c15fc87014869dddce9ecda7958b78f3cb1bbc5b0a9b61bfb95
ENV PATH ${PATH}:/usr/local/go/bin
ENV GOPATH /go

# Get Go and Minio
RUN curl -SLO https://storage.googleapis.com/golang/go${GO_VERSION}.linux-armv6l.tar.gz && \
    echo "${GO_SHA256} go${GO_VERSION}.linux-armv6l.tar.gz" > go${GO_VERSION}.linux-armv6l.tar.gz.sha256sum && \
    sha256sum -c go${GO_VERSION}.linux-armv6l.tar.gz.sha256sum && \
    tar xz -C /usr/local -f go${GO_VERSION}.linux-armv6l.tar.gz && \
    rm go${GO_VERSION}.linux-armv6l.tar.gz go${GO_VERSION}.linux-armv6l.tar.gz.sha256sum && \
    go get -u github.com/minio/minio

# systemd and minio config
COPY config/services/ /etc/systemd/system/
COPY config/config.json /root/.minio/config.json

# Enable Minio service
RUN systemctl enable open-balena-s3.service
