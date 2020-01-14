#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# BAD INPUT
badinput() {
    echo
    read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
}
variable /var/plexguide/project.email "NOT-SET"
emailaccount=$(cat /var/plexguide/project.email)

glogin() {
if [[ "$emailaccount" == "NOT-SET" ]]; then
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " Email Account - NOT-SET - First Start "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 fi
  
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set E-Mail Address
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
What email address from the Google Console do you want to be associated
with from your Google GSuite? Ensure that it exists!

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF


    read -p '↘️  Input E-Mail | Press [ENTER]: ' typed </dev/tty

    if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
        clonestart
     else
    echo $typed >/var/plexguide/project.accountvalid
    eduvalid=$(sed -n '1p' /var/plexguide/project.accountvalid |  cut -d\; -f1 | grep edu)
    if [[ "$eduvalid" != "" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          We do not condone or support users of
        this service whom are using Education accounts.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 30
           exit 1   
   else gcllg; fi
  fi
}

gcllg() {
    gcloud auth login --account = $(cat /var/plexguide/project.accountvalid)
    gcloud info | grep Account: | cut -c 10- >/var/plexguide/project.account
    account=$(cat /var/plexguide/project.account)
    testcheck=$(gcloud auth list | grep "$(cat /var/plexguide/project.accountvalid)")
    if [[ "$testcheck" == "" ]]; then
        echo
        echo "INFO CHECK: E-Mail Address Failed!"
        read -p '↘️  Acknowledge Info | Press [ENTER] ' typed </dev/tty
        glogin
    fi
    cp -rv /var/plexguide/project.accountvalid /var/plexguide/pgclone.email
}
