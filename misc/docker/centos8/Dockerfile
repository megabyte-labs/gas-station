FROM centos:8
LABEL maintainer="ProfessorManhattan"
ENV container=docker

# Install systemd -- See https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
  systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements
RUN yum -y install rpm centos-release dnf-plugins-core \
  && yum -y update \
  && yum -y config-manager --set-enabled PowerTools \
  && yum -y install \
    epel-release \
    initscripts \
    sudo \
    which \
    hostname \
    libyaml-devel \
    python3 \
    python3-pip \
    python3-pyyaml \
  && yum clean all

# Install Ansible via pip
RUN pip3 install ansible ansible-lint molecule yamllint

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Create "ansible" user with sudo permissions
ENV ANSIBLE_USER=ansible SUDO_GROUP=wheel
RUN set -xe \
  && groupadd -r ${ANSIBLE_USER} \
  && useradd -m -g ${ANSIBLE_USER} ${ANSIBLE_USER} \
  && usermod -aG ${SUDO_GROUP} ${ANSIBLE_USER} \
  && sed -i "/^%${SUDO_GROUP}/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
