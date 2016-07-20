# debian-ros/Dockerfile

from debian

env DEBIAN_FRONTEND noninteractive

# http://wiki.ros.org/kinetic/Installation/Source
run \
  apt-get -y --fix-missing update && \
  apt-get -y install ca-certificates apt-utils && \
  apt-get -y upgrade && \
  apt-get -y install build-essential curl python3

run \
  ln -vsf $(command -v python3) $(dirname $(command -v python3))/python && \
  curl -sL https://bootstrap.pypa.io/get-pip.py | python && \
  pip list | awk '{print $1}' | xargs pip install --upgrade && \
  pip install --upgrade \
    nose \
    setuptools \
    && \
  pip install --upgrade \
    rosdep \
    rosinstall_generator \
    wstool \
    rosinstall \
    && \
  rosdep init && \
  rosdep update && \
  date -uIs | tee timestamp.txt

workdir /ros_catkin_ws

run \
  rosinstall_generator ros_comm \
    --rosdistro kinetic \
    --deps \
    --wet-only \
    --tar > kinetic-ros_comm-wet.rosinstall && \
  wstool init src kinetic-ros_comm-wet.rosinstall

run locale

# rosdep install \
#   --from-paths src \
#   --ignore-src \
#   --rosdistro kinetic -y

cmd /bin/bash
