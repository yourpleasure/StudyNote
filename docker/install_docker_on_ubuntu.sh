#!/bin/bash
apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
version=`cat /etc/issue | cut -d ' ' -f 2 | head -1 | cut -d '.' -f 1,2`
if [ "14.04" == $version ]
then
    echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
elif [ "15.04" == $version ]
then
    echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" > /etc/apt/sources.list.d/docker.list
elif [ "16.04" == $version ]
then
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
else
    echo "unsupport version"
    exit 1
fi

apt-get update 
apt-key update
apt-get purge lxc-docker -y
apt-get install docker-engine -y
exit 0
