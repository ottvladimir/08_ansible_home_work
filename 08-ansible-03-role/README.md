# Домашнее задание к занятию "08.03 Работа с Roles"

docker-compose up -d && \
echo "$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{end}}' elasticsearch)   elastic">>/etc/hosts && \
echo "$(docker inspect -f '{{ range.NetworkSettings.Networks }}{{ .IPAddress }}{{end}}' kibana)   kibana">>/etc/hosts &&\
ssh-copy-id root@elastic \
ssh-copy-id root@kibana

Подготовка 
## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для elastic, kibana и написать playbook для использования этих ролей. Ожидаемый результат: существуют два ваших репозитория с roles и один репозиторий с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:
   ```yaml
   ---
     - src: git@github.com:netology-code/mnt-homeworks-ansible.git
       scm: git
       version: "1.0.1"
       name: java 
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
7. Создайте новый каталог с ролью при помощи `molecule init role --driver-name docker kibana-role`. Можете использовать другой драйвер, который более удобен вам.
8. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. Проведите тестирование на разных дистрибитивах (centos:7, centos:8, ubuntu).
9. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию.
10. Добавьте roles в `requirements.yml` в playbook.
11. Переработайте playbook на использование roles.
12. Выложите playbook в репозиторий.
13. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли logstash.
2. Создайте дополнительный набор tasks, который позволяет обновлять стек ELK.
3. В ролях добавьте тестирование в раздел `verify.yml`. Данный раздел должен проверять, что elastic запущен и возвращает успешный статус по API, web-интерфейс kibana отвечает без кодов ошибки, logstash через команду `logstash -e 'input { stdin { } } output { stdout {} }'`.
4. Убедитесь в работоспособности своего стека. Возможно, потребуется тестировать все роли одновременно.
5. Выложите свои roles в репозитории. В ответ приведите ссылки.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
