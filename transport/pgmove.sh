#!/bin/bash
#
# Title:        GDrive GCrypt Uploader 
# orgAuthor:    Admin9705, Deiteq, and many PGBlitz Contributors
# Mod from MrDoobPG for all
#
# fuck off brandings
################################################################################
# NOTES
# Variables come from what's being called from deploymove.sh under functions
## BWLIMIT 9 and Lower Prevents Google 750GB Google Upload Ban
################################################################################
# Starting Actions
source /opt/pgclone/scripts/cloneclean.sh

touch /var/plexguide/logs/pgmove.log
truncate -s 0 /var/plexguide/logs/pgmove.log
echo "" >>/var/plexguide/logs/pgmove.log
echo "---Starting Move: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log

if pidof -o %PPID -x "$0"; then 
   exit 1
fi

touch /var/plexguide/logs/pgmove.log
truncate -s 0 /var/plexguide/logs/pgmove.log
echo "" >>/var/plexguide/logs/pgmove.log
echo "" >>/var/plexguide/logs/pgmove.log
echo "---Starting Move: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log
while true; do

    useragent="$(cat /var/plexguide/uagent)"
    bwlimit="$(cat /var/plexguide/move.bw)"
    vfs_dcs="$(cat /var/plexguide/vfs_dcs)"
    let "cyclecount++"

    if [[ $cyclecount -gt 4294967295 ]]; then cyclecount=0; fi

    echo "" >>/var/plexguide/logs/pgmove.log
    echo "---Begin cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log
    echo "Checking for files to upload..." >>/var/plexguide/logs/pgmove.log

   rsync "$(cat /var/plexguide/server.hd.path)/downloads/" "$(cat /var/plexguide/server.hd.path)/move/" \
         -aq --remove-source-files --link-dest="$(cat /var/plexguide/server.hd.path)/downloads/" \
         --exclude-from="/opt/pgclone/transport/transport-gdrive.exclude" \
         --exclude-from="/opt/pgclone/excluded/excluded.folder"

    if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l) -gt 0 ]]; then

        rclone move "$(cat /var/plexguide/server.hd.path)/move/" "{{type}}:/" \
            --config=/opt/appdata/plexguide/rclone.conf \
            --log-file=/var/plexguide/logs/pgmove.log \
            --log-level=INFO --stats=5s --stats-file-name-length=0 \
            --max-size=300G --mina-age 2m \
            --tpslimit=10 \
            --checkers=8 \
            --transfers=4 \
            --no-traverse \
            --fast-list \
            --max-transfer 750G \
            --bwlimit="$bwlimit" \
            --drive-chunk-size="$vfs_dcs" \
            --user-agent="$useragent" \
            --exclude-from="/opt/pgclone/transport/transport-gdrive.exclude" \
            --exclude-from="/opt/pgclone/excluded/excluded.folder"
        echo "Upload has finished." >>/var/plexguide/logs/pgmove.log
    else
        echo "No files in $(cat /var/plexguide/server.hd.path)/move to upload." >>/var/plexguide/logs/pgmove.log
    fi
    echo "---Completed cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log
    echo "$(tail -n 200 /var/plexguide/logs/pgmove.log)" >/var/plexguide/logs/pgmove.log
    sleep 30
    cloneclean
    removefilesgdrive
    nzbremoverunwantedfiles
done