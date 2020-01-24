#!/bin/bash
Xvfb :1 -screen 0 1920x1080x24 &
jupyter lab &

sleep 3s

x11vnc -rfbport 5900 -forever -usepw -create -display :1