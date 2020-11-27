FROM centos:8
LABEL maintainer="help@megabyte.space"
ENV container=docker

# Source: https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
  yum -y install \
      centos-release \
      dnf-plugins-core \
      rpm \
  && yum -y update \
  && yum -y config-manager --set-enabled PowerTools \
  && yum -y install \
      epel \
      epel-release \
      hostname \
      initscripts \
      libyaml-devel \
      python3 \
      python3-pip \
      python3-pyyaml \
      sudo \
      which \
  && yum clean all \
  && pip3 install \
      ansible \
      ansible-lint \
      molecule \
      yamllint \
  && sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers \
  && mkdir -p /etc/ansible \
  && echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts \
  && set -xe \
  && groupadd -r ansible \
  && useradd -m -g ansible ansible \
  && usermod -aG wheel ansible \
  && sed -i "/^%wheel/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
