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
  echo "**** install tint2 ****" && \
  apt-get install -y tint2 && \
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
ENV DISABLE_IPV6=true
ENV SELKIES_IS_MANUAL_RESOLUTION_MODE=true
ENV SELKIES_MANUAL_WIDTH=1920
ENV SELKIES_MANUAL_HEIGHT=1080
ENV MAX_RESOLUTION=1920x1080
ENV SELKIES_UI_TITLE=PrismCast
ENV SELKIES_UI_SIDEBAR_SHOW_CLIPBOARD="false|locked"
ENV SELKIES_UI_SIDEBAR_SHOW_GAMEPADS="false|locked"
ENV SELKIES_UI_SIDEBAR_SHOW_GAMING_MODE="false|locked"
ENV SELKIES_MICROPHONE_ENABLED="false|locked"
ENV SELKIES_SECOND_SCREEN="false|locked"
ENV SELKIES_CLIPBOARD_ENABLED="false|locked"
ENV SELKIES_ENABLE_BINARY_CLIPBOARD="false|locked"
ENV SELKIES_ENABLE_SHARING="false|locked"
ENV SELKIES_UI_SIDEBAR_SHOW_APPS="false|locked"
ENV SELKIES_UI_SIDEBAR_SHOW_FILES="false|locked"
ENV SELKIES_UI_SIDEBAR_SHOW_SHARING="false|locked"
ENV NO_GAMEPAD="true|locked"

# ports and volumes
EXPOSE 3000 5589 5004

VOLUME /config

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
    CMD wget -q --spider http://localhost:5589/health || exit 1