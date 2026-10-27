# shellcheck shell=bash
cite about-plugin
about-plugin 'load nodenv, if you are using it'
url "https://github.com/nodenv/nodenv"

if [[ -d "${NODENV_ROOT:=$HOME/.nodenv}/bin" ]]; then
	export NODENV_ROOT
	pathmunge "$NODENV_ROOT/bin"
fi

if ! _binary_exists nodenv; then
	_bash-it-plugin-self-disable nodenv "Unable to locate 'nodenv'."
	return 0
fi

eval "$(nodenv init - bash)"
