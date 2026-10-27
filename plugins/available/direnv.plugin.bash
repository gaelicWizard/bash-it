# shellcheck shell=bash
cite about-plugin
about-plugin 'load direnv, if you are using it: https://direnv.net/'
url "https://direnv.net/"

if ! _binary_exists direnv; then
	_bash-it-plugin-self-disable direnv "Could not find 'direnv'."
	return 0
fi

eval "$(direnv hook bash)"
