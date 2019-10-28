#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# For Clone Clean
variable /var/plexguide/cloneclean "600"

changeCloneCleanInterval() {
  pgclonevars
cleaner="$(cat /var/plexguide/cloneclean)"
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your downloads folder per every
[$cloneCleanInterval] minutes!

TORRENT USERS: 
If you take a time of 600 now, this will
automatically doubled for the torrent folder

sample :  
cc = 300  * 2 = 600  ( torrent folder )
cc = 600  * 2 = 1200 ( torrent folder )
cc = 800  * 2 = 1600 ( torrent folder )
cc = 1000 * 2 = 2000 ( torrent folder )

WARNING: Do not set this too low because legitmate files!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Type Minutes (Minimum is 120) | PRESS [ENTER]: ' varinput </dev/tty
  if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then clonestart; fi

  if [[ "$varinput" -lt "120" ]]; then cloneclean; fi

  echo "$varinput" >/var/plexguide/cloneclean
}
