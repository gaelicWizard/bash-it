# shellcheck shell=bash
cite about-plugin
about-plugin 'load hub, if you are using it'
url "https://github.com/github/hub"

if ! _binary_exists hub; then
	_bash-it-plugin-self-disable hub "Unable to locate 'hub'."
	return 0
fi

eval "$(hub alias -s)"
