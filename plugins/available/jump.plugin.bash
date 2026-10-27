# shellcheck shell=bash
# shellcheck disable=SC2016
cite about-plugin
about-plugin 'initialize jump (see https://github.com/gsamokovarov/jump). Add `export JUMP_OPTS=("--bind=z")` to change keybinding'
url "https://github.com/gsamokovarov/jump"

function _bash-it-component-plugin-callback-on-init-jump() {
	if _command_exists jump; then
		eval "$(jump shell bash ${JUMP_OPTS[@]+"${JUMP_OPTS[@]}"})"
	fi
}

_bash-it-component-plugin-callback-on-init-jump
