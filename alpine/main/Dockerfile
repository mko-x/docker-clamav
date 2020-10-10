FROM alpine:3.12
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

RUN apk add --no-cache bash clamav rsyslog wget clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY check.sh /check.sh

RUN chmod u+x bootstrap.sh check.sh

EXPOSE 3310/tcp
VOLUME ["/store"]

CMD ["/bootstrap.sh"]

HEALTHCHECK --start-period=500s CMD /check.sh