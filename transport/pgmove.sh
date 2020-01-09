
#!/bin/bash
#
# Title:      GDrive Uploader
# Authors:    MrDoob
#
# fuck off brandings
################################################################################
touch /var/plexguide/logs/pgmove.log
truncate -s 0 /var/plexguide/logs/pgmove.log
echo "" >>/var/plexguide/logs/pgmove.log
echo "---Starting Move: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log

startscript() {
while true; do

     rsync "$(cat /var/plexguide/server.hd.path)/downloads/" "$(cat /var/plexguide/server.hd.path)/move/" \
      -aq --remove-source-files --link-dest="$(cat /var/plexguide/server.hd.path)/downloads/" \
      --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" \
      --exclude-from="/opt/pgclone/excluded/excluded.folder"
      if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -lt 1 ]]; then rczero; fi
      if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -gt 1 ]]; then rcupload; fi

 done
 cloneclean
 startscript
}
################################################################################
rczero() {
 sleep 5
}
rcupload() {
   let "cyclecount++"
   if [[ $cyclecount -gt 4294967295 ]]; then cyclecount=0; fi

    echo "" >>/var/plexguide/logs/pgblitz.log
    echo " -- Starting Move Upload cycle $cyclecount - $(date "+%Y-%m-%d %H:%M:%S") --" >>/var/plexguide/logs/pgblitz.log

    useragent="$(cat /var/plexguide/uagent)"
    bwlimit="$(cat /var/plexguide/move.bw)"
    vfs_dcs="$(cat /var/plexguide/vfs_dcs)"

    rclone move "$(cat /var/plexguide/server.hd.path)/move/" "gdrive:/" \
       --config=/opt/appdata/plexguide/rclone.conf \
       --log-file=/var/plexguide/logs/pgmove.log \
       --log-level=INFO --stats=5s --stats-file-name-length=0 \
       --max-size=300G --tpslimit=18 --checkers=8 --transfers=4 --no-traverse --fast-list \
       --max-transfer 740G --bwlimit="$bwlimit" \
       --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
       --exclude-from="/opt/pgclone/transport/transport-gdrive.exclude" --exclude-from="/opt/pgclone/excluded/excluded.folder"
    echo " -- Completed complete for cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgmove.log
    echo "$(tail -n 200 /var/plexguide/logs/pgmove.log)" >/var/plexguide/logs/pgmove.log
}

cloneclean() {
bash /opt/pgclone/scripts/cloneclean.sh
}
# keeps the function in a loop
startscript