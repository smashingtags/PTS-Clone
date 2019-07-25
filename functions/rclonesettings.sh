#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
rcloneSettings() {
    pgclonevars

    bwlimitVar="move.bw"
    if [[ "$transport" == "be" || "$transport" == "bu" ]]; then
        bwlimitVar="blitz.bw"
    fi

    bwlimit=$(cat "/var/plexguide/$bwlimitVar")

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 RClone Settings                       📓 Reference: pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please read each setting description carefully as it explains the function
and has useful tips on how to change these settings.

Once you are done updating these settings, [A] Quick Deploy to take effect.

⏫ Upload Settings              Default    Current
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[1]  BW Limit                    9M        [$bwlimit]
[2]  Drive-Chunk-Size            64M       [$vfs_dcs]

⏬ Download Settings            Default    Current
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[3]  Buffer-Size                 16M       [$vfs_bs]
[4]  VFS-Read-Chunk-Size         64M       [$vfs_rcs]
[5]  VFS-Read-Chunk-Size-Limit   2048M     [$vfs_rcsl]

🔄 VFS Cache Mode Settings      Default    Current
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[6]  VFS-Cache-Mode              writes    [$vfs_cm]
[7]  VFS-Cache-Max-Age           1h        [$vfs_cma]
[8]  VFS-Cache-Max-Size          100G      [$vfs_cms]

🔣 Misc Settings                Default    Current
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[9]  Dir-Cache-Time              2m        [$vfs_dct]
[10] Log-Level                   NOTICE    [$vfs_ll]
[11] User Agent                            [$uagent]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] Apply RClone Settings
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -rp '↘️  Input Selection | Press [ENTER]: ' fluffycat </dev/tty

    case $fluffycat in
    1)
        setThrottle
        ;;
    2)
        setIntegerVariable
        ;;
    3)
        setIntegerVariable
        ;;
    4)
        setIntegerVariable
        ;;
    5)
        setIntegerVariable
        ;;
    6)
        setIntegerVariable
        ;;
    7)
        setIntegerVariable
        ;;
    8)
        setIntegerVariable
        ;;
    9)
        setIntegerVariable
        ;;
    10)
        setIntegerVariable
        ;;
    11)
        uagent
        ;;
    a)
        reloadServices
        ;;
    A)
        reloadServices
        ;;
    z)
        exit
        ;;
    Z)
        exit
        ;;
    *)
        rcloneSettings
        ;;
    esac

}

setIntegerVariable() {

    menuSelection="$fluffycat"

    if [[ "$menuSelection" == "3" ]]; then
        name="Buffer-Size"
        sizeSuffix="M"
        start="0"
        end="8096"
        note="Open files will be buffered to RAM up to this limit. This limit is per opened file.

The buffer size should be a relatively small amount. It's intended to smooth out network congestion and blips.
Having a larger buffer is not better! The buffer will get cleared when the file is closed or if the file is seeked backwards.
        
⚠️ WARNING: 

This is highly dependent on the amount of RAM and number of opened files.
Apps open several files during library scans and each file open will consume up to the amount of RAM specified.
If you set this too high and don't have enough free RAM, you will cause the mounts to crash!

buffer-size should be smaller than the [vfs-read-chunk-size] to prevent too many requests from being sent when opening a file.

Setting this too high will slow down scans and cause buffering with direct plays.

RClone will always try to fill the buffer-size, so having it higher will slow down plex scans and loading the page for it in plex.
Some plex clients open and close the file during playback, this means the buffer is constantly cleared.
This is not the plex client buffer, that's controlled by the plex client.

Set this value to 0 to disable the buffer.
        
RECOMMENDATIONS:

Set the buffer size to 1/2 the value of the read-chunk-size for the best results."
    fi

    if [[ "$menuSelection" == "2" ]]; then
        name="Drive-Chunk-Size"
        sizeSuffix="M"
        start="8"
        end="1024"
        note="The larger the chunk size, the faster uploads will be, however it uses more RAM.

64-128 will max out 1Gbps. 
Values over 128 are not recommended on 1Gbps.
Use 256 or 512 for 10Gbps.

Input must be one of the following numbers (power of 2)!
[8] [16] [32] [64] [128] [256] [512] [1024]

This setting takes effect on the next upload.
There is no need to quick deploy for this setting.
"
    fi

    if [[ "$menuSelection" == "9" ]]; then
        name="Dir-Cache-Time"
        sizeSuffix="m"
        start="1"
        end="7620"
        note="This controls the cache time for remote directory information and contents.
This may delay external changes (such as from gdrive website) from being seen on your server until the cache expires.
You should set this high unless you make lots of external changes."
    fi

    if [[ "$menuSelection" == "4" ]]; then
        name="VFS-Read-Chunk-Size"
        sizeSuffix="M"
        start="16"
        end="1024"
        note="This allows reading the source objects in parts, by requesting only chunks from the remote that are actually read at the cost of an increased number of requests.
Setting this too small will result in API bans for too many reads, setting this too high will waste download quota and it will take longer to start playback.

[vfs-read-chunk-size] should be greater than buffer-size to prevent too many requests from being sent when opening a file.
The larger the read chunk size, the faster larger files start playback, but smaller files will take longer to start.

Recommendations:
initial scan: 16MB for the fastest possible scans. Not recommended for normal playback since it makes starting a stream longer.
normal usage: 64MB-128MB, 64MB is recommended for most people and libraries.
Direct Play: 32-64MB recommended, with a buffer-size 1/2 of this value.
Transcoding: 64MB-128MB recommended.
4K Remux: 128MB if you direct play big remux files for faster start times, however smaller files will take longer to start playback."
    fi

    if [[ "$menuSelection" == "5" ]]; then
        name="VFS-Read-Chunk-Size-Limit"
        sizeSuffix="M"
        start="0"
        end="8096"
        note="The chunk size for each open file will get doubled for each chunk read, until the specified value is reached.
This limit must be greater than vfs-read-chunk-size and it's only used when the [vfs-cache-mode] is not set to full.

Set this value to 0 for unlimited growth.

This value is mostly used during transcodes or direct stream, it's not used for direct plays.

Recommendations: 2048 or 0 (for unlimited growth)."
    fi

    if [[ "$menuSelection" == "6" ]]; then
        name="VFS-Cache-Mode"
        sizeSuffix=""
        start="1"
        end="4"
        note="This setting determines if a temp vfs cache is used and the overall level of file system compatability provided.
writes is recommended for use when using encrypt or when using some community apps, such as bazarr.

1) off:
    ◽️ Files opened for read OR write will NOT be buffered to disks.
    ◽️ Files can’t be opened for both read AND write.
    ◽️ Files opened for write can’t be seeked.

2) minimal:
    ◽️ Files opened for read/write will be buffered to disks.
    ◽️ Files opened for write only can’t be seeked

3) writes (recommended): 
    ◽️ Bazarr and some other apps require this mode to function.
    ◽️ Write only and read/write files are buffered to disk first.
    ◽️ This mode should support all normal file system operations.

4) full (not recommended):
    ◽️ Playback will take a long time for bigger files as the file must be fully downloaded before playback begins.
    ◽️ All files are buffered to and from disk, files are fully downloaded on open, even on scans.
    ◽️ When a file is opened for read it will be downloaded in its entirety first.
    ◽️ This mode should support all normal file system operations."
    fi

    if [[ "$menuSelection" == "7" ]]; then
        name="VFS-Cache-Max-Age"
        sizeSuffix="h"
        start="1"
        end="720"
        note="Impacts how long files are cached on disk, only used if [vfs-cache-mode] is NOT off!"
    fi

    if [[ "$menuSelection" == "8" ]]; then
        name="VFS-Cache-Max-Size"
        sizeSuffix="G"
        start="0"
        end="8000"
        note="The max total size of objects in the cache, only used if [vfs-cache-mode] is NOT off.
Set this value to 0 to disable."
    fi

    if [[ "$menuSelection" == "9" ]]; then
        name="Log-Level"
        sizeSuffix=""
        start="1"
        end="4"
        note="1) DEBUG: It outputs lots of debug info, useful for bug reports and vfs options tuning.
2) INFO: It outputs information about each transfer and prints stats once a minute by default.
3) NOTICE (recommended): It outputs very little when things are working normally. It outputs warnings and significant events.
4) ERROR: It only outputs error messages."
    fi

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Setting Variable >>> $name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$note

Type a number between [$start] and [$end]

Input must be a valid positive integer. 

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -p '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty
    if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
        rcloneSettings
    else
        if ! [[ "$typed" =~ ^[0-9]+$ ]]; then
            invalidInputNotice
        elif [[ "$typed" -lt "$start" || "$typed" -gt "$end" ]]; then
            invalidInputNoticeNotice
        elif [[ "$menuSelection" == "3" && "$typed" != "8" && "$typed" != "16" && "$typed" != "32" && "$typed" != "64" && "$typed" != "128" && "$typed" != "256" && "$typed" != "512" && "$typed" != "1024" ]]; then
            invalidPowerInputNotice
        else
            processInput
        fi
    fi
}

processInput() {

    if [[ "$menuSelection" == "1" ]]; then echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_bs; fi
    if [[ "$menuSelection" == "2" ]]; then echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_dcs; fi
    if [[ "$menuSelection" == "3" ]]; then echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_dct; fi
    if [[ "$menuSelection" == "4" ]]; then echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_rcs; fi
    if [[ "$menuSelection" == "7" ]]; then echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_cma; fi

    if [[ "$menuSelection" == "2" ]]; then
        echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_dcs
    fi

    if [[ "$menuSelection" == "3" ]]; then
        echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_dct
    fi

    if [[ "$menuSelection" == "4" ]]; then
        echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_rcs
    fi

    if [[ "$menuSelection" == "5" ]]; then
        if [[ "$typed" == "0" ]]; then
            echo "off" >/var/plexguide/vfs_rcsl
        else
            echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_rcsl
        fi
    fi

    if [[ "$menuSelection" == "7" ]]; then
        echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_cma
    fi

    if [[ "$menuSelection" == "8" ]]; then
        if [[ "$typed" == "0" ]]; then
            echo "off" >/var/plexguide/vfs_cms
        else
            echo "${typed}${sizeSuffix}" >/var/plexguide/vfs_cms
        fi

        if [[ "$menuSelection" == "6" ]]; then
            if [[ "$typed" == "1" ]]; then echo "off" >/var/plexguide/vfs_cm; fi
            if [[ "$typed" == "2" ]]; then echo "minimal" >/var/plexguide/vfs_cm; fi
            if [[ "$typed" == "3" ]]; then echo "writes" >/var/plexguide/vfs_cm; fi
            if [[ "$typed" == "4" ]]; then echo "full" >/var/plexguide/vfs_cm; fi
        fi

        if [[ "$menuSelection" == "9" ]]; then
            if [[ "$typed" == "1" ]]; then echo "DEBUG" >/var/plexguide/vfs_ll; fi
            if [[ "$typed" == "2" ]]; then echo "INFO" >/var/plexguide/vfs_ll; fi
            if [[ "$typed" == "3" ]]; then echo "NOTICE" >/var/plexguide/vfs_ll; fi
            if [[ "$typed" == "4" ]]; then echo "ERROR" >/var/plexguide/vfs_ll; fi
        fi
    fi

    rcloneSettingUpdatedNotice
}

invalidInputNotice() {
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Invalid Input Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: The value must be a valid positive integer.
Do not input suffix letters (M,G,H)!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed </dev/tty
    setIntegerVariable
}

invalidPowerInputNotice() {
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Power of Two Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: The value you enter must be a power of two!
[8] [16] [32] [64] [128] [256] [512] [1024]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Acknowledge Info | Press [ENTER] ' fluffycat </dev/tty
    setIntegerVariable
}

reloadServices() {
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Quick Deploy                           📓 Reference: pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This will restart the rclone services for rclone settings changes to take effect.

⚠ Warning!

Please check Plex/Emby/Jellyfin and Sonarr/Radarr/Lidarr to see if they are
scanning before continuing. Restarting these services during scans is unpredictable!

EOF

    read -p '↘️  Press [ENTER] to deploy' typed </dev/tty

    buildrcloneenv
    systemctl daemon-reload
    systemctl restart gdrive 2>/dev/null
    systemctl restart gcrypt 2>/dev/null
    systemctl restart tdrive 2>/dev/null
    systemctl restart tcrypt 2>/dev/null

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Quick Deploy Complete                  📓 Reference: pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RClone services have been reloaded and your VFS options have now taken effect!

EOF

    read -p '↘️  Acknowledge Info | Press [ENTER]' typed </dev/tty

    rcloneSettings
}

uagent() {
    uagent="$(cat /var/plexguide/uagent)"
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 User Agent for RClone
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Don't use Google Chrome user agent strings, your mounts may go down.

Current User Agent: ${uagent}

Changing the useragent is useful when experience 429 problems from Google

Do not wrap the string in double quotes!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '↘️  Type User Agent | PRESS [ENTER]: ' varinput </dev/tty
    if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then rcloneSettings; fi

    echo "$varinput" >/var/plexguide/uagent
    echo $(sed -e 's/^"//' -e 's/"$//' <<<$(cat /var/plexguide/uagent)) >/var/plexguide/uagent
    rcloneSettingUpdatedNotice
}

rcloneSettingUpdatedNotice() {
    read -rp '↘️  Setting has been updated | Press [ENTER] to continue ' typed </dev/tty
    rcloneSettings
}
