FROM mkodockx/docker-clamav:alpine
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# switch for installation
USER root

# initial database initialization at build time
COPY ./main.cvd  /var/lib/clamav/main.cvd
COPY ./daily.cvd  /var/lib/clamav/daily.cvd
COPY ./bytecode.cvd  /var/lib/clamav/bytecode.cvd
COPY ./safebrowsing.cvd  /var/lib/clamav/safebrowsing.cvd

# setup alternative versions in case someone setups an empty mount over /var/lib/clamav
RUN mkdir -p /var/lib/clamav.source && ln /var/lib/clamav/* /var/lib/clamav.source

# permission juggling
RUN chown clamav:clamav /var/lib/clamav/*.cvd /var/lib/clamav.source

EXPOSE 3310/tcp

USER clamav

CMD ["/bootstrap.sh"]
