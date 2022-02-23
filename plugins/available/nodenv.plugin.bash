# shellcheck shell=bash
about-plugin 'Node.js environment management using https://github.com/nodenv/nodenv'

# Load after basher
# BASH_IT_LOAD_PRIORITY: 260

: "${NODENV_ROOT:=${HOME?}/.nodenv}"
export NODENV_ROOT

pathmunge "${NODENV_ROOT?}/bin"

if _command_exists nodenv; then
	eval "$(nodenv init - bash)"
fi
