# !/usr/bin/bash
wget https://raw.githubusercontent.com/ottvladimir/home_work/master/08-ansible-01-base/Dockerfile -O Dockerfile && \
docker build . -t svnrun && \
docker volume create myvol && \
docker volume create ansible_data && \
ln -s /var/lib/docker/volumes/myvol/_data vol && \
ln -s /var/lib/docker/volumes/ansible_data/_data ansivol && \
docker run --rm -v=myvol:/data svnrun && \
cd vol/docker_compose && \
docker-compose up -d && \
sleep 120 && \
docker-compose down && \
cat ansivol/wedoit.txt
