 FROM debian:buster-slim
LABEL maintainer="Markus Kosmal <code@m-ko.de>"

# Debian Base to use
ENV DEBIAN_VERSION buster

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
        netcat-openbsd \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Initial update of av databases from DIT mirror
RUN wget -O /var/lib/clamav/main.cvd http://dit-clamav-mirror1.s3-website.eu-west-2.amazonaws.com/main.cvd && \
    wget -O /var/lib/clamav/daily.cvd http://dit-clamav-mirror1.s3-website.eu-west-2.amazonaws.com/daily.cvd && \
    wget -O /var/lib/clamav/bytecode.cvd http://dit-clamav-mirror1.s3-website.eu-west-2.amazonaws.com/bytecode.cvd && \
    chown clamav:clamav /var/lib/clamav/*.cvd

# permission juggling
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

# av configuration update
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    if [ -n "$HTTPProxyServer" ]; then echo "HTTPProxyServer $HTTPProxyServer" >> /etc/clamav/freshclam.conf; fi && \
    if [ -n "$HTTPProxyPort"   ]; then echo "HTTPProxyPort $HTTPProxyPort" >> /etc/clamav/freshclam.conf; fi && \
    if [ -n "$DatabaseMirror"  ]; then echo "DatabaseMirror $DatabaseMirror" >> /etc/clamav/freshclam.conf; fi && \
    if [ -n "$DatabaseMirror"  ]; then echo "ScriptedUpdates off" >> /etc/clamav/freshclam.conf; fi && \
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

# Remove any existing DatabaseMirror lines and add our local mirror
RUN sed -i '/^DatabaseMirror/d' /etc/clamav/freshclam.conf && \
    echo "ScriptedUpdates false" >> /etc/clamav/freshclam.conf && \
    echo "DatabaseMirror clamav-mirror-staging.london.cloudapps.digital" >> /etc/clamav/freshclam.conf


# env based configs - will be called by bootstrap.sh
COPY envconfig.sh /
COPY check.sh /
COPY bootstrap.sh /

# port provision
EXPOSE 3310

RUN chown clamav:clamav bootstrap.sh check.sh envconfig.sh /etc/clamav /etc/clamav/clamd.conf /etc/clamav/freshclam.conf && \
    chmod u+x bootstrap.sh check.sh envconfig.sh    

USER clamav

CMD ["/bootstrap.sh"]
