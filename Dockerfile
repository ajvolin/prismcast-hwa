# syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
LABEL maintainer="ajvolin"

# title
ENV TITLE="PrismCast"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/chrome-logo.png && \
  echo "**** setup repo ****" && \
  curl -fsSL \
    https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor | tee /usr/share/keyrings/google-chrome.gpg >/dev/null && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> \
    /etc/apt/sources.list.d/google-chrome.list && \
  echo "**** install packages ****" && \
  if [ -z "${CHROME_VERSION+x}" ]; then \
    CHROME_VERSION=$(curl -sX GET http://dl.google.com/linux/chrome/deb/dists/stable/main/binary-amd64/Packages | grep -A 7 -m 1 'Package: google-chrome-stable' | awk -F ': ' '/Version/{print $2;exit}'); \
  fi && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    google-chrome-stable=${CHROME_VERSION} && \
  echo "**** install nodejs ****" && \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get install -y nodejs && \
  echo "**** install ffmpeg ****" && \
  apt-get install -y ffmpeg && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/* && \
  npm i -g npm && \
  npm i -g prismcast && \
  mkdir -p /usr/local/channels-dvr/latest && \
  ln -s /usr/bin/ffmpeg /usr/local/channels-dvr/latest/ffmpeg && \
  chmod +x /usr/local/channels-dvr/latest/ffmpeg

# add local files
COPY /root /

ENV PRISMCAST_CONTAINER=1
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# ports and volumes
EXPOSE 3000 5589 5004

VOLUME /config

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
    CMD wget -q --spider http://localhost:5589/health || exit 1