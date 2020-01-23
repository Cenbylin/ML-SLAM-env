#!/bin/bash
jupyter lab &

Xvfb :1 -screen 0 1920x1080x24 &
DISPLAY=:1 $COPPELIASIM_ROOT/coppeliaSim.sh --server-args="-screen 0 1280x1024x24" &

x11vnc -rfbport 5900 -forever -usepw -create -display :1


# ORB—SLAM2
# DISPLAY=:1 ./ORB_SLAM2/Examples/Monocular/mono_tum ./ORB_SLAM2/Vocabulary/ORBvoc.txt ./ORB_SLAM2/Examples/Monocular/TUM1.yaml ./data/rgbd_dataset_freiburg1_xyz/ &
