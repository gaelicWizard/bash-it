# shellcheck shell=bash
cite about-plugin
about-plugin 'source into environment when cding to directories'
url "https://github.com/Bash-it/bash-it"

function autoenv_init() {
	local homes _file
	local -a _files
	homes="${HOME%/*}"

	IFS=$'\n' read -r -d '' -a _files < <(
		# subshell to contain effects of "cd"
		while [[ "$PWD" != "/" && "$PWD" != "$homes" ]]; do
			_file="$PWD/.env"
			if [[ -e "${_file}" ]]; then
				printf '%s\0' "${_file}"
			fi
			builtin cd .. || true
		done
	)

	_file=${#_files[@]}
	while ((_file > 0)); do
		#shellcheck disable=SC1090
		source "${_files[_file]}"
		: $((_file -= 1))
	done
}

function cd() {
	builtin cd "$@" || return $?
	autoenv_init
}
