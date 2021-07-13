# Домашнее задание к занятию "08.02 Работа с Playbook"

## Основная часть
1. Мой inventory файл [`prod.yml`](./playbook/inventory/prod.yml).
```yaml
- name: Install Kibana
   tasks:
   hosts: kibana  
     - name: Upload tar.gz Kibana from remote URL
       get_url:
         url: "https://artifacts.elastic.co/downloads/kibana/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # Скачиваем kibana
         dest: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz" # в эту директорию {{ kibana_version }} - переменная задана в group_vars/kibana/vars.yml
         mode: 0755
         timeout: 60
         force: true
         validate_certs: false 
       register: get_kibana
       until: get_kibana is succeeded
       tags: kibana                                                          # Таги позволяют запускать данные задачи отдельно от всего playbook
     - name: Create directrory for Kibana
       file:
         state: directory
         path: "{{ kibana_home }}"
       tags: kibana
     - name: Extract Kibana in the installation directory
       become: true
       unarchive:
         copy: false
         src: "/tmp/kibana-{{ kibana_version }}-linux-x86_64.tar.gz"
         dest: "{{ kibana_home }}"
         extra_opts: [--strip-components=1]
         creates: "{{ kibana_home }}/bin/kibana"
       tags:
         - skip_ansible_lint
         - kibana
     - name: Set environment Kibana
       become: yes
       template:
         src: templates/kib.sh.j2
         dest: /etc/profile.d/kib.sh
       tags: kibana


```
