# Ubuntu Ansible Systemd

[![CircleCI](https://circleci.com/gh/thomasjpfan/ansible-ubuntu-local-runner/tree/master.svg?style=svg)](https://circleci.com/gh/thomasjpfan/ansible-ubuntu-local-runner/tree/master)

These images builds ontop of [thomasjpfan/ubuntu-python-systemd](https://github.com/thomasjpfan/ubuntu-python-systemd) to test Ansible Roles that needs systemd.

## Usage

This [repo](https://github.com/thomasjpfan/ansible-ubuntu-local-runner) provides a sample role to be tested. Start an instance with systemd running:

```bash
docker run --rm --privileged -d --name systemd \
  -v $PWD:/etc/ansible/roles/role_to_test \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro  \
  -v $PWD/dep_roles:/root/.ansible/roles -t \
  thomasjpfan/ansible-ubuntu-local-runner
```

Then run your tests!

```bash
docker exec -ti systemd cli all
```

## Commands

All the commands are prefixed with `cli`.

1. `lint`: Runs ansible-lint on `tests/playbook.yml`.
1. `syntax-check`: Runs ansible-playbook --syntax-check on `tests/playbook.yml`.
1. `converge`: Runs ansible-playbook on `tests/playbook.yml`.
1. `idempotence`: Runs converge again and see if anthing changed.
1. `run_test`: Runs test `tests/run_tests.sh`.
1. `requirements`: Runs ansible-galaxy install on `tests/requirements.yml`.
1. `all`: Runs `lint`, `syntax_check`, `requirements`, `converge`, `idempotence`.
