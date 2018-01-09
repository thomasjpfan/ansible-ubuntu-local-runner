# Ubuntu Ansible Systemd

These images builds ontop of [thomasjpfan/ubuntu-python-systemd](https://github.com/thomasjpfan/ubuntu-python-systemd) to make it easier to test ansible playbooks that needs systemd.

## Latest Version

`thomasjpfan/ubuntu-ansible-testing:16.04-ansible-2.4.2.0-testinfra-1.10.1`

## Usage

```bash
docker run -d --rm --name ansible --privileged \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro -t \
    thomasjpfan/ubuntu-ansible-testing:16.04-ansible-2.4.2.0-testinfra-1.10.1
```