# alpine-ros/Dockerfile

from frolvlad/alpine-python3

run \
  set -euo pipefail && \
  apk update && \
  apk upgrade && \
  apk add ca-certificates && \
  pip list | awk '{print $1}' | xargs pip install --upgrade && \
  pip install --upgrade \
    setuptools \
    nose \
    && \
  pip install --upgrade \
    rosdep \
    rosinstall_generator \
    wstool \
    rosinstall \
    && \
  rosdep init && \
  source /etc/os-release && \
  export ROS_OS_OVERRIDE="$ID:$VERSION_ID" && \
  echo $ROS_OS_OVERRIDE && \
  rosdep update && \
  date -uIs | tee timestamp.txt

cmd /bin/sh
