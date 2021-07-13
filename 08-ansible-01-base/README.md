# Домашнее задание к занятию "08.01 Введение в Ansible"

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

        [root@2ef8e3cf3c3e playbook]# ansible-playbook site.yaml -i inventory/test.yml 
        [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in
        incorrectly calculated text widths that can cause Display to print incorrect line lengths

        PLAY [Print os facts] ****************************************************************************************************************

        TASK [Gathering Facts] ***************************************************************************************************************
        ok: [localhost]

        TASK [Print OS] **********************************************************************************************************************
        ok: [localhost] => {
            "msg": "CentOS"
        }

        TASK [Print fact] ********************************************************************************************************************
        ok: [localhost] => {
            "msg": "deb"
        }

        PLAY RECAP ***************************************************************************************************************************
        localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

        root@2ef8e3cf3c3e playbook]# ansible-playbook site.yaml -i inventory/test.yml 
        [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in incorrectly calculated text widths that can cause Display to print incorrect
        line lengths

        PLAY [Print os facts] **********************************************************************************************************************************************************************************************

        TASK [Gathering Facts] *********************************************************************************************************************************************************************************************
        ok: [localhost]

        TASK [Print OS] ****************************************************************************************************************************************************************************************************
        ok: [localhost] => {
            "msg": "CentOS"
        }

        TASK [Print fact] **************************************************************************************************************************************************************************************************
        ok: [localhost] => {
            "msg": "all default fact"
        }

        PLAY RECAP *********************************************************************************************************************************************************************************************************
        localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

    
3. Здесь подготовил окружение https://github.com/ottvladimir/RunAnsible/tree/main/docker_compose
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

        [root@98f5928052b1 playbook]ansible-playbook site.yaml -i inventory/prod.yml
        [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in incorrectly calculated text widths that
        can cause Display to print incorrect line lengths

        PLAY [Print os facts] *********************************************************************************************************************************************************

        TASK [Gathering Facts] ********************************************************************************************************************************************************
        ok: [ubuntu]
        ok: [centos7]

        TASK [Print OS] ***************************************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "CentOS"
        }
        ok: [ubuntu] => {
            "msg": "Ubuntu"
        }

        TASK [Print fact] *************************************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "el"
        }
        ok: [ubuntu] => {
            "msg": "deb"
        }

        PLAY RECAP ********************************************************************************************************************************************************************
        centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
6. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
7.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

        [root@98f5928052b1 playbook]# ansible-playbook site.yaml -i inventory/prod.yml
        [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in incorrectly calculated text widths that
        can cause Display to print incorrect line lengths

        PLAY [Print os facts] *********************************************************************************************************************************************************

        TASK [Gathering Facts] ********************************************************************************************************************************************************
        ok: [centos7]
        ok: [ubuntu]

        TASK [Print OS] ***************************************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "CentOS"
        }
        ok: [ubuntu] => {
            "msg": "Ubuntu"
        }

        TASK [Print fact] *************************************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "el default fact"
        }
        ok: [ubuntu] => {
            "msg": "deb default fact"
        }

        PLAY RECAP ********************************************************************************************************************************************************************
        centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

        [root@98f5928052b1 playbook]# ansible-playbook site.yaml -i inventory/prod.yml --ask-vault-pass
        Vault password: 
        [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in incorrectly calculated text widths that
        can cause Display to print incorrect line lengths

        PLAY [Print os facts] *********************************************************************************************************************************************************

        TASK [Gathering Facts] ********************************************************************************************************************************************************
        ok: [ubuntu]
        ok: [centos7]
        
 ** для выполнения дополнительного задания переименовал зашифрованые файлы в encrypted**
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
    
        [root@98f5928052b1 playbook]# ansible-doc -t connection -l
        
 наиболее подходящий тип подключения - local
        
11. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
12. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
        
        [root@98f5928052b1 ansible]# ansible-playbook site.yaml -i inventory/prod.yml --ask-vault-pass
        Vault password: 
        [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in incorrectly calculated text widths that
        can cause Display to print incorrect line lengths

        PLAY [Print os facts] *********************************************************************************************************************************************************

        TASK [Gathering Facts] ********************************************************************************************************************************************************
        ok: [localhost]
        ok: [ubuntu]
        ok: [centos7]

        TASK [Print OS] ***************************************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "CentOS"
        }
        ok: [ubuntu] => {
            "msg": "Ubuntu"
        }
        ok: [localhost] => {
            "msg": "CentOS"
        }

        TASK [Print fact] *************************************************************************************************************************************************************
        ok: [centos7] => {
            "msg": "el default fact"
        }
        ok: [ubuntu] => {
            "msg": "deb default fact"
        }
        ok: [localhost] => {
            "msg": "deb"
        }

        PLAY RECAP ********************************************************************************************************************************************************************
        centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
        ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

13. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифlруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
                
                [root@98f5928052b1 ansible]# ansible-playbook site.yaml -i inventory/prod.yml --ask-vault-pass
                Vault password: 
                [WARNING]: An error occurred while calling ansible.utils.display.initialize_locale (unsupported locale setting). This may result in incorrectly calculated text widths that
                can cause Display to print incorrect line lengths

                PLAY [Print os facts] *********************************************************************************************************************************************************

                TASK [Gathering Facts] ********************************************************************************************************************************************************
                ok: [localhost]
                ok: [ubuntu]
                ok: [centos7]

                TASK [Print OS] ***************************************************************************************************************************************************************
                ok: [centos7] => {
                    "msg": "CentOS"
                }
                ok: [ubuntu] => {
                    "msg": "Ubuntu"
                }
                ok: [localhost] => {
                    "msg": "CentOS"
                }

                TASK [Print fact] *************************************************************************************************************************************************************
                ok: [centos7] => {
                    "msg": "el default fact"
                }
                ok: [ubuntu] => {
                    "msg": "deb default fact"
                }
                ok: [localhost] => {
                    "msg": "PaSSw0rd"
                }

                PLAY RECAP ********************************************************************************************************************************************************************
                centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
                localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
                ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).dock    
Я использовал образ Rocky Linux.
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
wget https://raw.githubusercontent.com/ottvladimir/home_work/master/08-ansible-01-base/auto.sh -O auto.sh && chmod +x auto.sh && ./auto.sh
в результате по пути ~/ansible_data/ создается файл wedoit.txt с результатом работы playbook'а
7. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.
