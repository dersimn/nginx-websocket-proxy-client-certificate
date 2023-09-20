Docker Image with nginx and configurable websocket proxy with SSL client certifcate authorization.  
I started to build this image to proxy Mosquitto MQTT websockets, but it will work with every websocket connection. 

# Usage

## As baseimage for your own project

Use this Image as baseimage for your own projects that need SSL Client Certificates on iOS devices:

```Dockerfile
FROM dersimn/nginx-websocket-proxy-client-certificate:3

COPY www /www

ENV WS_PROXY_PATH="/my-websocket-location"
ENV WHITELIST_LOCAL_IP="false"
ENV WHITELIST_IP="10.1.1.0/24 192.168.1.0/24"
```

See next section for more options.

## Directly

This image can proxy-pass the Websocket connections, by setting the env variable `WS_PROXY`. The target path for the proxy can be configured with `WS_PROXY_PATH`, it defaults to `/ws`.

    docker run -d --restart=always \
        -v $(pwd)/www:/www:ro \
        -e "WS_PROXY=10.1.1.50:9001" \
        -p 80:80 \
        dersimn/nginx-websocket-proxy-client-certificate

If you provide an SSL key/cert pair in `/ssl`, the Docker Image will also enable HTTPS:

* `/ssl/nginx.key`
* `/ssl/nginx.crt`

Additionally you can enable client-authentification via SSL certificates, by providing:

* `/ssl/client.crt`

In case you have revoked clients, also prodive a `/ssl/client.crl` file.

A nice tutorial on how to generate your own certificates, is located [here](https://jamielinux.com/docs/openssl-certificate-authority/introduction.html).

    docker run -d --restart=always \
        -v $(pwd)/www:/www:ro \
        -v $(pwd)/ssl:/ssl:ro \
        -e "WS_PROXY=10.1.1.50:9001" \
        -p 80:80 \
        -p 443:443 \
        dersimn/nginx-websocket-proxy-client-certificate

If you want to change the default ports, specify it like this: `-p 8001:80 -p 8443:443 -e "HTTPS_REDIRECT_PORT=8443"`.

HTTPS and client-auth are optional for clients connecting from a local IP, according to these IP ranges:

- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

If you don't want this behaviour, set `-e WHITELIST_LOCAL_IP=false` to force SSL and client-auth for everyone. You can also add own IP ranges to the whitelist with `-e WHITELIST_IP="10.1.1.0/24 192.168.1.0/24"`.


# Build

## Simple

    docker build -t ngx .

## Docker Hub

    docker buildx create --name mybuilder
    docker buildx use mybuilder
    docker buildx build \
        --platform linux/386,linux/amd64,linux/arm/v7 \
        -t dersimn/nginx-websocket-proxy-client-certificate \
        -t dersimn/nginx-websocket-proxy-client-certificate:1 \
        -t dersimn/nginx-websocket-proxy-client-certificate:1.x \
        -t dersimn/nginx-websocket-proxy-client-certificate:1.x.0 \
        --push .
