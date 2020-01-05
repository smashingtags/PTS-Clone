#!/bin/bash
#
# Title:      remove the old garbage files
# orginal Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# MOD from MrDoobPG
# fuck of all haters
# GNU:        General Public License v3.0
################################################################################

cloneclean() {
    runner
    find "$(cat /var/plexguide/server.hd.path)/move" -mindepth 1 -exec chmod -cR 755 {} \+
    find "$(cat /var/plexguide/server.hd.path)/move" -mindepth 1 -exec chown -cR 1000:1000 {} \+
    find "$(cat /var/plexguide/server.hd.path)/downloads/" -mindepth 1 -exec chmod -cR 755 {} \+
    find "$(cat /var/plexguide/server.hd.path)/downloads/" -mindepth 1 -exec chown -cR 1000:1000 {} \+
	##NZB Area
    find "$(cat /var/plexguide/server.hd.path)/downloads/nzb" -mindepth 2 -type f -cmin +"$(cat /var/plexguide/cloneclean.nzb)" -delete
    find "$(cat /var/plexguide/server.hd.path)/downloads/nzb" -mindepth 2 -type f -size -2M -cmin +"$(cat /var/plexguide/cloneclean.nzb)" -delete
    find "$(cat /var/plexguide/server.hd.path)/downloads/nzb" -mindepth 2 -type d -empty -cmin +"$(cat /var/plexguide/cloneclean.nzb)" -delete
    find "$(cat /var/plexguide/server.hd.path)/nzb/" -mindepth 1 -name "*.nzb.*" -type f -cmin +"$(cat /var/plexguide/cloneclean.nzb)" -delete    
	nzbremoverunwantedfiles
    #Torrent Area
    find "$(cat /var/plexguide/server.hd.path)/downloads/torrent" -mindepth 2 -type f -cmin +"$(cat /var/plexguide/cloneclean.torrent)" -delete
    find "$(cat /var/plexguide/server.hd.path)/downloads/torrent" -mindepth 2 -type d -empty -delete
    find "$(cat /var/plexguide/server.hd.path)/move" -mindepth 2 -type d -empty -delete
}
nzbremoverunwantedfiles() {
UNWANTED_FILES=(
'*.nfo'
'*.jpeg'
'*.jpg'
'*.rar'
'*.r[a0-9][r0-9]'
'*sample*'
'*.sh'
'*.1'
'*.2'
'*.3'
'*.4'
'*.5'
'*.6'
'*.7'
'*.8'
'*.9'
'*.10'
'*.html~'
'*.url'
'*.htm'
'*.html'
'*.sfv'
'*.pdf'
'*.xml'
'*.avi'
'*.exe'
'*.lsn'
'*.nzb'
'Click.rar'
'What.rar'
)
# advanced settings
FIND=$(which find)
FIND_BASE_CONDITION='-type f'
FIND_ADD_NAME='-o -name'
FIND_ACTION='-delete'
#Folder Setting
TARGET_FOLDER=$1"$(cat /var/plexguide/server.hd.path)/downloads/nzb/"
if [ ! -d "${TARGET_FOLDER}" ]; then
   echo 'Target directory does not exist.'
   exit 1
fi
condition="-name '${UNWANTED_FILES[0]}'"
for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++))
do
    condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
done
command="${FIND} '${TARGET_FOLDER}' -maxdepth 3 ${FIND_BASE_CONDITION} \( ${condition} \) ${FIND_ACTION}"
echo "Executing ${command}"
eval "${command}"
}

removefilestdrive() {
UNWANTED_FILES=(
'*.nfo'
'*.jpeg'
'*.jpg'
'*.srt'
'*.idx'
'*.rar'
'*.r[a0-9][r0-9]'
'*sample*'
)
# advanced settings
FIND=$(which find)
FIND_BASE_CONDITION='-type f'
FIND_ADD_NAME='-o -name'
FIND_ACTION='-delete'
#Folder Setting
TARGET_FOLDER=$1"$(cat /var/plexguide/server.hd.path)/downloads/"
if [ ! -d "${TARGET_FOLDER}" ]; then
   echo 'Target directory does not exist.'
   exit 1
fi
condition="-name '${UNWANTED_FILES[0]}'"
for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++))
do
    condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
done
command="${FIND} '${TARGET_FOLDER}' -maxdepth 3 ${FIND_BASE_CONDITION} \( ${condition} ! -name **nzb** ! -name **torrent** \) ${FIND_ACTION}"
echo "Executing ${command}"
eval "${command}"
}
removefilesgdrive() {
UNWANTED_FILES=(
'*.nfo'
'*.rar'
'*.r[a0-9][r0-9]'
'*sample*'
)
# advanced settings
FIND=$(which find)
FIND_BASE_CONDITION='-type f'
FIND_ADD_NAME='-o -name'
FIND_ACTION=' -delete'
#Folder Setting
TARGET_FOLDER=$1"$(cat /var/plexguide/server.hd.path)/downloads/"
if [ ! -d "${TARGET_FOLDER}" ]; then
   echo 'Target directory does not exist.'
   exit 1
fi
condition="-name '${UNWANTED_FILES[0]}'"
for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++))
do
    condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
done
command="${FIND} '${TARGET_FOLDER}' -maxdepth 3 ${FIND_BASE_CONDITION} \( ${condition} ! -name **nzb** ! -name **torrent** \) ${FIND_ACTION}"
echo "Executing ${command}"
eval "${command}"
}
runner() {
rpat=$(cat /var/plexguide/status.mounts)
if [[ $rpat != "1" ]]; then
removefilestdrive && nzbremoverunwantedfiles
else removefilesgdrive && nzbremoverunwantedfiles; fi
}