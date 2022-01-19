# shellcheck shell=bash
#
# A collection of logging functions.

# Avoid duplicate inclusion
if [[ "${__bi_log_imported:-}" == "loaded" ]]; then
	return 0
fi
__bi_log_imported="loaded"

source ~/Projects/logr/logr.bash
BASH_IT_LOG_LEVEL_V="-vvv"
logr start ${BASH_IT_LOG_LEVEL_V:-} "Bash It"
((__logr_scope_depth--)) # minus one to account for `lib/log.bash`.
#logr verbose

declare -a __bash_it_log_prefix=("log")

logr clone _log_trace
logr clone _log_debug
logr clone _log_warning
logr clone _log_error

function _bash_it_log_prefix_push() {
	local IFS=$'\t\n' # Avoid word splitting.
	local component_path="${1:-default}"
	local prefix="${_bash_it_log_section:-${component_path}}"
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
		__bash_it_log_prefix=("${component_type:-default}: $component_name" ${__bash_it_log_prefix[@]:-})
	elif [[ -n "$component_path" ]]; then
		__bash_it_log_prefix=("${component_name}" ${__bash_it_log_prefix[@]:-})
	fi
	_log_trace "Begin" "${component_name}"
}

function _bash_it_log_prefix_pop() {
	local IFS=$'\t\n' # Avoid word splitting.
	_log_trace "End${1:+ (}${1:-}${1:+)}: ${__bash_it_log_prefix[@]:-}"
	__bash_it_log_prefix=(${__bash_it_log_prefix[@]:1})
}

function _has_colors() {
	# Check that stdout is a terminal, and that it has at least 8 colors.
	[[ -t 1 && "${CLICOLOR:=$(tput colors 2> /dev/null)}" -ge 8 ]]
}

# Aliases have no scope, so we can manipulate the global environment.
alias _log_clean_aliases_and_trap="trap - RETURN; unalias source . _log_clean_aliases_and_trap; _log_trace 'Log trace unregistered.'"

_bash_it_library_finalize_hook+=('trap - RETURN' 'unalias source . _log_clean_aliases_and_trap')

alias source='_bash_it_log_prefix_push && _log_trace "Loading: ${__bash_it_log_prefix[0]:-${BASH_SOURCE[0]##*/}}" && builtin source'
alias .=source

trap '_log_trace "Loaded: ${__bash_it_log_prefix[0]:-${BASH_SOURCE[0]##*/}}" && _bash_it_log_prefix_pop' RETURN
