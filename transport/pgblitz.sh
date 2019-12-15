#!/bin/bash
#
# Title:      TDrive Uploader 
# orgAuthors:    Admin9705, Deiteq, and many PGBlitz Contributors
# Mod from MrDoobPG for all 
#
# fuck off brandings 
################################################################################

source /opt/pgclone/scripts/cloneclean.sh

# Starting Actions
touch /var/plexguide/logs/pgblitz.log
truncate -s 0 /var/plexguide/logs/pgblitz.log

echo "" >>/var/plexguide/logs/pgblitz.log
echo "" >>/var/plexguide/logs/pgblitz.log
echo " -- Starting Blitz: $(date "+%Y-%m-%d %H:%M:%S") -- " >>/var/plexguide/logs/pgblitz.log
hdpath="$(cat /var/plexguide/server.hd.path)"

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

        if [[ $cyclecount -gt 4294967295 ]]; then
            cyclecount=0
        fi

        echo "" >>/var/plexguide/logs/pgblitz.log
        echo " -- Begin cycle $cyclecount --  $p: $(date "+%Y-%m-%d %H:%M:%S") --" >>/var/plexguide/logs/pgblitz.log
        echo "Checking for files to upload..." >>/var/plexguide/logs/pgblitz.log

        rsync "$hdpath/downloads/" "$hdpath/move/" \
            -aqp --remove-source-files --link-dest="$hdpath/downloads/" \
            --exclude-from="/opt/appdata/plexguide/transport-tdrive.exclude" \
            --exclude-from="/opt/pgclone/excluded/excluded.folder"

        if [[ $(find "$hdpath/move" -type f | wc -l) -gt 0 ]]; then
            rclone moveto "$hdpath/move" "${p}{{encryptbit}}:/" \
                --config=/opt/appdata/plexguide/rclone.conf \
                --log-file=/var/plexguide/logs/pgblitz.log \
                --log-level=INFO --stats=5s --stats-file-name-length=0 \
                --max-size=300G \
                --tpslimit=10 \
                --checkers="$vfs_c" \
                --transfers="$vfs_t" \
                --no-traverse \
                --fast-list \
                --max-transfer "$vfs_mt" \
                --bwlimit="$bwlimit" \
                --drive-chunk-size="$vfs_dcs" \
                --user-agent="$useragent" \
                --exclude-from="/opt/appdata/plexguide/transport-tdrive.exclude" \
                --exclude-from="/opt/pgclone/excluded/excluded.folder"

            echo " Upload has finished. " >>/var/plexguide/logs/pgblitz.log
        else
            echo " No files in $hdpath/move to upload. " >>/var/plexguide/logs/pgblitz.log
        fi

        echo " -- Completed cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S") -- " >>/var/plexguide/logs/pgblitz.log
        echo "  $(tail -n 200 /var/plexguide/logs/pgblitz.log)" >/var/plexguide/logs/pgblitz.log
        #sed -i -e "/Duplicate directory found in destination/d" /var/plexguide/logs/pgblitz.log
        sleep 30

        cloneclean

    done </var/plexguide/.blitzfinal
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done
