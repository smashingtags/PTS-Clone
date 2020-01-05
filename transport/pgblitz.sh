#!/bin/bash
#
# Title:      TDrive Uploader
# orgAuthors:    Admin9705, Deiteq, and many PGBlitz Contributors
# Mod from MrDoobPG for all
#
# fuck off brandings
################################################################################
# Starting Actions
touch /var/plexguide/logs/pgblitz.log
truncate -s 0 /var/plexguide/logs/pgblitz.log
echo "" >>/var/plexguide/logs/pgblitz.log
echo "" >>/var/plexguide/logs/pgblitz.log
echo "-- Starting Blitz: $(date "+%Y-%m-%d %H:%M:%S") --" >>/var/plexguide/logs/pgblitz.log

startscript() {
    while read p; do
        # User specifying  VARS
        useragent="$(cat /var/plexguide/uagent)"
        bwlimit="$(cat /var/plexguide/blitz.bw)"
        # VFS vars
        vfs_dcs="$(cat /var/plexguide/vfs_dcs)"
        vfs_mt="$(cat /var/plexguide/vfs_mt)"
        vfs_t="$(cat /var/plexguide/vfs_t)"
        vfs_c="$(cat /var/plexguide/vfs_c)"

        let "cyclecount++"
        if [[ $cyclecount -gt 4294967295 ]]; then cyclecount=0; fi

        echo "" >>/var/plexguide/logs/pgblitz.log
        echo "-- Begin cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S") --" >>/var/plexguide/logs/pgblitz.log
        echo "-- Checking for files to upload..." >>/var/plexguide/logs/pgblitz.log

        rsync "$(cat /var/plexguide/server.hd.path)/downloads/" "$(cat /var/plexguide/server.hd.path)/move/" \
            -aq --remove-source-files --link-dest="$(cat /var/plexguide/server.hd.path)/downloads/" \
            --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" \
            --exclude-from="/opt/pgclone/excluded/excluded.folder"

        if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -gt 1 ]]; then
            rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "${p}{{encryptbit}}:/" \
                --config=/opt/appdata/plexguide/rclone.conf \
                --log-file=/var/plexguide/logs/pgblitz.log \
                --log-level=INFO --stats=5s --stats-file-name-length=0 \
                --max-size=300G --min-age 2m \
                --tpslimit=8 \
                --drive-pacer-min-sleep=100ms \
                --checkers="$vfs_c" \
                --transfers="$vfs_t" \
                --no-traverse \
                --fast-list \
                --max-transfer "$vfs_mt" \
                --bwlimit="$bwlimit" \
                --drive-chunk-size="$vfs_dcs" \
                --user-agent="$useragent" \
                --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" \
                --exclude-from="/opt/pgclone/excluded/excluded.folder"
            echo "-- Completed cycle $cyclecount --" >>/var/plexguide/logs/pgblitz.log
            sleep 5
            echo "-- Upload has finished --" >>/var/plexguide/logs/pgblitz.log
            cloneclean
			removefilestdrive
			nzbremoverunwantedfiles
            echo "-- CloneCleane done --" >>/var/plexguide/logs/pgblitz.log
            echo "$(tail -n 200 /var/plexguide/logs/pgblitz.log)" >>/var/plexguide/logs/pgblitz.log
        else
            echo "No files in $(cat /var/plexguide/server.hd.path)/move to upload. $(date "+%Y-%m-%d %H:%M:%S") " >>/var/plexguide/logs/pgblitz.log
        fi
    done </var/plexguide/.blitzfinal
    sleep 30
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done