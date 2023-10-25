# Pinning to 1.2 instead of stable
FROM clamav/clamav:1.2
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

# Change directory permissions to grant clamav user access
RUN mkdir /var/run/clamav /run/lock && \
    chown clamav:clamav /var/run/clamav /run/clamav /var/log/clamav /var/lock /run/lock && \
    chmod 770 /var/run/clamav /run/clamav /var/log/clamav /var/lock /run/lock

# Block encrypted files
RUN echo 'AlertEncrypted true' >> /etc/clamav/clamd.conf

USER clamav

EXPOSE 3310/tcp

CMD ["/bootstrap.sh"]