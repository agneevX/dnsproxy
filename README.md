# DNS Proxy Container
AdGuard `dnsproxy` running in a container container

https://hub.docker.com/r/vmstan/dnsproxy

https://github.com/AdguardTeam/dnsproxy

| Image Tag             | Architectures           | Image OS           | 
| :-------------------- | :-----------------------| :----------------- | 
| latest                | amd64                   | Alpine Linux       |
| arm64                 | arm64v8                 | Alpine Linux       | 
| armv6                 | arm32v6                 | Alpine Linux       | 

## Running

```
docker run -d -p 53:53/udp vmstan/dnsproxy:latest
```

You should replace `latest` with the image tag that matches your architecture.  
