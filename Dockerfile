FROM alpine:latest
LABEL maintainer="Michael Stanclift <https://github.com/vmstan>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl

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

ENV ARGS="-u=tls://9.9.9.9:853"

CMD /usr/bin/dnsproxy ${ARGS}
