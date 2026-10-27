# shellcheck shell=bash
cite about-plugin
about-plugin 'initializes basher, the shell package manager'
url "https://github.com/basherpm/basher"

# https://github.com/basherpm/basher

if ! _command_exists basher; then
	if [[ -x "$HOME/.basher/bin/basher" ]]; then
		pathmunge "$HOME/.basher/bin"
	else
		_bash-it-plugin-self-disable basher "Unable to locate 'basher'."
		return 0
	fi
fi

eval "$(basher init - bash)"
