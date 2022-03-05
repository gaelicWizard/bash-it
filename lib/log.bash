# shellcheck shell=bash
#
# A collection of logging functions.

# Avoid duplicate inclusion
if [[ "${__bi_log_imported:-}" == "loaded" ]]; then
	return 0
fi
__bi_log_imported="loaded"

# Declare log severity levels, matching syslog numbering
: "${BASH_IT_LOG_LEVEL_FATAL:=1}"
: "${BASH_IT_LOG_LEVEL_ERROR:=3}"
: "${BASH_IT_LOG_LEVEL_WARNING:=4}"
: "${BASH_IT_LOG_LEVEL_ALL:=6}"
: "${BASH_IT_LOG_LEVEL_INFO:=6}"
: "${BASH_IT_LOG_LEVEL_TRACE:=7}"
readonly "${!BASH_IT_LOG_LEVEL_@}"

declare -a __bash_it_log_prefix=("log" "${__bash_it_log_prefix[@]:-core}")

function _bash_it_log_prefix_pop() {
	_log_trace "End${1:+ (}${1:-}${1:+)}"
	unset -v '__bash_it_log_prefix[0]'
	__bash_it_log_prefix=("${__bash_it_log_prefix[@]:-default}")
}

function _bash_it_log_prefix_push() {
	local component_path="${_bash_it_log_section:-${1:-default}}"
	unset _bash_it_log_section
	local without_extension component_directory
	local component_filename component_type component_name

	# get the directory, if any
	component_directory="${component_path%/*}"
	# drop the directory, if any
	component_filename="${component_path##*/}"
	# strip the file extension
	without_extension="${component_filename%.bash}"
	# strip before the last dot
	component_type="${without_extension##*.}"
	# strip component type, but try not to strip other words
	# - aliases, completions, plugins, themes
	component_name="${without_extension%.[acpt][hlo][eimu]*[ens]}"
	# Finally, strip load priority prefix
	component_name="${component_name##[[:digit:]][[:digit:]][[:digit:]]"${BASH_IT_LOAD_PRIORITY_SEPARATOR:----}"}"

	# best-guess for files without a type
	if [[ "${component_type:-${component_name}}" == "${component_name}" ]]; then
		if [[ "${component_directory}" == *'vendor'* ]]; then
			component_type='vendor'
		else
			component_type="${component_directory##*/}"
		fi
	fi

	if [[ -r "$component_path" ]]; then
		__bash_it_log_prefix=("${component_type:-default}: $component_name" "${__bash_it_log_prefix[@]}")
	elif [[ -n "$component_path" ]]; then
		__bash_it_log_prefix=("${component_name}" "${__bash_it_log_prefix[@]}")
	fi
	_log_trace "Begin" "${component_name}"
}

function _has_colors() {
	# Check that stdout is a terminal, and that it has at least 8 colors.
	[[ -t 1 && "${CLICOLOR:=$(tput colors 2> /dev/null)}" -ge 8 ]]
}

function _bash_it_log_message() {
	about 'Internal function used for logging, uses __bash_it_log_prefix as a prefix'
	param '1: color of the message'
	param '2: severity of the message'
	param '3: message to log'
	group 'log'

	message="($SECONDS) $2: ${__bash_it_log_prefix[1]:-}${__bash_it_log_prefix[1]:+: }${__bash_it_log_prefix[0]:-default}: $3"
	_has_colors && echo -e "$1${message}${echo_normal:-}" || echo -e "${message}"
}

function _log_trace() {
	[[ "${BASH_IT_LOG_LEVEL:-0}" -ge ${BASH_IT_LOG_LEVEL_TRACE?} ]] || return 0

	about 'log a message by echoing to the screen. needs BASH_IT_LOG_LEVEL >= BASH_IT_LOG_LEVEL_TRACE'
	param '1: message to log'
	param '2: message origin'
	example '$ _log_trace "Entering theme plugin"'
	group 'log'

	_bash_it_log_message "${echo_blue:-}" "TRACE" "$1${2:+ (}${2:-}${2:+)}"
}

function _log_debug() {
	[[ "${BASH_IT_LOG_LEVEL:-0}" -ge ${BASH_IT_LOG_LEVEL_INFO?} ]] || return 0

	about 'log a debug message by echoing to the screen. needs BASH_IT_LOG_LEVEL >= BASH_IT_LOG_LEVEL_INFO'
	param '1: message to log'
	example '$ _log_debug "Loading plugin git..."'
	group 'log'

	_bash_it_log_message "${echo_green:-}" "DEBUG" "$1"
}

function _log_warning() {
	[[ "${BASH_IT_LOG_LEVEL:-0}" -ge ${BASH_IT_LOG_LEVEL_WARNING?} ]] || return 0

	about 'log a message by echoing to the screen. needs BASH_IT_LOG_LEVEL >= BASH_IT_LOG_LEVEL_WARNING'
	param '1: message to log'
	example '$ _log_warning "git binary not found, disabling git plugin..."'
	group 'log'

	_bash_it_log_message "${echo_yellow:-}" " WARN" "$1"
}

function _log_error() {
	[[ "${BASH_IT_LOG_LEVEL:-0}" -ge ${BASH_IT_LOG_LEVEL_ERROR?} ]] || return 0

	about 'log a message by echoing to the screen. needs BASH_IT_LOG_LEVEL >= BASH_IT_LOG_LEVEL_ERROR'
	param '1: message to log'
	example '$ _log_error "Failed to load git plugin..."'
	group 'log'

	_bash_it_log_message "${echo_red:-}" "ERROR" "$1"
}

# Aliases have no scope, so we can manipulate the global environment.
alias _log_clean_aliases_and_trap="trap - RETURN; unalias source . _log_clean_aliases_and_trap; _log_trace 'Log trace unregistered.'"
_bash_it_library_finalize_hook+=('trap - RETURN' 'unalias source . _log_clean_aliases_and_trap' '_log_trace "Log trace unregistered."')
alias source='_bash_it_log_prefix_push "${BASH_SOURCE##*/}" && builtin source'
alias .=source
trap _bash_it_log_prefix_pop RETURN
