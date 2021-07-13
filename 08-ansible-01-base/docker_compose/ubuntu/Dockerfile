FROM ubuntu:latest

RUN apt update && apt install -y openssh-server
RUN useradd -m -s /usr/bin/bash -G sudo ansible
RUN sed -ri 's/#Port 22/Port 222/g' /etc/ssh/sshd_config
RUN mkdir /run/sshd
RUN echo 'ansible:password' | chpasswd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
RUN echo 'AllowUsers ansible' >>  /etc/ssh/sshd_config
RUN ssh-keygen -A
EXPOSE 222
ENTRYPOINT ["/usr/sbin/sshd"]
CMD ["-D"]
