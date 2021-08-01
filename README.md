# DNS Proxy Container
DNS Proxy is a very tiny, simple, DNS resolver written by the Adguard Team that supports all existing DNS protocols including `DNS-over-TLS`, `DNS-over-HTTPS`, `DNSCrypt`, and `DNS-over-QUIC`. It can work as a `DNS-over-HTTPS`, `DNS-over-TLS` or `DNS-over-QUIC` server.

More information can be found at: https://github.com/AdguardTeam/dnsproxy

## Images

Images available at: https://hub.docker.com/r/vmstan/dnsproxy

| Image Tag             | Architectures            | Image OS           | DNS Proxy Version  |
| :-------------------- | :------------------------| :----------------- | :----------------- |
| latest                | amd64, arm64v8, arm32v6  | Alpine Linux       | v0.39.0            |
| photon                | amd64, arm64v8           | VMware Photon      | v0.39.0            |

## Running

```
docker run -d -p 53:53/udp --restart=always vmstan/dnsproxy
```

To use [VMware Photon OS](https://vmware.github.io/photon/) as the base OS for the container:

```
docker run -d -p 53:53/udp --restart=always vmstan/dnsproxy:photon
```

By default, the container is configured to make a DNS over TLS (DoT) to [Quad9](https://www.quad9.net) (tls://9.9.9.9), but you can change this by passing additional arguments to the the container using the `CONFIG` variable.

```
docker run -d -e "CONFIG=--upstream=tls://1.1.1.1" -p 53:53/udp --restart=always vmstan/dnsproxy
```

This would use [Cloudflare](https://1.1.1.1/dns/) instead.

You could also configure Cloudflare as a backup to Quad9, additionally setting caching options for a minimum TTL of 30 minutes.

```
docker run -d -e "CONFIG=--cache --cache-min-ttl=1800 -u=tls://9.9.9.9 -f=tls://1.1.1.1" -p 53:53/udp --restart=always vmstan/dnsproxy
```

## Second Hop

If you want to use the container after passing DNS requests through another service on the same box (say, Pi-hole) then you can change the port mappings into the container to use something other than 53, which is typically what Pi-hole will use. 

```
docker run -d -p 8053:53/udp --restart=always vmstan/dnsproxy
```

If for some reason you want change the `--port` that `dnsproxy` is using from within the `CONFIG` variable, make sure you change the port that is advertised via Docker.

```
docker run -d -e "CONFIG=--port=1111" -p 1111:1111/udp --restart=always vmstan/dnsproxy
```

## Docker Compose

See [docker-compose.yml](https://github.com/vmstan/dnsproxy/blob/main/docker-compose.yml) for an example configuration.

## Additional Arguments

```
docker run --rm vmstan/dnsproxy:latest dnsproxy -h
Usage:
  dnsproxy [OPTIONS]

Application Options:
  -v, --verbose           Verbose output (optional)
  -o, --output=           Path to the log file. If not set, write to stdout.
  -l, --listen=           Listening addresses (default: 0.0.0.0)
  -p, --port=             Listening ports. Zero value disables TCP and UDP
                          listeners (default: 53)
  -s, --https-port=       Listening ports for DNS-over-HTTPS
  -t, --tls-port=         Listening ports for DNS-over-TLS
  -q, --quic-port=        Listening ports for DNS-over-QUIC
  -y, --dnscrypt-port=    Listening ports for DNSCrypt
  -c, --tls-crt=          Path to a file with the certificate chain
  -k, --tls-key=          Path to a file with the private key
      --tls-min-version=  Minimum TLS version, for example 1.0
      --tls-max-version=  Maximum TLS version, for example 1.3
      --insecure          Disable secure TLS certificate validation
  -g, --dnscrypt-config=  Path to a file with DNSCrypt configuration. You can
                          generate one using
                          https://github.com/ameshkov/dnscrypt
  -u, --upstream=         An upstream to be used (can be specified multiple
                          times). You can also specify path to a file with the
                          list of servers
  -b, --bootstrap=        Bootstrap DNS for DoH and DoT, can be specified
                          multiple times (default: 8.8.8.8:53)
  -f, --fallback=         Fallback resolvers to use when regular ones are
                          unavailable, can be specified multiple times. You can
                          also specify path to a file with the list of servers
      --all-servers       If specified, parallel queries to all configured
                          upstream servers are enabled
      --fastest-addr      Respond to A or AAAA requests only with the fastest
                          IP address
      --cache             If specified, DNS cache is enabled
      --cache-size=       Cache size (in bytes). Default: 64k
      --cache-min-ttl=    Minimum TTL value for DNS entries, in seconds. Capped
                          at 3600. Artificially extending TTLs should only be
                          done with careful consideration.
      --cache-max-ttl=    Maximum TTL value for DNS entries, in seconds.
      --cache-optimistic  If specified, optimistic DNS cache is enabled
  -r, --ratelimit=        Ratelimit (requests per second) (default: 0)
      --refuse-any        If specified, refuse ANY requests
      --edns              Use EDNS Client Subnet extension
      --edns-addr=        Send EDNS Client Address
      --dns64             If specified, dnsproxy will act as a DNS64 server
      --dns64-prefix=     If specified, this is the DNS64 prefix dnsproxy will
                          be using when it works as a DNS64 server. If not
                          specified, dnsproxy uses the 'Well-Known Prefix'
                          64:ff9b::
      --ipv6-disabled     If specified, all AAAA requests will be replied with
                          NoError RCode and empty answer
      --bogus-nxdomain=   Transform responses that contain at least one of the
                          given IP addresses into NXDOMAIN. Can be specified
                          multiple times.
      --udp-buf-size=     Set the size of the UDP buffer in bytes. A value <= 0
                          will use the system default. (default: 0)
      --max-go-routines=  Set the maximum number of go routines. A value <= 0
                          will not not set a maximum. (default: 0)
      --version           Prints the program version

Help Options:
  -h, --help              Show this help message
```

## Credit

[Chenhw2](https://hub.docker.com/r/chenhw2/dnsproxy) for the base Dockerfile.
