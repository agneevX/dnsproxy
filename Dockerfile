FROM alpine:latest
LABEL maintainer="Michael Stanclift <https://github.com/vmstan>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM

EXPOSE 53

RUN apk update
RUN apk upgrade
RUN set -ex \
    && apk add --update --no-cache curl wget ca-certificates jq tzdata \
    && update-ca-certificates \
    && echo $TZ > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && date \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

# /usr/bin/dnsproxy

RUN if [ "$TARGETPLATFORM" == "linux/amd64" ]; then cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-amd64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-amd64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*; fi
RUN if [ "$TARGETPLATFORM" == "linux/arm64" ]; then cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-arm64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-arm64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*; fi
RUN if [ "$TARGETPLATFORM" == "linux/arm/v6" ]; then cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-arm6/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-arm6/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*; fi
RUN if [ "$TARGETPLATFORM" == "linux/arm/v7" ]; then cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-arm6/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-arm6/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*; fi

COPY config.yaml /config/config.yaml

ENV CONFIG="--config-path=/config/config.yaml"

CMD /usr/bin/dnsproxy ${CONFIG}
