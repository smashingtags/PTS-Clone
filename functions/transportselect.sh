#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
transportselect() {
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set Clone Method 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: Please visit the link and understand what your doing first!

LINK : https://github.com/MHA-Team/PTS-Team/wiki/PTS-Clone

[1] Move  Unencrypt: Data > GDrive | Novice  | 750GB Daily Transfer Max
[2] Move  Encrypted: Data > GDrive | Novice  | 750GB Daily Transfer Max
[3] Blitz Unencrypt: Data > TDrive | Complex | Exceed 750GB Transport Cap
[4] Blitz Encrypted: Data > TDrive | Complex | Exceed 750GB Transport Cap

[5] Local Edition  : Local HDs     | Easy    | Utilizes System's HD's Only

[Z] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -rp '↘️  Input Selection | Press [ENTER]: ' typed </dev/tty

    case $typed in
    1)
        echo "mu" >/var/plexguide/pgclone.transport
        echo "Move" >/var/plexguide/pg.transport
        ;;
    2)
        echo "me" >/var/plexguide/pgclone.transport
        echo "Move Encrypted" >/var/plexguide/pg.transport
        ;;
    3)
        echo "bu" >/var/plexguide/pgclone.transport
        echo "Blitz" >/var/plexguide/pg.transport
        ;;
    4)
        echo "be" >/var/plexguide/pgclone.transport
        echo "Blitz Encrypted" >/var/plexguide/pg.transport
        ;;
    5)
        echo "le" >/var/plexguide/pgclone.transport
        echo "Local Edition" >/var/plexguide/pg.transport
        ;;
	z)
      exit
      ;;
    Z)
      exit
      ;;
    *)
        transportselect
        ;;
    esac
}
