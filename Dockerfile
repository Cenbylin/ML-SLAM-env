FROM continuumio/miniconda3 

# china source
RUN sed -i "s@/deb.debian.org/@/mirrors.163.com/@g" /etc/apt/sources.list && \
    sed -i "s@/security.debian.org/@/mirrors.aliyun.com/@g" /etc/apt/sources.list
RUN apt-get clean && apt-get update
RUN conda update -n base conda && conda update --all
# RUN conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free \
#     && conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main \
#     && conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/ \
#     && conda config --set show_channel_urls yes \
#     && conda update -n base conda && conda update --all

# common
RUN apt-get -y install cmake libpython2.7-dev python3-dev

# common-opencv - 3.4
RUN apt-get install -y libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libgl1-mesa-dev
# RUN conda install -y opencv -c https://mirrors.ustc.edu.cn/anaconda/cloud/menpo
RUN conda install -y opencv=3.4.7 -c https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/

# machine learning and deep learning
RUN conda install -y -c conda-forge plotly netcdf4 scikit-learn scapy colour xarray
RUN conda install -y -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch pytorch torchvision cpuonly 

RUN apt-get install -y vim
RUN ln -s /root/bin/latex /usr/bin/

# jupyter with config (no pwd, port 8888 allow-root)
RUN conda install jupyterlab -c https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge
ADD config/jupyter_notebook_config.py /root/.jupyter/

# https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-docker-container/16311264#16311264
RUN apt-get install -y xcb libglib2.0-0 libgl1-mesa-glx xcb \
    "^libxcb.*" libx11-xcb-dev libglu1-mesa-dev libxrender-dev \
    libxi6 libdbus-1-3 libfontconfig1 libxkbcommon-x11-0 build-essential
RUN apt-get install -y x11vnc xvfb
RUN mkdir ~/.vnc && x11vnc -storepasswd 1234 ~/.vnc/passwd

# requirements of pyrep
RUN apt-get -f install
RUN conda install -y cffi==1.11.5
ADD CoppeliaSim /opt/CoppeliaSim
ADD PyRep /opt/PyRep

# install pyrep. 
# env variables here may affect the compilation of orbslam2.
ENV COPPELIASIM_ROOT=/opt/CoppeliaSim
ENV PATH=$COPPELIASIM_ROOT:$PATH
RUN cd /opt/PyRep \
    && QT_DEBUG_PLUGINS=1 \
    && LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT \
    && QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT \
    && python setup.py install --user

# Dependency of orb - Pangolin
RUN apt-get -y install libglew-dev
ADD Pangolin /opt/Pangolin
RUN cd /opt/Pangolin && mkdir build && cd build \
    && cmake .. && cmake --build .

# Dependency of orb - Eigen3
RUN apt-get install -y libeigen3-dev && \
    cp -r /usr/include/eigen3/Eigen /usr/include

# Dependency of orb - others
RUN apt-get install -y autotools-dev ccache doxygen dh-autoreconf git liblapack-dev libblas-dev libgtest-dev libreadline-dev libssh2-1-dev pylint libsm-dev

# install orbslam2 (without ROS)
ADD ORB_SLAM2 /root/ORB_SLAM2
# let src be compatible with ubuntu 18
RUN rm /opt/conda/lib/libuuid*
RUN cd /root/ORB_SLAM2 && chmod +x build.sh \
    && sed -i 's/namespace ORB_SLAM2/#include<unistd.h> \n namespace ORB_SLAM2/g' include/System.h \
    && sed -i 's/const KeyFrame\*/KeyFrame \*const/g' include/LoopClosing.h \
    && sed -i 's/make -j/make/g' build.sh \
    && ./build.sh

# data
# ADD data/rgbd_dataset_freiburg1_xyz.tar /root/data

# define ENV over the final process
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT
# ENV QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT

# examples
ADD example /root/example

# launch jupyter, CoppeliaSim etc.
ADD config/docker_cmd.sh /root
RUN chmod +x /root/docker_cmd.sh
CMD /root/docker_cmd.sh