## How to build a pure environment for SLAM and ML/DL/RL.

#### 1. install and launch [Docker](www.docker.com), obviously.

#### 2. clone this repo and execute the script `build.sh`.

```shell
git clone https://github.com/Cenbylin/ML-SLAM-env.git
cd ML-SLAM-env/
chmod +x build.sh
./build.sh
```

#### 3. launch the environment in a Docker container.

```shell
docker run -it --rm -p 5901:5900 -p 18888:8888 ml-slam-env
```