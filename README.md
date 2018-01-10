# Ubuntu Ansible Systemd

These images builds ontop of [thomasjpfan/ubuntu-python-systemd](https://github.com/thomasjpfan/ubuntu-python-systemd) to test Ansible Roles that needs systemd.

## Usage

This [repo](https://github.com/thomasjpfan/ansible-ubuntu-local-runner) provides a sample role to be tested. Test can be ran with:

```bash
docker run --rm -v $PWD:/etc/ansible/roles/role_to_test \
  -v $PWD/dep_roles:/root/.ansible/roles \
  thomasjpfan/ansible-ubuntu-local-runner all
```

## Commands

1. `lint`: Runs ansible-lint on `tests/playbook.yml`.
1. `syntax-check`: Runs ansible-playbook --syntax-check on `tests/playbook.yml`.
1. `converge`: Runs ansible-playbook on `tests/playbook.yml`.
1. `idempotence`: Runs converge again and see if anthing changed.
1. `test`: Runs test `tests/run_tests.sh`.
1. `requirements`: Runs ansible-galaxy install on `tests/requirements.yml`.
1. `all`: Runs `lint`, `syntax_check`, `requirements`, `converge`, `idempotence`.

## Local Development

For local development, one can start a shell:

```bash
docker run --rm -v $PWD:/etc/ansible/roles/role_to_test \
  -v $PWD/dep_roles:/root/.ansible/roles -ti \
  thomasjpfan/ansible-ubuntu-local-runner /bin/sh
```

And run the commands prefixed with `entrypoint.sh`, for example: `entrypoint.sh lint`.