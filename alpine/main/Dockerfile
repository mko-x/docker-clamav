FROM alpine:3.12
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

RUN apk add --no-cache bash clamav clamav-daemon rsyslog wget clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY check.sh /

RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav && \
    chown -R clamav:clamav bootstrap.sh check.sh /etc/clamav && \
    chmod u+x bootstrap.sh check.sh 

EXPOSE 3310/tcp

USER clamav

CMD ["/bootstrap.sh"]