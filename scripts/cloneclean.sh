#!/bin/bash
#
# Title:      remove the old garbage files
# orginal Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# MOD from MrDoobPG
# fuck of all haters
# GNU:        General Public License v3.0
################################################################################

cloneclean() {
    # Outside Variables
    cleaner="$(cat /var/plexguide/cloneclean)"
    #### Mathe part for torrent / nzb files
    ((torrent=${cleaner}*2))
    ((nzb=${cleaner}/3))

    #permissions part for clonecleaner */move folder*
    find "$(cat /var/plexguide/server.hd.path)/move" -mindepth 1 -exec chmod -cR 755 \{}\;
    find "$(cat /var/plexguide/server.hd.path)/move" -mindepth 1 -exec chown -cR 1000:1000 \{}\;

    #permissions part for clonecleaner */downloads folder*#    
    find "$(cat /var/plexguide/server.hd.path)/downloads/" -mindepth 1 -exec chmod -cR 755 \{}\;
    find "$(cat /var/plexguide/server.hd.path)/downloads/" -mindepth 1 -exec chown -cR 1000:1000 \{}\;

    #NOTE NZB CLIENTS USED THEN SAME NOW
    find "$(cat /var/plexguide/server.hd.path)/downloads/nzb/" -mindepth 1 -type d -cmin +"$(cat /var/plexguide/cloneclean)" -exec rm -rf \{} \;
    find "$(cat /var/plexguide/server.hd.path)/downloads/nzb/" -mindepth 1 -type f -size 1M -cmin +2 -exec rm -rf \{} \;
    nzbremoverunwantedfiles
    find "$(cat /var/plexguide/server.hd.path)/nzb/" -mindepth 1 -name "*.nzb.*" -type f -cmin +"$nzb" -exec rm -rf \{} \;

    #NOTE TORRENT CLIENTS USED THE SAME NOW
    find "$(cat /var/plexguide/server.hd.path)/downloads/torrent" -mindepth 2 -type d -mmin +"$torrent" -exec rm -rf \{} \;
    #DO NOT decrease DEPTH on this, leave it at 3. Leave this alone!
    find "$(cat /var/plexguide/server.hd.path)/move" -mindepth 2 -type d -empty -exec rmdir \{} \;
    find "$(cat /var/plexguide/server.hd.path)/downloads" -mindepth 3 -type d \( ! -name syncthings ! -name .stfolder \) -empty -exec rm -rf \{} \;

    # Prevents category folders underneath the downloaders from being deleted, while removing empties from the import process.
    # This was done to address some apps having an issue if the category underneath the downloader is missing.
    # Prevents category folders underneath the downloaders from being deleted, while removing empties from the import process.
    # This was done to address some apps having an issue if the category underneath the downloader is missing.
    find "$(cat /var/plexguide/server.hd.path)/downloads" -mindepth 2 -type d \( ! -name .stfolder ! -name **games** ! -name ebooks ! -name abooks ! -name sonarr** ! -name radarr** ! -name lidarr** ! -name **kids** ! -name **tv** ! -name **movies** ! -name music** ! -name audio** ! -name anime** ! -name software ! -name xxx ! -name **nzb** ! -name **torrent** \) -empty -exec rm -rf \{} \;
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
)
# advanced settings
FIND=$(which find)
FIND_BASE_CONDITION='-type f'
FIND_ADD_NAME='-o -name'
FIND_ACTION='-delete'
FIND_TIME='-cmin +1'

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

command="${FIND} '${TARGET_FOLDER}' -maxdepth 3 ${FIND_BASE_CONDITION} \( ${condition} \) ${FIND_TIME} ${FIND_ACTION}"
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
runner