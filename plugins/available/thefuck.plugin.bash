# shellcheck shell=bash
cite about-plugin
about-plugin 'Initialization for fuck'
url "https://github.com/nvbn/thefuck"

# https://github.com/nvbn/thefuck

if ! _binary_exists thefuck; then
	_bash-it-plugin-self-disable thefuck "Unable to locate 'thefuck'."
	return 0
fi

eval "$(thefuck --alias)"
