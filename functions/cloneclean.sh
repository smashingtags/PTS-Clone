#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# For Clone Clean
variable /var/plexguide/cloneclean.nzb "600"
variable /var/plexguide/cloneclean.torrent "2400"
changeCloneCleanInterval() {

touch /var/plexguide/cloneclean.nzb
touch /var/plexguide/cloneclean.torrent
cleanernzb="$(cat /var/plexguide/cloneclean.nzb)"
cleanertorrenet="$(cat /var/plexguide/cloneclean.torrent)"
	if [[ "$cleanernzb" == "600" || "$cleanernzb" == "" || "$cleanernzb" == "NON-SET" ]]; then echo "600" >/var/plexguide/cloneclean.nzb; fi
	if [[ "$cleanertorrenet" == "2400" || "$cleanertorrenet" == "" || "$cleanertorrenet" == "NON-SET" ]]; then echo "2400" >/var/plexguide/cloneclean.torrent; fi

  pgclonevars

cleanernzb="$(cat /var/plexguide/cloneclean.nzb)"
cleanertorrent="$(cat /var/plexguide/cloneclean.torrent)"
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your download folder.

[1] Clone Clean NZB             [ $(cat /var/plexguide/cloneclean.nzb) min ]
[2] Clone Clean TORRENT         [ $(cat /var/plexguide/cloneclean.torrent) min ]

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty
  case $typed in
  1) ccleanernzb && changeCloneCleanInterval ;;
  2) ccleanertorrent && changeCloneCleanInterval ;;
  z) clonestart ;;
  Z) clonestart ;;
  *) changeCloneCleanInterval ;;
  esac
}
###################
ccleanernzb() {
  pgclonevars
 mxcc="720" 
 mmcc="30"
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean NZB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your downloads folder per every
[$(cat /var/plexguide/cloneclean.nzb)] minutes!

minimum is "$mmcc" | maximum is "$mxcc" 

WARNING: Do not set this too low because legitmate files!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput </dev/tty
  if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then
        changeCloneCleanInterval
  elif [[ "$varinput" =~ ^[0-9]*$ ]]; then
        if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
                  echo "$varinput" >/var/plexguide/cloneclean.nzb; fi
  elif [[ "$varinput" =~ ^[0-9a-zA-Z]*$ ]]; then
          echo "Only enter numbers! - Try again:"
          read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput </dev/tty
                  if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
                  echo "$varinput" >/var/plexguide/cloneclean.nzb; fi
  else ccleanernzb; fi
}
###################
ccleanertorrent() {
  pgclonevars
 mxcc="10800" 
 mmcc="30"
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean Torrent
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your downloads folder per every
[$(cat /var/plexguide/cloneclean.torrent)] minutes!

minimum is "$mmcc" | maximum is "$mxcc" 

WARNING: Do not set this too low because legitmate files!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput </dev/tty
  if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then
        changeCloneCleanInterval
  elif [[ "$varinput" =~ ^[0-9]*$ ]]; then
        if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
                  echo "$varinput" >/var/plexguide/cloneclean.torrent; fi
  elif [[ "$varinput" =~ ^[0-9a-zA-Z]*$ ]]; then
          echo "Only enter numbers! - Try again:"
          read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput </dev/tty
                  if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
                  echo "$varinput" >/var/plexguide/cloneclean.torrent; fi
  else ccleanertorrent; fi
}