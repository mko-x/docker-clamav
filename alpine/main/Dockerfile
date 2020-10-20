FROM alpine:3.12
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

RUN apk add --no-cache bash clamav clamav-daemon rsyslog wget clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.sh /
COPY check.sh /

RUN chmod u+x bootstrap.sh check.sh && mkdir /store
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

EXPOSE 3310/tcp

CMD ["/bootstrap.sh"]

HEALTHCHECK --start-period=120s CMD /check.sh