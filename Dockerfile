FROM centos:centos6

MAINTAINER kami <kami30k@gmail.com>

RUN yum install -y openssh-server
RUN yum install -y sudo
RUN yum install -y which
RUN yum install -y tar

RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
ADD authorized_keys /root/.ssh/
RUN chmod 600 /root/.ssh/authorized_keys

RUN passwd -d root

RUN sed -ri 's/#PermitEmptyPassword no/PermitEmptyPassword yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop

EXPOSE 22

CMD /etc/init.d/sshd start && /bin/bash
