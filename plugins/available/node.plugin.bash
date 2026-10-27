# shellcheck shell=bash
cite about-plugin
about-plugin 'Node.js helper functions'
url "https://nodejs.org/"

# Check that we have npm
if ! _binary_exists npm; then
	_bash-it-plugin-self-disable node "Unable to locate 'npm'."
	return 0
fi

# Ensure local modules are preferred in PATH
pathmunge "./node_modules/.bin" "after"

# If not using nodenv, ensure global modules are in PATH
if [[ "$(type -p npm)" != *"nodenv/shims"* ]]; then
	pathmunge "$(npm config get prefix)/bin" "after"
fi
