#!/bin/bash
set -e

# If config does not exist in mounted volume, copy default
if [ ! -f /data/mpd.conf ]; then
    echo "No mpd.conf found in /data — copying default."
    cp /usr/local/share/mpd.conf.default /data/mpd.conf
    chown mpd:mpd /data/mpd.conf
fi

exec mpd -v --no-daemon /data/mpd.conf
