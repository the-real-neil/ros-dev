# debian-ros/Dockerfile

from ubuntu

env DEBIAN_FRONTEND noninteractive

# http://wiki.ros.org/kinetic/Installation/Ubuntu

run apt-get -y --fix-missing update

run apt-get -y install ca-certificates apt-utils

run apt-get -y install software-properties-common

# configure Ubuntu repositories
run apt-add-repository universe
run apt-add-repository multiverse
run apt-add-repository restricted

run \
  apt-get -y --fix-missing update && \
  apt-get -y install ca-certificates apt-utils && \
  apt-get -y upgrade && \
  apt-get -y install build-essential curl python locales-all

env LC_ALL en_US.utf8

# set up sources list
run \
  apt-get -y install lsb-release && \
  echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" \
  >/etc/apt/sources.list.d/ros-latest.list && \
  cat /etc/apt/sources.list.d/ros-latest.list

# set up keys
run \
  apt-key adv --verbose \
  --keyserver hkp://ha.pool.sks-keyservers.net:80 \
  --recv-key 0xB01FA116 && \
  apt-key adv --verbose --list-keys

run apt-get -y update

run apt-get -y install ros-kinetic-ros-base

run \
  rosdep init && \
  rosdep update && \
  date -uIs | tee timestamp.txt

run apt-get -y install python-rosinstall

cmd /bin/bash
