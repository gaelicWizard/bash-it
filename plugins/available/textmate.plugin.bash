# shellcheck shell=bash
cite about-plugin
about-plugin 'set textmate as a default editor'
url "https://macromates.com/"

if ! _binary_exists mate; then
	_bash-it-plugin-self-disable textmate "Unable to locate 'mate'."
	return 0
fi

EDITOR="$(type -p mate) -w"
GIT_EDITOR="$EDITOR"
export EDITOR GIT_EDITOR
