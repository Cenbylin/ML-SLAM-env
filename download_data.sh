file_tum="data/rgbd_dataset_freiburg1_xyz/"
echo "downloading data/rgbd_dataset..."
if [ ! -d "$file_tum" ]; then
  wget https://vision.in.tum.de/rgbd/dataset/freiburg1/rgbd_dataset_freiburg1_xyz.tgz
  tar -zxf rgbd_dataset_freiburg1_xyz.tgz
  rm rgbd_dataset_freiburg1_xyz.tgz
  # move
  mv rgbd_dataset_freiburg1_xyz/ data/rgbd_dataset_freiburg1_xyz/
else
  echo "file existed."
fi