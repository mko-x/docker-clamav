FROM mkodockx/docker-clamav:alpine
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# switch for installation
USER root

# initial database initialization at build time
COPY ./main.cvd  /var/lib/clamav/main.cvd
COPY ./daily.cvd  /var/lib/clamav/daily.cvd
COPY ./bytecode.cvd  /var/lib/clamav/bytecode.cvd
COPY ./safebrowsing.cvd  /var/lib/clamav/safebrowsing.cvd

# permission juggling
RUN chown clamav:clamav /var/lib/clamav/*.cvd

EXPOSE 3310/tcp

USER clamav

CMD ["/bootstrap.sh"]