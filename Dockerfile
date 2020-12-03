FROM alpine:latest
LABEL maintainer="frengky.lim@gmail.com"

ARG TIMEZONE=Asia/Jakarta

RUN \
    apk --update --no-cache add \
    tzdata \
    curl \
    python2 && \
    cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && \
    echo ${TIMEZONE} > /etc/timezone && \
    mkdir /pydbgpproxy && \
    curl -sSL http://downloads.activestate.com/Komodo/releases/12.0.1/remotedebugging/Komodo-PythonRemoteDebugging-12.0.1-91869-linux-x86_64.tar.gz | tar x -z -f - --strip 1 -C /pydbgpproxy && \
    ln -s /pydbgpproxy/pydbgpproxy /usr/local/bin/pydbgpproxy && \
    apk del tzdata curl && \
    rm -rf /var/cache/apk/*

ENV DEFAULT_TZ ${TIMEZONE}
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV PYTHONPATH "$PYTHONPATH:/pydbgpproxy/pythonlib"

# IDE_PORT=9033 DEBUG_PORT=9003
EXPOSE 9033 9003

CMD [ "pydbgpproxy", "-i", "0.0.0.0:9033", "-d", "0.0.0.0:9003" ]
