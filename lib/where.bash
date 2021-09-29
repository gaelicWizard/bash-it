# shellcheck shell=bash
#
# Load _where.bash from the vendors folder

: "${WHERE_HOOK_SOURCE:=false}"
: "${WHERE_EXPIRATION:=3600}"

# shellcheck source-path=SCRIPTDIR/_where.bash
source "${BASH_IT?}/vendor/github.com/gaelicWizard/where/_where.bash"

function _where_from_here()
{
	local type="${BASH_COMMAND[1]:-${1:-}}"
	type="${type%% *}"
	# ${BASH_SOURCE[1]} is the file that called us,
	# ${BASH_LINENO[0]} is the line number of that file.
	_where_from_to_index+=( "${type:-thing} ${BASH_LINENO[0]:-NaN} ${BASH_SOURCE[1]:-/dev/stdin}" )
}
alias alias='_where_from_here alias && builtin alias'

function _where_from_here_process()
{
	local -i i _where_from_caller_lineno
	local _where_from_caller_type _where_from_caller_line_and_source _where_from_caller_source
	for i in "${!_where_from_to_index[@]}"
	do
		_where_from_caller_type="${_where_from_to_index[i]%% *}"
		_where_from_caller_line_and_source="${_where_from_to_index[i]#* }"
		_where_from_caller_source="${_where_from_caller_line_and_source#* }"
		_where_from_caller_lineno="${_where_from_caller_line_and_source%% *}"
		[[ "${_where_from_caller_source:-/dev/stdin}" == "/dev/stdin" ]] && continue
		_bash-it-array-contains-element "${_where_from_caller_source}" "${_where_from_aliases_to_index[@]}" \
			|| _where_from_aliases_to_index+=( "${_where_from_caller_source}" )
		unset '_where_from_to_index[i]'
	done

	for i in "${!_where_from_aliases_to_index[@]}"
	do
		_where_from "${_where_from_aliases_to_index[i]}"
		unset '_where_from_aliases_to_index[i]'
	done
}

_where_from_aliases_to_index+=( "${BASH_SOURCE[@]}" )

#_bash_it_library_finalize_hook+=( '_where_from_here_process' )
