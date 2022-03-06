
apt-get purge -y docker-engine docker docker.io docker-ce 
apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  

#The above commands will not remove images, containers, volumes, or user created configuration files on your host. If you wish to delete all images, containers, and volumes run the following commands:
rm -rf /var/lib/docker /etc/docker
rm /etc/apparmor.d/docker
groupdel docker
rm -rf /var/run/docker.sock
rm -rf /usr/local/bin/docker-compose
