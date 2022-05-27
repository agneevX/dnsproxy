FROM alpine:3.14

LABEL maintainer="Michael Stanclift <https://github.com/vmstan>"

ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM

RUN apk add --update --no-cache curl wget ca-certificates tzdata jq \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && wget $(curl -s https://api.github.com/repos/adguardteam/dnsproxy/releases/latest \
    | jq -r '.assets[].browser_download_url' | grep $(echo $TARGETPLATFORM | sed 's/\//_/g')) \
    && tar -xf ./*.tar.gz \
    && mv ./$(echo $TARGETPLATFORM | sed 's/\//_/g')/dnsproxy /usr/bin/ \
    && /usr/bin/dnsproxy --version \
    && apk del curl jq wget tzdata \
    && rm -rf ./*.tar.gz linux* /var/cache/apk/*

COPY config.yaml /config/

ENTRYPOINT ["/usr/bin/dnsproxy"]
CMD ["--config-path=/config/config.yaml"]