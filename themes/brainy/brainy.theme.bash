# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.

# Brainy Bash Prompt for Bash-it
# by MunifTanjim

#############
## Parsers ##
#############

function ____brainy_top_left_parse() {
	local ifs_old="${IFS}"
	local IFS="|"
	read -r -a args <<< "$@"
	IFS="${ifs_old}"
	if [[ -n "${args[3]:-}" ]]; then
		_TOP_LEFT+="${args[2]}${args[3]}"
	fi
	_TOP_LEFT+="${args[0]?}${args[1]?}"
	if [[ -n "${args[4]:-}" ]]; then
		_TOP_LEFT+="${args[2]}${args[4]}"
	fi
	_TOP_LEFT+=" "
}

function ____brainy_top_right_parse() {
	local ifs_old="${IFS}"
	local IFS="|"
	read -r -a args <<< "$@"
	IFS="${ifs_old}"
	_TOP_RIGHT+=" "
	if [ -n "${args[3]:-}" ]; then
		_TOP_RIGHT+="${args[2]}${args[3]}"
	fi
	_TOP_RIGHT+="${args[0]?}${args[1]?}"
	if [ -n "${args[4]:-}" ]; then
		_TOP_RIGHT+="${args[2]}${args[4]}"
	fi
	__TOP_RIGHT_LEN="$((__TOP_RIGHT_LEN + ${#args[1]} + ${#args[3]} + ${#args[4]} + 1))"
	((__SEG_AT_RIGHT += 1))
}

function ____brainy_bottom_parse() {
	local ifs_old="${IFS}"
	local IFS="|"
	read -r -a args <<< "$@"
	IFS="${ifs_old}"
	_BOTTOM+="${args[0]?}${args[1]?}"
	[[ ${#args[1]} -gt 0 ]] && _BOTTOM+=" "
}

function ____brainy_top() {
	local info ___cursor_right ___cursor_adjust seg
	_TOP_LEFT=""
	_TOP_RIGHT=""
	__TOP_RIGHT_LEN=0
	__SEG_AT_RIGHT=0

	for seg in ${___BRAINY_TOP_LEFT}; do
		info="$(___brainy_prompt_"${seg}")"
		[[ -n "${info}" ]] && ____brainy_top_left_parse "${info}"
	done

	___cursor_right="\033[500C"
	_TOP_LEFT+="${___cursor_right}"

	for seg in ${___BRAINY_TOP_RIGHT}; do
		info="$(___brainy_prompt_"${seg}")"
		[[ -n "${info}" ]] && ____brainy_top_right_parse "${info}"
	done

	[[ ${__TOP_RIGHT_LEN} -gt 0 ]] && __TOP_RIGHT_LEN=$((__TOP_RIGHT_LEN - 1))
	___cursor_adjust="\033[${__TOP_RIGHT_LEN}D"
	_TOP_LEFT+="${___cursor_adjust}"

	printf "%s%s" "${_TOP_LEFT}" "${_TOP_RIGHT}"
}

function ____brainy_bottom() {
	local info seg
	_BOTTOM=""
	for seg in $___BRAINY_BOTTOM; do
		info="$(___brainy_prompt_"${seg}")"
		[[ -n "${info}" ]] && ____brainy_bottom_parse "${info}"
	done
	printf "\n%s" "${_BOTTOM}"
}

##############
## Segments ##
##############

function ___brainy_prompt_user_info() {
	local color="${bold_blue?}"
	local box="[|]"
	local info="\u@\H"
	if [[ "${THEME_SHOW_SUDO:-}" == "true" ]]; then
		if sudo -vn 1> /dev/null 2>&1; then
			color="${bold_red?}"
		fi
	fi
	if [[ -n "${SSH_CLIENT:-}" ]]; then
		printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_white?}" "${box}"
	else
		printf "%s|%s" "${color}" "${info}"
	fi
}

function ___brainy_prompt_dir() {
	local color="${bold_yellow?}"
	local box="[|]"
	local info="\w"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_white?}" "${box}"
}

function ___brainy_prompt_scm() {
	[[ "${THEME_SHOW_SCM:-}" != "true" ]] && return
	local color="${bold_green?}" box info
	box="$(scm_char) "
	info="$(scm_prompt_info)"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_white?}" "${box}"
}

function ___brainy_prompt_python() {
	[[ "${THEME_SHOW_PYTHON:-}" != "true" ]] && return
	local color="${bold_yellow?}" info
	local box="[|]"
	info="$(python_version_prompt)"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_blue?}" "${box}"
}

function ___brainy_prompt_ruby() {
	[[ "${THEME_SHOW_RUBY:-}" != "true" ]] && return
	local color="${bold_white?}" info
	local box="[|]"
	info="rb-$(ruby_version_prompt)"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_red?}" "${box}"
}

function ___brainy_prompt_todo() {
	[[ "${THEME_SHOW_TODO:-}" != "true" ||
		-z "$(which todo.sh)" ]] && return
	local color="${bold_white?}" info
	local box="[|]"
	info="t:$(todo.sh ls | grep -E "TODO: [0-9]+ of ([0-9]+)" | awk '{ print $4 }')"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_green?}" "${box}"
}

function ___brainy_prompt_clock() {
	[[ "${THEME_SHOW_CLOCK}" != "true" ]] && return
	local color="${THEME_CLOCK_COLOR:-}" info
	local box="[|]"
	info="$(date +"${THEME_CLOCK_FORMAT?}")"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_purple?}" "${box}"
}

function ___brainy_prompt_battery() {
	! _command_exists battery_percentage \
		|| [[ "${THEME_SHOW_BATTERY:-}" != "true" ]] \
		|| [[ "$(battery_percentage)" == "no" ]] && return

	local color="${bold_green?}" info
	info=$(battery_percentage)
	if [ "$info" -lt 50 ]; then
		color="${bold_yellow?}"
	elif [ "$info" -lt 25 ]; then
		color="${bold_red?}"
	fi
	local box="[|]" charging
	ac_adapter_connected && charging="+"
	ac_adapter_disconnected && charging="-"
	info+="${charging}"
	[ "$info" == "100+" ] && info="AC"
	printf "%s|%s|%s|%s" "${color}" "${info}" "${bold_white?}" "${box}"
}

function ___brainy_prompt_exitcode() {
	[[ "${THEME_SHOW_EXITCODE}" != "true" ]] && return
	local color="${bold_purple?}"
	[[ "${exitcode?}" -ne 0 ]] && printf "%s|%s" "${color}" "${exitcode}"
}

function ___brainy_prompt_char() {
	local color="${bold_white?}"
	local prompt_char="${__BRAINY_PROMPT_CHAR_PS1?}"
	printf "%s|%s" "${color}" "${prompt_char}"
}

#########
## cli ##
#########

function __brainy_show() {
	local _seg="${1?}"
	shift
	export "THEME_SHOW_${_seg}"=true
}

function __brainy_hide() {
	local _seg="${1?}"
	shift
	export "THEME_SHOW_${_seg}"=false
}

function _brainy_completion() {
	local cur _action actions segments
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	_action="${COMP_WORDS[1]}"
	actions="show hide"
	segments="battery clock exitcode python ruby scm sudo todo"
	case "${_action}" in
		show | hide)
			# shellcheck disable=SC2207
			COMPREPLY=($(compgen -W "${segments}" -- "${cur}"))
			return 0
			;;
	esac

	# shellcheck disable=SC2207
	COMPREPLY=($(compgen -W "${actions}" -- "${cur}"))
	return 0
}

function brainy() {
	local action="${1?}" func
	shift
	local segs=("${@?}")
	case "${action}" in
		show)
			func=__brainy_show
			;;
		hide)
			func=__brainy_hide
			;;
		*)
			_log_error "${FUNCNAME[0]}: unknown action '$action'"
			return 1
			;;
	esac
	for seg in "${segs[@]}"; do
		seg="$(printf "%s" "${seg}" | tr '[:lower:]' '[:upper:]')"
		"${func}" "${seg}"
	done
}

complete -F _brainy_completion brainy

###############
## Variables ##
###############

export SCM_THEME_PROMPT_PREFIX=""
export SCM_THEME_PROMPT_SUFFIX=""

export RBENV_THEME_PROMPT_PREFIX=""
export RBENV_THEME_PROMPT_SUFFIX=""
export RBFU_THEME_PROMPT_PREFIX=""
export RBFU_THEME_PROMPT_SUFFIX=""
export RVM_THEME_PROMPT_PREFIX=""
export RVM_THEME_PROMPT_SUFFIX=""
export VIRTUALENV_THEME_PROMPT_PREFIX=""
export VIRTUALENV_THEME_PROMPT_SUFFIX=""

export SCM_THEME_PROMPT_DIRTY=" ${bold_red?}✗${normal?}"
export SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓${normal?}"

: "${THEME_SHOW_SUDO:="true"}"
: "${THEME_SHOW_SCM:="true"}"
: "${THEME_SHOW_RUBY:="false"}"
: "${THEME_SHOW_PYTHON:="false"}"
: "${THEME_SHOW_CLOCK:="true"}"
: "${THEME_SHOW_TODO:="false"}"
: "${THEME_SHOW_BATTERY:="false"}"
: "${THEME_SHOW_EXITCODE:="true"}"

: "${THEME_CLOCK_COLOR:="${bold_white?}"}"
: "${THEME_CLOCK_FORMAT:="%H:%M:%S"}"

__BRAINY_PROMPT_CHAR_PS1="${THEME_PROMPT_CHAR_PS1:=">"}"
__BRAINY_PROMPT_CHAR_PS2="${THEME_PROMPT_CHAR_PS2:="\\"}"

: "${___BRAINY_TOP_LEFT:="user_info dir scm"}"
: "${___BRAINY_TOP_RIGHT:="python ruby todo clock battery"}"
: "${___BRAINY_BOTTOM:="exitcode char"}"

############
## Prompt ##
############

function __brainy_ps1() {
	printf "%s%s%s" "$(____brainy_top)" "$(____brainy_bottom)" "${normal?}"
}

function __brainy_ps2() {
	color=$bold_white
	printf "%s%s%s" "${color}" "${__BRAINY_PROMPT_CHAR_PS2?}  " "${normal?}"
}

function _brainy_prompt() {
	exitcode="$?"

	PS1="$(__brainy_ps1)"
	PS2="$(__brainy_ps2)"
}

safe_append_prompt_command _brainy_prompt
