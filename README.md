Docker Image with nginx and configurable proxy-pass for Mosquitto MQTT Websocket connections. 

## Options

This image can proxy-pass the Websocket connection from your MQTT broker, by setting the env variable `MQTT_HOST`.  
You have to enable Websockets on your broker. The Docker Image [toke/mosquitto](https://hub.docker.com/r/toke/mosquitto) for e.g. has it already enabled by default on [port 9001](https://github.com/toke/docker-mosquitto/blob/8aa0a74b444fb2377fcd4a43ac85a257aef51176/config/conf.d/websockets.conf#L1), where the official Docker Image [eclipse-mosquitto](https://hub.docker.com/_/eclipse-mosquitto) need to be configured first.

    docker run -d --restart=always \
        -v $(pwd)/www:/www:ro \
        -e "MQTT_HOST=10.1.1.50:9001" \
        -p 80:80 \
        dersimn/mqtt-nginx-proxy

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
        -e "MQTT_HOST=10.1.1.50:9001" \
        -p 80:80 \
        -p 443:443 \
        dersimn/mqtt-nginx-proxy

If you want to change the default ports, specify it like this: `-p 8001:80 -p 8443:443 -e "HTTPS_REDIRECT_PORT=8443"`.

HTTPS and client-auth are optional for clients connecting via a local IP, according to [these](https://github.com/dersimn/mqtt-smarthome-webui/blob/6e419811d3bd433e5fc594e1beccaa0499fe08cf/nginx.template#L69) IP ranges. If you make port 80/443 public to the Internet you should definitely enable client-auth.
