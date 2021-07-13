FROM centos:latest

RUN yum install -y python38 openssh-clients svn git https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/s/sshpass-1.06-9.el8.x86_64.rpm
RUN python3 -m pip install ansible
RUN /usr/bin/svn checkout https://github.com/ottvladimir/home_work/trunk/08-ansible-01-base/playbook
WORKDIR /playbook
ENTRYPOINT ansible-playbook site.yaml -i inventory/prod.yml --vault-password-file pass | tee /data/wedoit.txt
