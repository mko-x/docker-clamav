FROM alpine:3.8
LABEL maintainer="Markus Kosmal <dude@m-ko.de> https://m-ko.de"

RUN apk add --no-cache \
    python3 py3-pip bash \
  && pip3 install --upgrade pip

RUN apk add --no-cache clamav rsyslog wget clamav-libunrar

COPY conf /etc/clamav
COPY bootstrap.py /bootstrap.py
COPY check.sh /check.sh

EXPOSE 3310/tcp
VOLUME ["/store"]

CMD /bootstrap.py

HEALTHCHECK --start-period=500s CMD /check.sh