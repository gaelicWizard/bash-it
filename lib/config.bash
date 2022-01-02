# shellcheck shell=bash
#
# Portable configuration file parser, compatible with Bash 3+ (and others) using only `awk`.

#TODO: https://github.com/mrbaseman/parse_yaml.git

function _config_parse_simple() {
	local _file_to_parse="${1?${FUNCNAME[0]}: configuration file must be specified}"
	local _variable_to_read="${2?${FUNCNAME[0]}: parameter to load must be provided}"

	local line        # parameter value from matching lines
	local -a lines=() # combined content of all matching lines

	local IFS=$' \t'"=:" #newline=$'\n'
	while read -ra line; do
		lines+=("${line[@]:1}") # strip the variable name itself
	done < <(awk -F '['"${IFS}"']+' '/^'"${_variable_to_read}"'e?s?['"${IFS}"']/ { print $0 }' "${_file_to_parse}")
	#TODO: if empty, read from default? "${BASH_IT?}/config.ini"

	printf -v "${FUNCNAME[0]}" '%s\n' "${lines[*]}"
	#TODO: what about an array...?
}

function _bash-it-config-load-global() {
	local _config_setting="${1?${FUNCNAME[0]}: identifier must be supplied}" _config_parse_file

	_config_parse_file "${XDG_CONFIG_HOME:-$HOME/.config}/bash_it/config.ini" "${_config_setting}" && _log_debug "read '$_config_setting' from stored configuration: $_config_parse_file"
	printf -v "${_config_setting}" '%s' "${_config_parse_file?}"
}

function _bash-it-config-load-profile() {
	return 1 # TODO: take a profile name argument
	local _config_setting="${1?${FUNCNAME[0]}: identifier must be supplied}"

	_config_parse_file "${XDG_CONFIG_HOME:-$HOME/.config}/bash_it/config.ini" "${_config_setting}"
}
