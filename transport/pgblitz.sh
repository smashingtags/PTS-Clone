#!/bin/bash
#
# Title:      TDrive Uploader
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
  vfs_dcs="$(cat /var/plexguide/vfs_dcs)"
  vfs_mt="$(cat /var/plexguide/vfs_mt)"
  vfs_t="$(cat /var/plexguide/vfs_t)"
  vfs_c="$(cat /var/plexguide/vfs_c)"
  let "cyclecount++"
  if [[ $cyclecount -gt 4294967295 ]]; then cyclecount=0; fi
  echo "" >>/var/plexguide/logs/pgblitz.log
  echo " -- Starting Blitz: cycle $cyclecount: $p: $(date "+%Y-%m-%d %H:%M:%S") --" >>/var/plexguide/logs/pgblitz.log
  rsync "$(cat /var/plexguide/server.hd.path)/downloads/" "$(cat /var/plexguide/server.hd.path)/move/" \
    -aq --remove-source-files --link-dest="$(cat /var/plexguide/server.hd.path)/downloads/" \
    --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" --exclude-from="/opt/pgclone/excluded/excluded.folder"
  if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -gt 1 ]]; then
   rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "${p}{{encryptbit}}:/" \
       --config=/opt/appdata/plexguide/rclone.conf \
       --log-file=/var/plexguide/logs/pgblitz.log \
       --log-level=INFO --stats=5s --stats-file-name-length=0 \
       --max-size=100G --min-age 30s --tpslimit=8 \
       --drive-pacer-min-sleep=100ms --checkers="$vfs_c" \
       --transfers="$vfs_t" --no-traverse --fast-list \
       --max-transfer "$vfs_mt" --bwlimit="$bwlimit" \
       --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
       --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" --exclude-from="/opt/pgclone/excluded/excluded.folder"
       echo " -- Upload has finished -- " >>/var/plexguide/logs/pgblitz.log
       echo "$(tail -n 200 /var/plexguide/logs/pgblitz.log)" >>/var/plexguide/logs/pgblitz.log
  else
       echo " No files in $(cat /var/plexguide/server.hd.path)/move to upload. $(date "+%Y-%m-%d %H:%M:%S") " >>/var/plexguide/logs/pgblitz.log
  fi
  bash /opt/pgclone/scripts/cloneclean.sh
  if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f \( -name *.srt -o -name *.idx -o -name *.sub \) ) ]]; then
    catter=$(cat /opt/appdata/plexguide/rclone.conf | grep "GDSA01C")
    if [[ "$catter" == "[GDSA01C]" ]]; then
     rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "gcrypt:/" \
        --config=/opt/appdata/plexguide/rclone.conf \
        --log-file=/var/plexguide/logs/pgblitz.log \
        --log-level=INFO --stats=5s --stats-file-name-length=0 \
        --max-size=100G --min-age 1m --tpslimit=8 \
        --drive-pacer-min-sleep=100ms --checkers=8 \
        --transfers="$vfs_t" --no-traverse \
        --fast-list --max-transfer 750G --bwlimit="$bwlimit" \
        --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
        --include="*.srt*" --include="*.idx" --include="*.sub"
        echo " -- Subs Upload has finished to GDCRYPT: --" >>/var/plexguide/logs/pgblitz.log
    fi
    if [[ "$catter" != "[GDSA01C]" ]]; then
        rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "gdrive:/" \
        --config=/opt/appdata/plexguide/rclone.conf \
        --log-file=/var/plexguide/logs/pgblitz.log \
        --log-level=INFO --stats=5s --stats-file-name-length=0 \
        --max-size=100G --min-age 1m --tpslimit=8 \
        --drive-pacer-min-sleep=100ms --checkers=8 \
        --transfers="$vfs_t" --no-traverse \
        --fast-list --max-transfer 750G --bwlimit="$bwlimit" \
        --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
        --include="*.srt*" --include="*.idx" --include="*.sub"
        echo " -- Subs Upload has finished to GDRIVE: --" >>/var/plexguide/logs/pgblitz.log
    fi
  else
      echo " No Subs in $(cat /var/plexguide/server.hd.path)/move to upload. $(date "+%Y-%m-%d %H:%M:%S") " >>/var/plexguide/logs/pgblitz.log
  fi
      echo " -- Completed Blitz cycle $cyclecount - $p:  $(date "+%Y-%m-%d %H:%M:%S") -- " >>/var/plexguide/logs/pgblitz.log
      sleep 30
done </var/plexguide/.blitzfinal
}
# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done