FROM debian:trixie-slim
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# Debian Base to use
ENV DEBIAN_VERSION stretch

# initial install of av daemon
RUN echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://http.debian.net/debian/ $DEBIAN_VERSION-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ $DEBIAN_VERSION/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
        clamav-daemon \
        clamav-freshclam \
        libclamunrar9 \
        ca-certificates \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# permission juggling
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

# av configuration update
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    if ! [ -z $HTTPProxyServer ]; then echo "HTTPProxyServer $HTTPProxyServer" >> /etc/clamav/freshclam.conf; fi && \
    if ! [ -z $HTTPProxyPort   ]; then echo "HTTPProxyPort $HTTPProxyPort" >> /etc/clamav/freshclam.conf; fi && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

RUN sed -i 's/^MaxScanSize .*$/MaxScanSize 4000M/g' /etc/clamav/clamd.conf && \
    sed -i 's/^MaxFileSize .*$/MaxFileSize 4000M/g' /etc/clamav/clamd.conf && \
    sed -i 's/^StreamMaxLength .*$/StreamMaxLength 4000M/g' /etc/clamav/clamd.conf

# Block encrypted files
# NB: The automatically generated (by clamav-daemon postinst) clamd.conf
#     that we update here contains the *old* setting name, so we attempt to
#     update both versions of the setting.
RUN sed -i 's/^ArchiveBlockEncrypted .*$/AlertEncrypted true/g' /etc/clamav/clamd.conf && \
    sed -i 's/^AlertEncrypted .*$/AlertEncrypted true/g' /etc/clamav/clamd.conf

# port provision
EXPOSE 3310

COPY bootstrap.sh /
COPY check.sh /
COPY custom-bootstrap.sh /
RUN chown clamav:clamav bootstrap.sh check.sh /etc/clamav /etc/clamav/clamd.conf /etc/clamav/freshclam.conf custom-bootstrap.sh && \
    chmod u+x bootstrap.sh check.sh custom-bootstrap.sh

USER clamav

CMD ["/bootstrap.sh"]
