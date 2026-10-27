# shellcheck shell=bash
cite about-plugin
about-plugin 'load fasd, if you are using it'
url "https://github.com/clvv/fasd"

if ! _command_exists fasd; then
	_bash-it-plugin-self-disable fasd "Unable to locate 'fasd'."
	return 0
fi

eval "$(fasd --init auto)"
