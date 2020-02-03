#!/bin/bash
Xvfb :1 -screen 0 1920x1080x24 &

# remote development
/usr/bin/rsync --daemon --config=/etc/rsync.conf &
/usr/sbin/sshd -D &

jupyter lab &

sleep 2s

x11vnc -rfbport 5900 -forever -usepw -create -display :1