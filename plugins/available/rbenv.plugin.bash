# shellcheck shell=bash
cite about-plugin
about-plugin 'load rbenv, if you are using it'
url "https://github.com/rbenv/rbenv"

: "${RBENV_ROOT:=$HOME/.rbenv}"
export RBENV_ROOT
pathmunge "$RBENV_ROOT/bin"

if ! _binary_exists rbenv; then
	_bash-it-plugin-self-disable rbenv "Unable to locate 'rbenv'."
	return 0
fi

eval "$(rbenv init - bash)"
