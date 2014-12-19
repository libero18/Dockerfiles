#!/bin/sh

os_version=5.11
mirrorurl="http://ftp.jaist.ac.jp/pub/Linux/CentOS/${os_version}/os/x86_64/CentOS/"

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install rinse

sudo wget https://get.docker.io/builds/Linux/x86_64/docker-latest -O /usr/bin/docker
sudo chmod +x /usr/bin/docker

sudo wget https://raw.githubusercontent.com/dotcloud/docker/master/contrib/init/sysvinit-debian/docker -O /etc/init.d/docker
sudo chmod +x /etc/init.d/docker

sudo addgroup docker
sudo gpasswd -a vagrant docker
sudo update-rc.d -f docker defaults
sudo cat << EOF > /etc/default/docker
DOCKER_OPTS="-H 127.0.0.1:4243 -H unix:///var/run/docker.sock"
EOF
sudo nohup docker -d < /dev/null > /dev/null 2> /dev/null &

wget https://raw.githubusercontent.com/dotcloud/docker/master/contrib/mkimage-rinse.sh
chmod +x ./mkimage-rinse.sh
sed -i "s/^docker\s*run\s*-i\s*-t\s*\$repo:\$version\s*echo\s*success/#$&/g" ./mkimage-rinse.sh
./mkimage-rinse.sh libero18/centos-5 centos-5 ${mirrorurl}

