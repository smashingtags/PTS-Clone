#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
rcstored="$(rclone --version | awk '{print $2}' | tail -n 3 | head -n 1 )"
mgstored="$(tail -n 1 /var/plexguide/checkers/mgfs.log)"
clonestartoutput() {
    pgclonevars
echo "ACTIVELY DEPLOYED: 	  $dversionoutput "
echo ""
    if [[ "$demo" == "ON " ]]; then mainid="********"; else mainid="$pgcloneemail"; fi

    if [[ "$transport" == "mu" ]]; then
        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Client ID & Secret    [ ${pgcloneid} ]
[2] GDrive                [ $gstatus ]

EOF
    elif [[ "$transport" == "me" ]]; then
        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Client ID & Secret    [ ${pgcloneid} ]
[2] Passwords             [ $pstatus ]
[3] GDrive                [ $gstatus ] - [ $gcstatus ]

EOF
    elif [[ "$transport" == "bu" ]]; then
        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Google Account Login  [ $mainid ]
[2] Project Name          [ $pgcloneproject ]
[3] Client ID & Secret    [ ${pgcloneid} ]
[4] TDrive Label          [ $tdname ]
[5] TDrive OAuth          [ $tstatu s]
[6] GDrive OAuth          [ $gstatus ] 
[7] Key Management        [ $displaykey ] Built
[8] TDrive            ( E-Mail Share Generator )
EOF
    elif [[ "$transport" == "be" ]]; then
        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Google Account Login  [ $mainid ]
[2] Project Name          [ $pgcloneproject ]
[3] Client ID & Secret    [ ${pgcloneid} ]
[4] Passwords             [ $pstatus ]
[5] TDrive Label          [ $tdname ]
[6] TDrive | TCrypt       [ $tstatus ] - [ $tcstatus ]
[7] GDrive | GCrypt       [ $gstatus ] - [ $gcstatus ]
[8] Key Management        [ $displaykey ] Built
[9] TDrive	          ( E-Mail Share Generator)
EOF
    elif [[ "$transport" == "le" ]]; then
        tee <<-EOF
NOTE: The default drive is already factored in! Only additional locations
or hard drives are required to be added!
EOF
    fi
}

errorteamdrive() {
    if [[ "$tdname" == "NOT-SET" ]]; then
        tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Setup the TDrive Label First!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Set up your TDrive Label prior to executing the TDrive OAuth.
Basically, we cannot authorize a TeamDrive without knowing which
TeamDrive is being utilized first!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed </dev/tty
        clonestart
    fi
}

clonestart() {
    pgclonevars

    # pull throttle speeds based on role
    if [[ "$transport" == "mu" || "$transport" == "me" ]]; then
        throttle=$(cat /var/plexguide/move.bw)
        output1="[C] Transport Select"
    else
        throttle=$(cat /var/plexguide/blitz.bw)
        output1="[S] RClone Settings"
    fi

    if [[ "$transport" != "mu" && "$transport" != "me" && "$transport" != "bu" && "$transport" != "be" && "$transport" != "le" ]]; then
        rm -rf /var/plexguide/pgclone.transport 1>/dev/null 2>&1
        mustset
    fi

    if [[ "$transport" == "mu" ]]; then
        outputversion="Unencrypted Move"
    elif [[ "$transport" == "me" ]]; then
        outputversion="Encrypted Move"
    elif [[ "$transport" == "bu" ]]; then
        outputversion="Unencrypted Blitz"
    elif [[ "$transport" == "be" ]]; then
        outputversion="Encrypted Blitz"
    elif [[ "$transport" == "le" ]]; then
        outputversion="Local Hard Drives"
    fi

    if [[ "$transport" == "le" ]]; then
        tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Welcome to the Local-Edition               mergerfs $mgstored
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        clonestartoutput

        tee <<-EOF

[1] Deploy     (Local HD/Mounts)
[2] MultiHD    (Add Mounts xor Hard Drives)
[3] Transport  (Change Transportion Mode)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


EOF
        read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

        localstartoutput

    else
        tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Welcome to rClone      rclone $rcstored || mergerfs $mgstored
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        clonestartoutput

        tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[A] Deploy $outputversion
[O] Options
[B] Backup Keys
[R] Restore Keys
[S] RClone Settings

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Z] Exit

EOF
        read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty
        clonestartactions
    fi
}

localstartoutput() {
    case $typed in
    1)
        executelocal
        ;;
    2)
        bash /opt/plexguide/menu/pgcloner/multihd.sh
        ;;
    3)
        transportselect
        ;;
    z)
        exit
        ;;
    Z)
        exit
        ;;
    *)
        clonestart
        ;;
    esac
    clonestart
}

clonestartactions() {
    if [[ "$transport" == "mu" ]]; then
        case $typed in
        1)
            keyinputpublic
            ;;
        2)
            publicsecretchecker
            echo "gdrive" >/var/plexguide/rclone/deploy.version
            oauth
            ;;
        z)
            exit
            ;;
        Z)
            exit
            ;;
        a)
            publicsecretchecker
            mountchecker
            deploypgmove
            ;; ## fill
        A)
            publicsecretchecker
            mountchecker
            deploypgmove
            ;; ## flll
        o) optionsmenumove ;;

        O) optionsmenumove ;;
        s)
            rcloneSettings
            ;;
        S)
            rcloneSettings
            ;;
        *)
            clonestart
            ;;
        esac
    elif [[ "$transport" == "me" ]]; then
        case $typed in
        1)
            keyinputpublic
            ;;
        2)
            publicsecretchecker
            blitzpasswordmain
            ;;
        3)
            publicsecretchecker
            passwordcheck
            echo "gdrive" >/var/plexguide/rclone/deploy.version
            oauth
            ;;
        z)
            exit
            ;;
        Z)
            exit
            ;;
        a)
            publicsecretchecker
            passwordcheck
            mountchecker
            deploypgmove
            ;; ## fill
        A)
            publicsecretchecker
            passwordcheck
            mountchecker
            deploypgmove
            ;; ## flll
        s)
            rcloneSettings
            ;;
        S)
            rcloneSettings
            ;;
        o) optionsmenumove ;;

        O) optionsmenumove ;;
        *)
            clonestart
            ;;
        esac
    elif [[ "$transport" == "bu" ]]; then
        case $typed in
        1)
            glogin
            ;;
        2)
            exisitingproject
            ;;
        3)
            keyinputpublic
            ;;
        4)
            publicsecretchecker
            tlabeloauth
            ;;
        5)
            publicsecretchecker
            tlabelchecker
            echo "tdrive" >/var/plexguide/rclone/deploy.version
            oauth
            ;;
        6)
            publicsecretchecker
            echo "gdrive" >/var/plexguide/rclone/deploy.version
            oauth
            ;;
        7)
            publicsecretchecker
            tlabelchecker
            mountchecker
            projectnamecheck
            keystart
            gdsaemail
            ;;
        8)
            publicsecretchecker
            tlabelchecker
            mountchecker
            projectnamecheck
            deployblitzstartcheck
            emailgen
            ;;
        z)
            exit
            ;;
        Z)
            exit
            ;;
        a)
            publicsecretchecker
            tlabelchecker
            mountchecker
            deploypgblitz
            ;; ## fill
        A)
            publicsecretchecker
            tlabelchecker
            mountchecker
            deploypgblitz
            ;; ## flll
        b)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;; ## fill
        B)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;; ## flll
        r)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;; ## fill
        R)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;;
        s)
            rcloneSettings
            ;;
        S)
            rcloneSettings
            ;;
        o) optionsmenumove ;;

        O) optionsmenumove ;;
        *)
            clonestart
            ;;
        esac
    elif [[ "$transport" == "be" ]]; then
        case $typed in
        1)
            glogin
            ;;
        2)
            exisitingproject
            ;;
        3)
            keyinputpublic
            ;;
        4)
            publicsecretchecker
            blitzpasswordmain
            ;;
        5)
            publicsecretchecker
            tlabeloauth
            ;;
        6)
            publicsecretchecker
            passwordcheck
            tlabelchecker
            echo "tdrive" >/var/plexguide/rclone/deploy.version
            oauth
            ;;
        7)
            publicsecretchecker
            passwordcheck
            echo "gdrive" >/var/plexguide/rclone/deploy.version
            oauth
            ;;

        8)
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            projectnamecheck
            keystart
            gdsaemail
            ;;
        9)
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            projectnamecheck
            deployblitzstartcheck
            emailgen
            ;;
        z)
            exit
            ;;
        Z)
            exit
            ;;
        a)
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            deploypgblitz
            ;; ## fill
        A)
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            deploypgblitz
            ;; ## flll
        b)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;; ## fill
        B)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;; ## flll
        r)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup
            ;; ## fill
        R)
            publicsecretchecker
            passwordcheck
            mountchecker
            keybackup ;;
        o) optionsmenu ;;
        O) optionsmenu ;;
        s)
            rcloneSettings
            ;;
        S)
            rcloneSettings
            ;;
        *)
            clonestart
            ;;
        esac
    fi
    clonestart
}

# For Blitz
optionsmenu() {
    pgclonevars
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Options Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Transport Select             | INFO: Change Transport Type
[2] Multi-HD Option              | INFO: Add Multi-Points and Options
[3] Destroy All Service Keys     | WARN: Wipes All Keys for the Project
[4] Create New Project           | WARN: Resets Everything
[5] Demo Mode                    | Hide the E-Mail Address on the Front
[6] Clone Clean                  | [$cloneCleanInterval] minutes

[7] Create a TeamDrive

NOTE: When creating a NEW PROJECT, the USER must create the
CLIENT ID and SECRET for that project! We will assist in creating the
project and enabling the API! Everything resets when complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1)
        transportselect
        clonestart
        ;;
    2)
        bash /opt/plexguide/menu/pgcloner/multihd.sh
        ;;
    3)
        deletekeys
        ;;
    4)
        projectnameset
        ;;
    5)
        demomode
        ;;
    6)
        changeCloneCleanInterval
        ;;
    7)
        ctdrive
        ;;
    Z)
        clonestart
        ;;
    z)
        clonestart
        ;;
    *)
        optionsmenu
        ;;
    esac
    optionsmenu
}

# For Move
optionsmenumove() {
    pgclonevars
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Options Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Transport Select           | INFO: Change Transport Type
[2] Multi-HD Option            | INFO: Add Multi-Points and Options
[3] Clone Clean                | [$cloneclean] minutes

NOTE: When creating a NEW PROJECT, the USER must create the
CLIENT ID and SECRET for that project! We will assist in creating the
project and enabling the API! Everything resets when complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1)
        transportselect
        clonestart
        ;;
    2)
        bash /opt/plexguide/menu/pgcloner/multihd.sh
        ;;
    3)
        changeCloneCleanInterval
        ;;
    Z)
        clonestart
        ;;
    z)
        clonestart
        ;;
    *)
        optionsmenu
        ;;
    esac
    optionsmenu
}

demomode() {
    if [[ "$demo" == "OFF" ]]; then
        echo "ON " >/var/plexguide/pgclone.demo
    else echo "OFF" >/var/plexguide/pgclone.demo; fi

    pgclonevars
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 DEMO MODE IS NOW: $demo | PRESS [ENTER] to CONFIRM!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '' typed </dev/tty
    optionsmenu

}

keybackup() {

  serverid=$(cat /var/plexguide/pg.serverid)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Backing Up to GDrive - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Standby, takes a minute!

EOF
  rclone purge --config /opt/appdata/plexguide/rclone.conf gdrive:/plexguide/backup/keys/$serverid
  rclone copy --config /opt/appdata/plexguide/rclone.conf /opt/appdata/plexguide/rclone.conf gdrive:/plexguide/backup/keys/$serverid/conf -v --checksum --drive-chunk-size=64M
  rclone copy --config /opt/appdata/plexguide/rclone.conf /opt/appdata/plexguide/keys/processed/ gdrive:/plexguide/backup/keys/$serverid/keys -v --checksum --drive-chunk-size=64M

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Backup Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 </dev/tty
}

keyrestore() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby! Conducting Key Restore Check!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rclone lsd --config /opt/appdata/plexguide/rclone.conf gdrive:/plexguide/backup/keys/ | awk '{ print $5 }' >/tmp/service.keys
  checkcheck=$(cat /tmp/service.keys)

  if [ "$checkcheck" == "" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Either You Failed to Configure RClone with GDrive or No Backups Exist!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '🌍 Acknowledge Info | Press [ENTER] ' typed </dev/tty
    keymenu
  fi

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Type the Name of the Backup to Restore
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Quit? Type > exit

EOF
  cat /tmp/service.keys

  echo
  read -p '🌍 Type Name | Press [ENTER]: ' typed </dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then keymenu; fi

  grepcheck=$(cat /tmp/service.keys | grep $typed)
  if [ "$grepcheck" == "" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Failed to Type Name of a Backup on the list! Restarting process!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '🌍 Acknowledge Info | Press [ENTER] ' typed </dev/tty
    keyrestore
  fi

  serverid="$typed"
  mkdir -p /opt/appdata/plexguide/processed

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Restoring Keys - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rclone copy --config /opt/appdata/plexguide/rclone.conf gdrive:/plexguide/backup/keys/$serverid/conf /opt/appdata/plexguide/ -v --checksum --drive-chunk-size=64M
  rclone copy --config /opt/appdata/plexguide/rclone.conf gdrive:/plexguide/backup/keys/$serverid/keys /opt/appdata/plexguide/keys/processed/ -v --checksum --drive-chunk-size=64M

  tee <<-EOF
  
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Key Restoration Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: When conducting a restore, no need to share out emails and etc! Just
redeploy PGBlitz!

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 </dev/tty
  keymenu
}