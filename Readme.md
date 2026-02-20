# MPD Docker (Source Build)

This project builds **Music Player Daemon (MPD)** directly from source inside a Docker container using Debian Trixie Slim.

The container is designed to:

- Compile MPD from the official upstream repository
- Run in foreground mode for Docker compatibility
- Persist configuration and runtime state under `/data`
- Automatically seed a default `mpd.conf` on first run
- Expose control and HTTP streaming ports

---

## Directory Layout Inside Container

```bash
/data -> Persistent configuration and database
/music -> Music directory
/playlists -> Playlist directory
```


---

## Exposed Ports

| Port | Purpose |
|------|---------|
| 6600 | MPD control protocol |
| 8000 | HTTP audio stream |

---

## Building the Image

Build the image:

```bash
docker build -t mpd-source .
```


### Running the Container
Basic Run
```bash
docker run -it --rm \
  -p 6600:6600 \
  -p 8000:8000 \
  -v $(pwd)/data:/data \
  mpd-source
```

On first startup:

If /data/mpd.conf does not exist, a default configuration is copied.

All runtime data is stored under /data.

## Using Docker Compose

Example docker-compose.yml:

```bash
services:
  mpd:
    image: mpd-source
    ports:
      - "6600:6600"
      - "8000:8000"
    volumes:
      - ./data:/data
      - ./music:/music
      - ./playlists:/playlists
```

Start:
```bash
docker compose up -d 
```

# Security Considerations

MPD runs as a non-root mpd user.

No default password is configured.

If exposing publicly, configure authentication in mpd.conf:
```bash
password "yourpassword@read,add,control,admin"
```