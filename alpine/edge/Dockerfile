FROM alpine:edge
LABEL maintainer="https://mko-x.github.io/docker-clamav/"

RUN apk add --no-cache bash clamav rsyslog wget clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY check.sh /check.sh

RUN chmod u+x bootstrap.sh check.sh

EXPOSE 3310/tcp


CMD ["/bootstrap.sh"]

HEALTHCHECK --start-period=500s CMD /check.sh