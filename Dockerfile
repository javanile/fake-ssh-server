FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y openssh-server net-tools iputils-ping sshpass \
 && mkdir /var/run/sshd \
 && mkdir /root/.ssh \
 && sed -ri 's/^#?Port 22/Port 22/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?PermitEmptyPasswords\s+.*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
 && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -ms /bin/bash ubuntu
RUN passwd -d ubuntu

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
