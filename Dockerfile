FROM thomasjpfan/ubuntu-python-systemd:16.04

ENV ANSIBLE_VERSION 2.4.2.0
ENV TESTINFRA_VERSION 1.10.1

RUN add-apt-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    python-setuptools python-pip && \
    pip install -U pip wheel && \
    pip install -U ansible==${ANSIBLE_VERSION} \
    testinfra==${TESTINFRA_VERSION} ansible-lint && \
    apt-get remove -y --auto-remove python-setuptools python-pip && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc && rm -Rf /usr/share/man && \
    apt-get clean && \
    mkdir -p /etc/ansible && \
    echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
