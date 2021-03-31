FROM mkodockx/docker-clamav:alpine
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# switch for installation
USER root

# initial database download at build time
RUN apk add --no-cache curl
RUN curl -o /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
    curl -o /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
    curl -o /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
    chown clamav:clamav /var/lib/clamav/*.cvd

EXPOSE 3310/tcp

USER clamav

CMD ["/bootstrap.sh"]