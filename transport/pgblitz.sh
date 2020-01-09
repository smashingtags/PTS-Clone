#!/bin/bash
#
# Title:      TDrive Uploader
# Authors:    MrDoob
# 
# fuck off brandings
################################################################################
# Starting Actions
touch /var/plexguide/logs/pgblitz.log
truncate -s 0 /var/plexguide/logs/pgblitz.log
echo "" >>/var/plexguide/logs/pgblitz.log

startscript() {
 while read p; do
   let "cyclecount++"
   if [[ $cyclecount -gt 4294967295 ]]; then cyclecount=0; fi
     rsync "$(cat /var/plexguide/server.hd.path)/downloads/" "$(cat /var/plexguide/server.hd.path)/move/" \
      -aq --remove-source-files --link-dest="$(cat /var/plexguide/server.hd.path)/downloads/" \
      --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" \
      --exclude-from="/opt/pgclone/excluded/excluded.folder"
    echo "" >>/var/plexguide/logs/pgblitz.log
    echo " -- Starting Blitz cycle $cyclecount - $p: $(date "+%Y-%m-%d %H:%M:%S") --" >>/var/plexguide/logs/pgblitz.log
      if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -lt 1 ]]; then rczero; fi
      if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -eq 1 ]]; then rcone; fi
      if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f | wc -l ) -gt 1 ]]; then rcupload; fi
	  ###adon later
	  #if [[ $(find "$(cat /var/plexguide/server.hd.path)/move" -type f \( -name *.srt -o -name *.idx -o -name *.sub \) ) ]]; then rcdrive; fi
	  ###adon later
    echo " -- Completed cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S")---" >>/var/plexguide/logs/pgblitz.log
    echo "$(tail -n 200 /var/plexguide/logs/pgblitz.log)" >/var/plexguide/logs/pgblitz.log
 done </var/plexguide/.blitzfinal
 cloneclean
 startscript
}
################################################################################
rczero() {
 echo " -- No files in $(cat /var/plexguide/server.hd.path)/move to upload. $(date "+%Y-%m-%d %H:%M:%S") " >>/var/plexguide/logs/pgblitz.log
 sleep 5
}
rcone() {
 echo " -- one file is in $(cat /var/plexguide/server.hd.path)/move --">>/var/plexguide/logs/pgblitz.log
 echo " -- waiting for next file before uploading starting -- " >>/var/plexguide/logs/pgblitz.log
 sleep 5
}
rcupload() {
sleep 5
 while read p; do
   useragent="$(cat /var/plexguide/uagent)"
   bwlimit="$(cat /var/plexguide/blitz.bw)"
   vfs_dcs="$(cat /var/plexguide/vfs_dcs)"
   vfs_mt="$(cat /var/plexguide/vfs_mt)"
   vfs_t="$(cat /var/plexguide/vfs_t)"
   vfs_c="$(cat /var/plexguide/vfs_c)"

 rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "${p}{{encryptbit}}:/" \
    --config=/opt/appdata/plexguide/rclone.conf \
    --log-file=/var/plexguide/logs/pgblitz.log \
    --log-level=INFO --stats=5s --stats-file-name-length=0 \
    --max-size=300G --min-age 1m --tpslimit=8 \
    --drive-pacer-min-sleep=100ms --checkers="$vfs_c" \
    --transfers="$vfs_t" --no-traverse \
    --fast-list --max-transfer "$vfs_mt" --bwlimit="$bwlimit" \
    --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
    --exclude-from="/opt/pgclone/transport/transport-tdrive.exclude" \
    --exclude-from="/opt/pgclone/excluded/excluded.folder"
  echo " -- Upload has finished --" >>/var/plexguide/logs/pgblitz.log
sleep 30
 done </var/plexguide/.blitzfinal
sleep 5
}
rcdrive() {
   useragent="$(cat /var/plexguide/uagent)"
   bwlimit="$(cat /var/plexguide/blitz.bw)"
   vfs_dcs="$(cat /var/plexguide/vfs_dcs)"
   vfs_mt="$(cat /var/plexguide/vfs_mt)"
   vfs_t="$(cat /var/plexguide/vfs_t)"
   vfs_c="$(cat /var/plexguide/vfs_c)"
   catter="$(cat /opt/appdata/plexguide/rclone.conf | grep "GDSA01C" )"

if [[ "$catter" == "[GDSA01C]" ]]; then
 rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "gcrypt:/" \
    --config=/opt/appdata/plexguide/rclone.conf \
    --log-file=/var/plexguide/logs/pgblitz.log \
    --log-level=INFO --stats=5s --stats-file-name-length=0 \
    --max-size=300G --min-age 1m --tpslimit=8 \
    --drive-pacer-min-sleep=100ms --checkers=8 \
    --transfers="$vfs_t" --no-traverse \
    --fast-list --max-transfer "$vfs_mt" --bwlimit="$bwlimit" \
    --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
    --include="*.srt*" --include="*.idx" --include="*.sub"
  echo " -- Subs Upload has finished to GDCRYPT:--" >>/var/plexguide/logs/pgblitz.log
  fi

if [[ "$catter" != "[GDSA01C]" ]]; then
 rclone moveto "$(cat /var/plexguide/server.hd.path)/move" "gdrive:/" \
    --config=/opt/appdata/plexguide/rclone.conf \
    --log-file=/var/plexguide/logs/pgblitz.log \
    --log-level=INFO --stats=5s --stats-file-name-length=0 \
    --max-size=300G --min-age 1m --tpslimit=8 \
    --drive-pacer-min-sleep=100ms --checkers=8 \
    --transfers="$vfs_t" --no-traverse \
    --fast-list --max-transfer "$vfs_mt" --bwlimit="$bwlimit" \
    --drive-chunk-size="$vfs_dcs" --user-agent="$useragent" \
    --include="*.srt*" --include="*.idx" --include="*.sub"
  echo " -- Subs Upload has finished to GDRIVE:--" >>/var/plexguide/logs/pgblitz.log
  fi
}
cloneclean() {
bash /opt/pgclone/scripts/cloneclean.sh
}
# keeps the function in a loop
startscript
