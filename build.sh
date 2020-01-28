#!/bin/bash
echo "begin building docker env"

echo "[1/nstep] downloading CoppeliaSim..."

file_CoppeliaSim="CoppeliaSim/"
if [ ! -d "$file_CoppeliaSim" ]; then
  wget http://www.coppeliarobotics.com/files/CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar.xz
  xz -d CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar.xz
  tar -xf CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar
  rm CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar
  # rename
  mv CoppeliaSim_Edu_V4_0_0_Ubuntu18_04 CoppeliaSim
else
  echo "use file exited."
fi

file_rgbd="data/rgbd_dataset_freiburg1_xyz.tar"
echo "[2/nstep] downloading data/rgbd_dataset...pass"
# if [ ! -f "$file_rgbd" ]; then
#   wget xxxxx
#   xz -d xxxxx
#   tar -xvf CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar
#   rm CoppeliaSim_Edu_V4_0_0_Ubuntu18_04.tar
#   # rename
#   mv CoppeliaSim_Edu_V4_0_0_Ubuntu18_04/ CoppeliaSim/
# else
#   echo "use file exited."
# fi

echo "[3/nstep] building Docker with Dockerfile..."

docker build -t ml-slam-env .

echo "done"
