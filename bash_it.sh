#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR/lib source-path=SCRIPTDIR/scripts
# shellcheck disable=SC2034
#
# Initialize Bash It
: "${BASH_IT:=${BASH_SOURCE%/*}}"
: "${BASH_IT_CUSTOM:=${BASH_IT}/custom}"
: "${CUSTOM_THEME_DIR:="${BASH_IT_CUSTOM}/themes"}"
: "${BASH_IT_BASHRC:=${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}}"

# Load composure first, so we support function metadata
# shellcheck source-path=SCRIPTDIR/vendor/github.com/erichs/composure
source "${BASH_IT}/vendor/github.com/erichs/composure/composure.sh"
# support 'plumbing' metadata
cite _about _param _example _group _author _version
cite about-alias about-plugin about-completion

# Declare our end-of-main finishing hook, but don't use `declare`/`typeset`
_bash_it_library_finalize_hook=()

# We need to load logging module early in order to be able to log
source "${BASH_IT}/lib/log.bash"
_bash_it_log_prefix_push "main"

# Load libraries
_log_debug "Loading libraries..."
for _bash_it_main_file_lib in "${BASH_IT}/lib"/*.bash; do
	_bash_it_log_section="${_bash_it_lib_file}"
	_log_debug "Loading library file..."
	# shellcheck disable=SC1090
	source "$_bash_it_main_file_lib"
done

# Load the global "enabled" directory, then enabled aliases, completion, plugins
# "_bash_it_main_file_type" param is empty so that files get sourced in glob order
for _bash_it_main_file_type in "" "aliases" "plugins" "completion"; do
	_bash_it_log_section=reloader
	_log_debug "Loading '${_bash_it_main_file_type}'..."
	source "${BASH_IT}/scripts/reloader.bash" "${_bash_it_main_file_type:+skip}" "$_bash_it_main_file_type"
	#_where_from "${BASH_IT}/scripts/reloader.bash"
done

# Load theme, if a theme was set
# shellcheck source-path=SCRIPTDIR/themes
if [[ -n "${BASH_IT_THEME:=custom}" ]]; then
	_log_debug "Loading theme '${BASH_IT_THEME}'."

	# shellcheck disable=SC1090
	if [[ -f "${BASH_IT_THEME}" ]]; then
		source "${BASH_IT_THEME}"
			#_where_from "${BASH_IT_THEME}"
	elif [[ -f "$CUSTOM_THEME_DIR/$BASH_IT_THEME/$BASH_IT_THEME.theme.bash" ]]; then
		source "$CUSTOM_THEME_DIR/$BASH_IT_THEME/$BASH_IT_THEME.theme.bash"
	elif [[ -f "$BASH_IT/themes/$BASH_IT_THEME/$BASH_IT_THEME.theme.bash" ]]; then
		source "$BASH_IT/themes/$BASH_IT_THEME/$BASH_IT_THEME.theme.bash"
			#_where_from "$BASH_IT/themes/$BASH_IT_THEME/$BASH_IT_THEME.theme.bash"
	fi
	_bash_it_log_prefix_pop "theme"
fi

_bash_it_log_prefix_push "custom"
_log_debug "Loading custom aliases, completion, plugins..."
for _bash_it_main_file_type in "aliases" "completion" "plugins"; do
	_bash_it_main_file_custom="${BASH_IT}/${_bash_it_main_file_type}/custom.${_bash_it_main_file_type}.bash"
	if [[ -s "${_bash_it_main_file_custom}" ]]; then
		_bash_it_log_section="${file_type}"
		_log_debug "Loading component..."
		# shellcheck disable=SC1090
		source "${_bash_it_main_file_custom}"
		#_where_from "${BASH_IT}/${file_type}/custom.${file_type}.bash"
	fi
done

# Custom
_log_debug "Loading general custom files..."
for _bash_it_main_file_custom in "${BASH_IT_CUSTOM}"/*.bash "${BASH_IT_CUSTOM}"/*/*.bash; do
	if [[ -s "${_bash_it_main_file_custom}" ]]; then
		_bash_it_log_section="${_bash_it_custom_file}"
		_log_debug "Loading custom file..."
		# shellcheck disable=SC1090
		source "$_bash_it_main_file_custom"
		#_where_from "$_bash_it_config_file"
	fi
done
_bash_it_log_prefix_pop "custom"

if [[ -n "${PROMPT:-}" ]]; then
_log_trace "Setting prompt..."
	PS1="${PROMPT}"
fi

# Adding Support for other OSes
if _command_exists gloobus-preview; then
	PREVIEW="gloobus-preview"
elif [[ -d /Applications/Preview.app ]]; then
	PREVIEW="/Applications/Preview.app"
else
	PREVIEW="less"
fi

for _bash_it_library_finalize_f in "${_bash_it_library_finalize_hook[@]:-}"; do
	_log_debug "Finalize hook: $_bash_it_library_finalize_f"
	eval "${_bash_it_library_finalize_f?}" # Use `eval` to achieve the same behavior as `$PROMPT_COMMAND`.
	_log_debug "Finalized: $_bash_it_library_finalize_f"
done
unset "${!_bash_it_library_finalize_@}" "${!_bash_it_main_file_@}"

[[ "${BASH_VERSINFO[0]}" -ge 5 ]] && echo "_Bash It_ spent $(($(echo $BASHPID) - $$)) while starting up ($SECONDS)."
