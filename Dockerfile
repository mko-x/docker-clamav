FROM debian:stretch-slim
LABEL author="http://m-ko.de Markus Kosmal <dude@m-ko.de>"

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
        libclamunrar7 \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# initial update of av databases
RUN wget -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
    wget -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
    wget -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
    chown clamav:clamav /var/lib/clamav/*.cvd

# permission juggling
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

# av configuration update
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    echo "TCPSocket 3310" >> /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

RUN sed -i 's/^MaxScanSize .*$/MaxScanSize 4000M/g' /etc/clamav/clamd.conf && \
    sed -i 's/^MaxFileSize .*$/MaxFileSize 4000M/g' /etc/clamav/clamd.conf && \
    sed -i 's/^StreamMaxLength .*$/StreamMaxLength 4000M/g' /etc/clamav/clamd.conf

# Block encrypted files
RUN sed -i 's/^ArchiveBlockEncrypted .*$/ArchiveBlockEncrypted true/g' /etc/clamav/clamd.conf

# volume provision
VOLUME ["/var/lib/clamav"]

# port provision
EXPOSE 3310

# av daemon bootstrapping
ADD bootstrap.sh /
CMD ["/bootstrap.sh"]
