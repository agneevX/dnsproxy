# Build Instructions

Make sure Docker Desktop is running, and that the BuildX system is running.

## Start BuildX
docker buildx create --use

## Clear Cache
```
docker buildx prune
```

## Build Latest
```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v6,linux/arm/v7 -t vmstan/dnsproxy . --push
```