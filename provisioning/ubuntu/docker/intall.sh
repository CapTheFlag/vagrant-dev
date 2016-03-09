


# Install Docker
apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-cache policy docker-engine
apt-get install linux-image-extra-$(uname -r)
apt-get autoremove
apt-get install apparmor
apt-get install docker-engine
service docker start
#docker run hello-world
docker -v
docker images

# Create a Docker group
usermod -aG docker $USER
unset DOCKER_HOST


# Install Docker compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose







