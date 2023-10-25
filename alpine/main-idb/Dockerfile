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

# Block encrypted files
# NB: The automatically generated (by clamav-daemon postinst) clamd.conf
#     that we update here contains the *old* setting name, so we attempt to
#     update both versions of the setting.
RUN echo 'AlertEncrypted true' >> /etc/clamav/clamd.conf

EXPOSE 3310/tcp

CMD ["/bootstrap.sh"]