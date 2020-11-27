FROM debian:buster
LABEL maintainer="help@megabyte.space"

COPY initctl .

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y --no-install-recommends \
      build-essential \
      libffi-dev \
      libssl-dev \
      python3-dev \
      python3-pip \
      python3-setuptools \
      python3-wheel \
      sudo \
      systemd \
      systemd-sysv \
      wget \
  && rm -rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
  && apt-get clean \
  && pip3 install \
      ansible \
      ansible-lint \
      cryptography \
      molecule \
      yamllint \
  && chmod +x initctl \
  && rm -rf /sbin/initctl \
  && ln -s /initctl /sbin/initctl \
  && mkdir -p /etc/ansible \
  && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts \
  && rm -f /lib/systemd/system/multi-user.target.wants/getty.target \
  && set -xe \
  && groupadd -r ansible \
  && useradd -m -g ansible ansible \
  && usermod -aG sudo ansible \
  && sed -i "/^%sudo/s/ALL\$/NOPASSWD:ALL/g" /etc/sudoers

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
