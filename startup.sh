#!/bin/bash
set -e

sudo apt update
# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"
echo -e "set vnc password: $VNC_PW"
echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH
vncserver :1 -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION &> $HOME/vnc_startup.log
# vncserver :1 -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION

exec "$@"
