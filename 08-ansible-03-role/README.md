# Домашнее задание к занятию "08.03 Работа с Roles"
## Подготовка 

docker-compose up -d && \
echo "$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{end}}' elasticsearch)   elastic">>/etc/hosts && \
echo "$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{end}}' kibana)   kibana">>/etc/hosts &&\
ssh-copy-id root@elastic \
ssh-copy-id root@kibana


## Основная часть

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:
   ```yaml
   ---
     - src: git@github.com:netology-code/mnt-homeworks-ansible.git
       scm: git
       version: "1.0.1"
       name: java
     - src: git@github.com:ottvladimir/elastic-role-repo.git
       scm: git
       version: "1.0.0"
       name: elastic-role
     - src: git@github.com:ottvladimir/kibana-role-repo.git
       scm: git
       version: "1.0.0"
       name: kibana-role
       
   ```
2. Установка роли при помощи ansible-galaxy 
   ```bash
   ansible-galaxy install -p roles -r playbook/requirements.yml
   ```

6. 
 ```yaml
 $ cat molecule/default/molecule.yml 
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: centos8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: centos7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
  - name: ubuntu
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
  ```
Репозитории 
      
      https://github.com/ottvladimir/kibana-role-repo/tree/1.0.0
      https://github.com/ottvladimir/elastic-role-repo/tree/1.0.0
