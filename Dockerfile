# ros-dev/Dockerfile

from ubuntu

# boilerplate prelude
env DEBIAN_FRONTEND noninteractive
run \
  rm /bin/sh && \
  ln -s /bin/bash /bin/sh && \
  apt-get -y --fix-missing update && \
  apt-get -y install ca-certificates apt-utils


# http://wiki.ros.org/kinetic/Installation/Ubuntu

# 1.1  configure Ubuntu repositories
run \
  apt-get -y install software-properties-common && \
  apt-add-repository universe && \
  apt-add-repository multiverse && \
  apt-add-repository restricted

# 1.2  set up sources list
run \
  apt-get -y install lsb-release && \
  echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
  >/etc/apt/sources.list.d/ros-latest.list && \
  cat /etc/apt/sources.list.d/ros-latest.list

# 1.3  set up keys
run \
  apt-key adv --verbose \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-key 0xB01FA116 && \
  apt-key adv --verbose --list-keys

# 1.4  installation
run \
  apt-get -y update && \
  apt-get -y install ros-kinetic-ros-base

# 1.5  initialize rosdep
run rosdep init && rosdep update

# 1.6  environment setup
run cd && echo "source /opt/ros/kinetic/setup.bash" >> .bashrc

# 1.7  getting rosinstall
run apt-get -y install python-rosinstall

# http://wiki.ros.org/ROS/Tutorials/InstallingandConfiguringROSEnvironment

# create a ros workspace
run \
  source /opt/ros/kinetic/setup.bash && \
  mkdir -vp catkin_ws/src && \
  cd catkin_ws/src && \
  catkin_init_workspace && \
  cd .. && \
  catkin_make

# stamp the build
run date -uIs | tee timestamp.txt

cmd /bin/bash
