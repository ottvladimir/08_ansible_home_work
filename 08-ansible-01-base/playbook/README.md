# Самоконтроль выполненения задания

1. Файл с `some_fact`  расположен по пути group_vars/all/examp.yml
2. Для запуска `playbook` на окружении `test.yml` `ansible-playbook playbook -i test.yml`
3. Зашифровать файл можно ansible-vault encrypt
4. Расшифровать файл можно ansible-vault decrypt
5. Посмотреть содержимое зашифрованного файла без команды расшифровки файла можно командой ansible-vault view
6. Kоманда запуска `playbook`, если переменные зашифрованы - `ansible-playbook someplaybook --ask-vault-pass`
7. Mодуль подключения к host на windows - называется `winrm`
8. Полный текст команды для поиска информации в документации ansible для модуля подключений ssh `ansible-doc -t connection ssh`
9. Параметр `- remote_user` из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
