#!/bin/sh
set -e

# commands: all lint syntax-check run_test converge requirements idempotence

# Colors!
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

PLAYBOOK_PATH=${PLAYBOOK_PATH:-"tests/playbook.yml"}
REQUIREMENTS_PATH=${REQUIREMENTS_PATH:-"requirements.yml"}

root_role_dir="/etc/ansible/roles/role_to_test"
playbook="${root_role_dir}/${PLAYBOOK_PATH}"
requirements="${root_role_dir}/${REQUIREMENTS_PATH}"

lint() {
	printf "${green}Using ansible-lint to check syntax${neutral}\\n"
	echo ansible-lint "$playbook"
	ansible-lint "$playbook"
}

run_syntax_check() {
	printf "${green}Checking ansible playbook syntax-check${neutral}\\n"
	if [ ! -z "$@" ]; then
		cmd="ansible-playbook $* ${playbook} --syntax-check"
	else
		cmd="ansible-playbook ${playbook} --syntax-check"
	fi
	echo "$cmd"
	$cmd
}

converge() {
	printf "${green}Running full playbook${neutral}\\n"
	if [ ! -z "$@" ]; then
		cmd="ansible-playbook $* ${playbook}"
	else
		cmd="ansible-playbook ${playbook}"
	fi
	echo "$cmd"
	$cmd
}

run_test() {
	printf "${green}Running tests${neutral}\\n"
	pytest tests
}

idempotence() {
	printf "${green}Running playbook again (idempotence test)${neutral}\\n"
	idempotence="$(mktemp)"

	if [ ! -z "$@" ]; then
		cmd="ansible-playbook $* ${playbook}"
	else
		cmd="ansible-playbook ${playbook}"
	fi
	$cmd | tee -a "$idempotence"
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

usage() {
	echo "usage: $0 (lint|syntax-check|requirments|converge|idempotence|run_test|all)"
	echo "  lint: Runs ansible-lint on tests/playbook.yml"
	echo "  syntax_check: Runs ansible-playbook --syntax-check on tests/playbook.yml"
	echo "  requirements: Imports requirements from ansible galaxy"
	echo "  converge: Runs tests/playbook.yml"
	echo "  idempotence: Runs ansible-playbook again and fails if anything changes"
	echo "  run_test: Runs pytest on tests folder"
	echo "  all: Runs all of the above"
	exit 1
}

cmd="$1"
args=${ANSIBLE_PLAYBOOK_ARGS:=}
if [ "$#" -gt 1 ]; then
	shift 1
	args="$*"
fi

case "$cmd" in
	all)
		lint
		run_syntax_check "$args"
		requirements
		converge "$args"
		idempotence "$args"
		run_test
		;;
	lint)
		lint
		;;
	syntax_check)
		run_syntax_check "$args"
		;;
	requirements)
		requirements
		;;
	converge)
		converge "$args"
		;;
	idempotence)
		converge "$args"
		idempotence "$args"
		;;
	run_test)
		run_test
		;;
	*)
		usage
		;;
esac
