FROM ubuntu:20.04
LABEL maintainer="ProfessorManhattan"

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    locales \
    libyaml-dev \
    python3-setuptools \
    python3-pip \
    python3-yaml \
    software-properties-common \
    rsyslog systemd systemd-cron sudo iproute2 \
  && rm -Rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
  && apt-get clean
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Fix potential UTF-8 errors with ansible-test
RUN locale-gen en_US.UTF-8

# Install Ansible via pip
RUN pip3 install ansible ansible-lint molecule yamllint

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

# Create "ansible" user with sudo permissions
ENV ANSIBLE_USER=ansible SUDO_GROUP=wheel
RUN set -xe \
  && groupadd -r ${ANSIBLE_USER} \
  && useradd -m -g ${ANSIBLE_USER} ${ANSIBLE_USER} \
  && usermod -aG ${SUDO_GROUP} ${ANSIBLE_USER} \
  && sed -i "/^%${SUDO_GROUP}/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
