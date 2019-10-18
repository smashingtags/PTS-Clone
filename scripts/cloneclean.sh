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
    hdpath="$(cat /var/plexguide/server.hd.path)"
    cleaner="$(cat /var/plexguide/cloneclean)"

    #permissions part for clonecleaner */move folder*
    find "$hdpath/move/" -mindepth 1 -type d -exec chmod -R 775 {} \+
    find "$hdpath/move/" -mindepth 1 -type f -exec chmod -R 755 {} \+

    #NOTE NZB CLIENTS USED THEN SAME NOW
    find "$hdpath/downloads/nzb" -mindepth 1 -type f -cmin +$cleaner -size -3G 2>/dev/null -exec rm -rf  \{\} \;
    find "$hdpath/nzb/" -mindepth 1 -name "*.nzb.*" -type f -cmin +$cleaner 2>/dev/null -exec rm -rf {}  \{\} \;

    #NOTE TORRENT CLIENTS USED THE SAME NOW
    find "$hdpath/downloads/torrent" -mindepth 3 -type d -cmin +$cleaner -size -3G 2>/dev/null -exec rm -rf  \{\} \;

    # Remove empty directories
    find "$hdpath/move" -mindepth 2 -type d -empty -exec rmdir \{} \;

    #DO NOT decrease DEPTH on this, leave it at 3. Leave this alone!
    find "$hdpath/downloads" -mindepth 3 -type d \( ! -name syncthings ! -name .stfolder \) -empty -delete

    # Prevents category folders underneath the downloaders from being deleted, while removing empties from the import process.
    # This was done to address some apps having an issue if the category underneath the downloader is missing.

    find "$hdpath/downloads" -mindepth 2 -type d \( ! -name .stfolder ! -name **games** ! -name ebooks ! -name abooks ! -name sonarr** ! -name radarr** ! -name lidarr** ! -name **kids** ! -name **tv** ! -name **movies** ! -name music** ! -name audio** ! -name anime** ! -name software ! -name xxx ! -name **nzb** ! -name **torrent** \) -empty -delete
}

cloneclean
