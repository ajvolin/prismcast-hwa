# prismcast-hwa

## Docker compose example for VAAPI hardware acceleration
```yaml
services:
  prismcast-hwa:
    image: ajvolin/prismcast-hwa:dev
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - DRINODE=/dev/dri/renderD128
      - DRI_NODE=/dev/dri/renderD128
      - TITLE=PrismCast
      - DISABLE_IPV6=True
      - SELKIES_IS_MANUAL_RESOLUTION_MODE=True
      - SELKIES_MANUAL_WIDTH=1920
      - SELKIES_MANUAL_HEIGHT=1080
      - MAX_RESOLUTION=1920x1080
      - SELKIES_UI_TITLE=PrismCast
      - SELKIES_UI_SIDEBAR_SHOW_CLIPBOARD=False
      - SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=False
      - SELKIES_UI_SIDEBAR_SHOW_GAMING_MODE=False
      - SELKIES_MICROPHONE_ENABLED=False
      - SELKIES_SECOND_SCREEN=False
      - SELKIES_CLIPBOARD_ENABLED=False
      - SELKIES_ENABLE_BINARY_CLIPBOARD=False
      - SELKIES_ENABLE_SHARING=False
      - NO_GAMEPAD=True
    devices:
      - /dev/dri:/dev/dri
    volumes:
      - /opt/prismcast-hwa:/config
    ports:
      - 3000:3000
      - 3001:3001
      - 5589:5589
    shm_size: "2gb"
    restart: unless-stopped
```