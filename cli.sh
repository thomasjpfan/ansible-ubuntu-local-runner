#!/bin/sh
set -e

# commands: all lint syntax-check run_test converge requirements idempotence all

# Colors!
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

root_test_dir="/etc/ansible/roles/role_to_test/tests"
playbook="${root_test_dir}/playbook.yml"
requirements="${root_test_dir}/requirements.yml"
run_tests="${root_test_dir}/run_tests.sh"

lint() {
	printf "${green}Using ansible-lint to check syntax${neutral}\\n"
	ansible-lint "$playbook"
}

syntax_check() {
	printf "${green}Checking ansible playbook syntax-check${neutral}\\n"
	ansible-playbook "$playbook" --syntax-check
}

converge() {
	printf "${green}Running full playbook${neutral}\\n"
	ansible-playbook "$playbook"
}

run_test() {
	printf "${green}Running tests${neutral}\\n"
	pytest "${root_test_dir}"
}

idempotence() {
	printf "${green}Running playbook again (idempotence test)${neutral}\\n"
	idempotence="$(mktemp)"
	ansible-playbook "$playbook" | tee -a "$idempotence"
	tail "$idempotence" \
		| grep -q 'changed=0.*failed=0' \
		&& (printf "${green}Idempotence test: pass${neutral}\\n") \
		|| (printf "${red}Idempotence test: fail${neutral}\\n" && exit 1)
}

requirements() {
	if [ -f "$requirements" ]; then
		printf "${green}Requirements file detected; installing dependencies.${neutral}\\n"
		ansible-galaxy install -r "$requirements"
	fi

}

case "$1" in
	all)
		lint
		syntax_check
		requirements
		converge
		idempotence
		run_test
		;;
	lint)
		lint
		;;
	syntax-check)
		syntax_check
		;;
	requirements)
		requirements
		;;
	converge)
		converge
		;;
	idempotence)
		converge
		idempotence
		;;
	run_test)
		run_test
		;;
	*)
		exec "$@"
		;;
esac
