FROM ubuntu:20.04
LABEL maintainer="help@megabyte.space"

COPY initctl .

# Source: https://github.com/ansible/molecule/issues/1104
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      apt-utils \
      iproute2 \
      locales \
      libyaml-dev \
      python3-setuptools \
      python3-pip \
      python3-yaml \
      rsyslog \
      software-properties-common \
      sudo \
      systemd \
      systemd-cron \
  && rm -Rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
  && apt-get clean \
  && sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf \
  && locale-gen en_US.UTF-8 \
  && pip3 install \
      ansible \
      ansible-lint \
      molecule \
      yamllint \
  && chmod +x initctl \
  && rm -rf /sbin/initctl \
  && ln -s /initctl /sbin/initctl \
  && mkdir -p /etc/ansible \
  && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts \
  && rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target \
  && set -xe \
  && groupadd -r ansible \
  && useradd -m -g ansible ansible \
  && usermod -aG sudo ansible \
  && sed -i "/^%sudo/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
