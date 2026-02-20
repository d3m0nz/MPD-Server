############################
# Stage 1 — Build MPD
############################
FROM debian:trixie-slim AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    git \
    meson \
    ninja-build \
    build-essential \
    pkg-config \
    ca-certificates \
    libfmt-dev \
    libpcre2-dev \
    libmad0-dev \
    libmpg123-dev \
    libid3tag0-dev \
    libflac-dev \
    libvorbis-dev \
    libopus-dev \
    libogg-dev \
    libsndfile1-dev \
    libfaad-dev \
    libmpcdec-dev \
    libwavpack-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libmp3lame-dev \
    libtwolame-dev \
    libsamplerate0-dev \
    libsoxr-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libasound2-dev \
    libpulse-dev \
    libshout3-dev \
    libsqlite3-dev \
    libavahi-client-dev \
    libsystemd-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone --depth 1 https://github.com/MusicPlayerDaemon/MPD.git
WORKDIR /build/MPD

RUN meson setup build --buildtype=release -Db_ndebug=true -Dsysconfdir=/etc
RUN ninja -C build
RUN ninja -C build install

############################
# Stage 2 — Runtime
############################
FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
   # mpd \
    libfmt-dev \
    libpcre2-dev \
    libmad0-dev \
    libmpg123-dev \
    libid3tag0-dev \
    libflac-dev \
    libvorbis-dev \
    libopus-dev \
    libogg-dev \
    libsndfile1-dev \
    libfaad-dev \
    libmpcdec-dev \
    libwavpack-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libmp3lame-dev \
    libtwolame-dev \
    libsamplerate0-dev \
    libsoxr-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    libasound2-dev \
    libpulse-dev \
    libshout3-dev \
    libsqlite3-dev \
    libavahi-client-dev \
    libsystemd-dev \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Replace Debian mpd binary with your compiled one
COPY --from=builder /usr/local/bin/mpd /usr/bin/mpd


RUN ldconfig

RUN useradd -r -d /data mpd && \
    mkdir -p /data /music /playlists && \
    chown -R mpd:mpd /data /music /playlists

COPY defaults/mpd.conf /data/mpd.conf
COPY defaults/mpd.conf /usr/local/share/mpd.conf.default

RUN chown mpd:mpd /data/mpd.conf && \
    chmod 644 /data/mpd.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

EXPOSE 6600 8000

ENTRYPOINT ["/entrypoint.sh"]
