# Build Instructions

## Latest
```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v6 -t vmstan/dnsproxy . --push
```

## Photon
```
docker buildx build --platform linux/amd64,linux/arm64 -t vmstan/dnsproxy:photon photon/. --push
```