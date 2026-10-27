# shellcheck shell=bats
# shellcheck disable=SC2034 # Variables consumed by externally-loaded powerline functions.

load "${MAIN_BASH_IT_DIR?}/test/test_helper.bash"

function local_setup_file() {
	setup_libs "preexec"
}

function local_setup() {
	unset POWERLINE_PROMPT_CHAR PROMPT_CHAR POWERLINE_LEFT_SEPARATOR POWERLINE_LEFT_SEPARATOR_SOFT
	unset USER_INFO_THEME_PROMPT_COLOR_SUDO POWERLINE_USER_INFO_COLOR_SUDO
}

# Stub a segment so __powerline_prompt_command doesn't need real plugins.
function __powerline_noop_prompt() { printf 'seg|32'; }
function _save-and-reload-history() { :; }

@test "powerline-plain theme: sources cleanly under set -u" {
	# lib/preexec.bash expands precmd_functions[@] unguarded, which fails under set -u before bash 4.4.
	if ((BASH_VERSINFO[0] * 100 + BASH_VERSINFO[1] < 404)); then
		skip "bash ${BASH_VERSION} does not support set -u with empty arrays"
	fi
	run bash -uc '
		for lib in log utilities helpers search colors preview preexec; do
			source "${BASH_IT?}/lib/${lib}.bash"
		done
		source "${BASH_IT?}/themes/powerline-plain/powerline-plain.theme.bash"
	'
	assert_success
}

@test "powerline-plain theme: defaults to no prompt or separator characters" {
	load "${BASH_IT?}/themes/powerline-plain/powerline-plain.theme.bash"
	assert_equal "${POWERLINE_PROMPT_CHAR-unset}" ""
	assert_equal "${POWERLINE_LEFT_SEPARATOR-unset}" ""
	assert_equal "${POWERLINE_LEFT_SEPARATOR_SOFT-unset}" ""
}

@test "powerline-plain theme: user-provided prompt character wins" {
	POWERLINE_PROMPT_CHAR='>'
	load "${BASH_IT?}/themes/powerline-plain/powerline-plain.theme.bash"
	assert_equal "${POWERLINE_PROMPT_CHAR}" '>'
}

@test "powerline-plain theme: PS1 contains the segment and no prompt character" {
	load "${BASH_IT?}/themes/powerline-plain/powerline-plain.theme.bash"
	POWERLINE_PROMPT=("noop")
	__powerline_prompt_command > /dev/null
	[[ "${PS1}" == *"seg"* ]]
	[[ "${PS1}" != *'$'* ]]
}

@test "powerline-plain theme: user_info uses the sudo color fallback when the color is empty" {
	load "${BASH_IT?}/themes/powerline/powerline.base.bash"
	THEME_CHECK_SUDO=true
	USER_INFO_THEME_PROMPT_COLOR_SUDO=""
	sudo() { return 0; }
	run __powerline_user_info_prompt
	assert_output --partial "|202"
}
