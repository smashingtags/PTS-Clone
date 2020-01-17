# #!/bin/bash
# #
# # Title:      PGBlitz (Reference Title File)
# # Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# # URL:        https://pgblitz.com - http://github.pgblitz.com
# # GNU:        General Public License v3.0
# ################################################################################

    # uagent="$(cat /var/plexguide/uagent)"
    # tee <<-EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀 User Agent for RClone
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# NOTE: Don't use Google Chrome user agent strings, your mounts may go down.

# Current User Agent: ${uagent}

# Changing the useragent is useful when experience 429 problems from Google

# Do not wrap the string in double quotes!

# for Random useragent typ >> random or RANDOM

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# [Z] Exit
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# EOF

    # read -p '↘️  Type User Agent | PRESS [ENTER]: ' varinput </dev/tty
    # if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then rcloneSettings; fi
# #######userinput##
    # echo "$varinput" >/var/plexguide/uagent
    # echo $(sed -e 's/^"//' -e 's/"$//' <<<$(cat /var/plexguide/uagent)) >/var/plexguide/uagent
    # settingUpdatedNotice;
    # rcloneSettings
# #######random part###
# uagentrandom="$(cat /var/plexguide/uagent)"
    # if [[ "$uagentrandom" == "random" || "$uagentrandom" == "RANDOM"  ]]; then
    # randomagent=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    # uagent=$(cat /var/plexguide/uagent)
    # echo "$randomagent" >/var/plexguide/uagent
    # echo $(sed -e 's/^"//' -e 's/"$//' <<<$(cat /var/plexguide/uagent)) >/var/plexguide/uagent
    # fi
        # sleep 5
        # tee <<-EOF
                # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                # 🚀 Updated User Agent for RClone now $(cat /var/plexguide/uagent)
                # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
			# EOF
    # settingUpdatedNotice ;
    # rcloneSettings
