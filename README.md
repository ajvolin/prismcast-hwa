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