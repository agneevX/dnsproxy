FROM --platform=linux/arm64 alpine:latest
LABEL maintainer="Michael Stanclift <https://github.com/vmstan>"

RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl

# /usr/bin/dnsproxy
RUN cd /tmp \
    && curl -skSL $(curl -skSL 'https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest' | sed -n '/url.*linux-arm64/{s/.*\(https:.*tar.gz\).*/\1/p}') | tar xz \
    && mv linux-arm64/dnsproxy /usr/bin/ \
    && dnsproxy --version \
    && rm -rf /tmp/*

ENV ARGS="-u=tls://9.9.9.9:853"

CMD /usr/bin/dnsproxy ${ARGS}
