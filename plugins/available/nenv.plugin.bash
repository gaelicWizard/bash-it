# shellcheck shell=bash
about-plugin 'Node.js environment management using https://github.com/ryuone/nenv'

# Load after basher
# BASH_IT_LOAD_PRIORITY: 260

: "${NENV_ROOT:=${HOME?}/.nenv}"
export NENV_ROOT

pathmunge "${NENV_ROOT?}/bin"

if _command_exists nenv; then
	eval "$(nenv init - bash)"
fi
