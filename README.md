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
      - SELKIES_MANUAL_WIDTH=1920
      - SELKIES_MANUAL_HEIGHT=1080
      - MAX_RESOLUTION=1920x1080
      - TITLE=Prismcast
      - DISABLE_IPV6=true
      - NO_GAMEPAD=true
      - SELKIES_UI_SIDEBAR_SHOW_CLIPBOARD=false
      - SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=false
      - SELKIES_UI_SIDEBAR_SHOW_GAMING_MODE=false
      - SELKIES_MICROPHONE_ENABLED=false
      - SELKIES_CLIPBOARD_ENABLED=false
      - SELKIES_SECOND_SCREEN=false
      - SELKIES_ENABLE_BINARY_CLIPBOARD=false
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