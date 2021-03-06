#!/bin/bash
# Author: John Nguyen
# This script...
# - enforces libpam-pwquality
# - configure password expiration in /etc/login.defs
# - change min, max, and warnings for password expiration
#     of current users
# - change all passwords of valid users
# - configure lockout policy

RED="31"
GREEN="32"
BOLDGREEN="\e[1;${GREEN}m"
BOLDRED="\e[1;${RED}m"
ENDCOLOR="\e[0m"

FAILED=$false

#######################################
# Checks the exit code of last command and reports success or failure
# Globals:
#     BOLDGREEN, BOLDRED, ENDCOLOR
# Arguments:
#     command name
# Outputs:
#     Writes output to stdout
# Returns:
#     0 if command exited successfully, 1 if failed.
#######################################
function check_status() {
if [ "$?" -eq "0" ]; then
    echo -e "${BOLDGREEN}SUCCESS: ${1} ${ENDCOLOR}"
else
    echo -e "${BOLDRED}FAILED: ${1} ${ENDCOLOR}"
    FAILED=$true
    exit 1
fi
}

#######################################
#          MAIN CODE GOES HERE        #
#######################################

# install libpam-pwquality
apt install -y libpam-pwquality 1> /dev/null
check_status "apt install libpam-pwquality"

# make backup of common-password
cp /etc/pam.d/common-password /etc/pam.d/common-password.bak
check_status "cp /etc/pam.d/common-password /etc/pam.d/common-password.bak"

# configure lockout policy
cat ./config_files/common-auth.txt > /etc/pam.d/common-auth
check_status "cat ./config_files/common-auth.txt > /etc/pam.d/common-auth"

# modify line with "pam_pwquality.so"


# TODO: change password of all users to "(yb3rP4tr10ts!"

# Exit with explicity exit code
if [[ "$FAILED" -eq "$true" ]]; then
    exit 1
else
    exit 0
fi