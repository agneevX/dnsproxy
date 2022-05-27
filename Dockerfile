FROM alpine:3.14

LABEL maintainer="Michael Stanclift <https://github.com/vmstan>"

ARG TARGETPLATFORM=linux/amd64
ARG BUILDPLATFORM

RUN apk add --update --no-cache ca-certificates tzdata \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && apk del curl wget tzdata

RUN apk add --update --no-cache curl jq \
    curl -s -o /usr/bin/dnsproxy \
    $(curl -s https://api.github.com/repos/adguardteam/adguardhome/releases/latest \
    | jq -r '.assets[].browser_download_url' | grep $(echo TARGETPLATFORM | sed 's/\//_/g')) \
    && /usr/bin/dnsproxy --version \
    && apk del curl jq tzdata \
    && rm -rf /var/cache/apk/*

COPY config.yaml /config/

ENTRYPOINT ["/usr/bin/dnsproxy"]
CMD ["--config-path=/config/config.yaml"]
