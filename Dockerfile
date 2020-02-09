FROM alpine:latest

LABEL cn.magicarnea.description="Ngrok server docker image based on alpine." \
      cn.magicarnea.vendor="MagicArena" \
      cn.magicarnea.maintainer="everoctivian@gmail.com" \
      cn.magicarnea.versionCode=1 \
      cn.magicarnea.versionName="1.0.0"

EXPOSE 80/tcp 443/tcp 4443/tcp

VOLUME ["/etc/ngrok"]

HEALTHCHECK --interval=1m \
            --timeout=3s \
            --start-period=5s \
            --retries=5 \
            CMD nc -z localhost 4443 > /dev/null; if [ 0 != $? ]; then exit 1; fi;

# if you want use APK mirror then uncomment, modify the mirror address to which you favor
#RUN sed -i 's|http://dl-cdn.alpinelinux.org|https://mirrors.aliyun.com|g' /etc/apk/repositories

ENV TIME_ZONE=Asia/Shanghai
RUN set -ex && \
    apk add --no-cache tzdata && \
    ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    echo ${TIME_ZONE} > /etc/timezone && \
    rm -rf /tmp/* /var/cache/apk/* && \
    mkdir -p /etc/ngrok

COPY ./usr/bin/ngrokd /usr/bin/ngrokd
COPY ./etc/ngrok/tls.key /etc/ngrok/tls.key
COPY ./etc/ngrok/tls.crt /etc/ngrok/tls.crt

RUN chmod +x /usr/bin/ngrokd

CMD ["-domain=ngrok.magicarena.cn"]

ENTRYPOINT ["/usr/bin/ngrokd", "-tlsKey=/etc/ngrok/tls.key", "-tlsCrt=/etc/ngrok/tls.crt", "-httpAddr=:80", "-httpsAddr=:443", "-tunnelAddr=:4443", "-log=stdout", "-log-level=DEBUG"]