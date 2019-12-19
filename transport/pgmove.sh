#!/bin/bash
#
# Title:      GDrive GCrypt Uploader 
# Authors:    Admin9705, Deiteq, subse7even , and many PGBlitz Contributors
# mod from    MrDoobPG
# URL:        you will find us 
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variables come from what's being called from deploymove.sh under functions
## BWLIMIT 9 and Lower Prevents Google 750GB Google Upload Ban
################################################################################
source /opt/pgclone/scripts/cloneclean.sh

if pidof -o %PPID -x "$0"; then
    exit 1
fi

touch /var/plexguide/logs/pgmove.log
truncate -s 0 /var/plexguide/logs/pgmove.log
echo "" >>/var/plexguide/logs/pgmove.log
echo "" >>/var/plexguide/logs/pgmove.log
echo " -- Starting Move: $(date "+%Y-%m-%d %H:%M:%S") -- " >>/var/plexguide/logs/pgmove.log
hdpath="$(cat /var/plexguide/server.hd.path)"
while true; do

    # USER specifying VARS 
    useragent="$(cat /var/plexguide/uagent)"
    bwlimit="$(cat /var/plexguide/move.bw)"
    # VFS var
    vfs_dcs="$(cat /var/plexguide/vfs_dcs)"
    let "cyclecount++"
    if [[ $cyclecount -gt 4294967295 ]]; then
        cyclecount=0; fi
    echo "" >>/var/plexguide/logs/pgmove.log
    echo "---Begin cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log
    echo " Checking for files to upload... " >>/var/plexguide/logs/pgmove.log
    rsync "$hdpath/downloads/" "$hdpath/move/" \
        -aqp --remove-source-files --link-dest="$hdpath/downloads/" \
        --exclude-from="/opt/pgclone/transport/transport-gdrive.exclude" \
        --exclude-from="/opt/pgclone/excluded/excluded.folder"

    if [[ $(find "$hdpath/move" -type f | wc -l) -gt 0 ]]; then
        rclone move "$hdpath/move/" "{{type}}:/" \
            --config=/opt/appdata/plexguide/rclone.conf \
            --log-file=/var/plexguide/logs/pgmove.log \
            --log-level=INFO --stats=5s --stats-file-name-length=0 \
            --max-size=300G \
            --tpslimit=8 \
            --checkers=2 \
            --retries=3 \
            --drive-pacer-min-sleep=100ms \
            --no-traverse \
            --fast-list \
            --max-transfer 720G \
            --bwlimit="$bwlimit" \
            --drive-chunk-size="$vfs_dcs" \
            --user-agent="$useragent" \
            --exclude-from="/opt/pgclone/transport/transport-gdrive.exclude" \
            --exclude-from="/opt/pgclone/excluded/excluded.folder"
        echo " Upload has finished. " >>/var/plexguide/logs/pgmove.log
    else
        echo " No files in $hdpath/move to upload. " >>/var/plexguide/logs/pgmove.log
    fi
    echo " -- Completed cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S") -- " >>/var/plexguide/logs/pgmove.log
    echo "$(tail -n 200 /var/plexguide/logs/pgmove.log)" >/var/plexguide/logs/pgmove.log
    sleep 10
	cloneclean && removefilesgdrive
done
