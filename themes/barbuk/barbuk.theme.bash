# shellcheck shell=bash
# shellcheck disable=SC2034 # Expected behavior for themes.

# Theme custom glyphs
: "${BARBUK_GITLAB_CHAR:='  '}"
: "${BARBUK_BITBUCKET_CHAR:='  '}"
: "${BARBUK_GITHUB_CHAR:='  '}"
: "${BARBUK_GIT_DEFAULT_CHAR:='  '}"
: "${BARBUK_GIT_BRANCH_ICON:=''}"
: "${BARBUK_HG_CHAR:='☿ '}"
: "${BARBUK_SVN_CHAR:='⑆ '}"
: "${BARBUK_EXIT_CODE_ICON:=' '}"
: "${BARBUK_PYTHON_VENV_CHAR:=' '}"
: "${BARBUK_COMMAND_DURATION_ICON:="${bold_blue?}  "}"

# Command duration
: "${COMMAND_DURATION_MIN_SECONDS:=1}"
: "${COMMAND_DURATION_COLOR:="${normal?}"}"

# Ssh user and hostname display
SSH_INFO=${BARBUK_SSH_INFO:=true}
HOST_INFO=${BARBUK_HOST_INFO:=long}

# Bash-it default glyphs overrides
SCM_NONE_CHAR=
SCM_THEME_PROMPT_DIRTY=" ${bold_red?}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
SCM_THEME_PROMPT_PREFIX="|"
SCM_THEME_PROMPT_SUFFIX="${green?}| "
SCM_GIT_BEHIND_CHAR="${bold_red?}↓${normal?}"
SCM_GIT_AHEAD_CHAR="${bold_green?}↑${normal?}"
SCM_GIT_UNTRACKED_CHAR="⌀"
SCM_GIT_UNSTAGED_CHAR="${bold_yellow?}•${normal?}"
SCM_GIT_STAGED_CHAR="${bold_green?}+${normal?}"
GIT_THEME_PROMPT_DIRTY=" ${bold_red?}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green?}✓"
GIT_THEME_PROMPT_PREFIX="${cyan?}"
GIT_THEME_PROMPT_SUFFIX="${cyan?}"
SCM_THEME_BRANCH_TRACK_PREFIX="${normal?} ⤏  ${cyan?}"
SCM_THEME_CURRENT_USER_PREFFIX='  '
SCM_GIT_SHOW_CURRENT_USER='false'

function _git-uptream-remote-logo() {
	[[ -z "$(_git-upstream)" ]] && SCM_GIT_CHAR="${SCM_GIT_CHAR_DEFAULT:-}"

	local remote remote_domain
	remote="$(_git-upstream-remote)"
	remote_domain="$(git config --get remote."${remote}".url | awk -F'[@:.]' '{print $2}')"

	# remove // suffix for https:// url
	remote_domain="${remote_domain//\//}"

	case "${remote_domain}" in
		github) SCM_GIT_CHAR="${SCM_GIT_CHAR_GITHUB:-}" ;;
		gitlab) SCM_GIT_CHAR="${SCM_GIT_CHAR_GITLAB:-}" ;;
		bitbucket) SCM_GIT_CHAR="${SCM_GIT_CHAR_BITBUCKET:-}" ;;
		*) SCM_GIT_CHAR="${SCM_GIT_CHAR_DEFAULT:-}" ;;
	esac
}

function git_prompt_info() {
	git_prompt_vars
	echo -e " on ${SCM_GIT_CHAR_ICON_BRANCH:-} ${SCM_PREFIX:-}${SCM_BRANCH:-}${SCM_STATE:-}${SCM_GIT_AHEAD:-}${SCM_GIT_BEHIND:-}${SCM_GIT_STASH:-}${SCM_SUFFIX:-}"
}

function _exit-code() {
	if [[ "${1:-}" -ne 0 ]]; then
		exit_code=" ${purple?}${EXIT_CODE_ICON:-}${yellow?}${exit_code:-}${bold_orange?}"
	else
		exit_code="${bold_green?}"
	fi
}

function _prompt() {
	local exit_code="$?" wrap_char=' ' dir_color=$green ssh_info='' python_venv='' host command_duration=
	local scm_char scm_prompt_info

	command_duration="$(_command_duration)"

	_exit-code exit_code
	_git-uptream-remote-logo

	_save-and-reload-history 1

	# Detect root shell
	if [[ "${USER:-${LOGNAME:?}}" == root ]]; then
		dir_color="${red?}"
	fi

	# Detect ssh
	if [[ -n "${SSH_CONNECTION:-}" && "${SSH_INFO:-}" == true ]]; then
		if [[ "${HOST_INFO:-}" == long ]]; then
			host="\H"
		else
			host="\h"
		fi
		ssh_info="${bold_blue?}\u${bold_orange?}@${cyan?}$host ${bold_orange?}in"
	fi

	# Detect python venv
	if [[ -n "${CONDA_DEFAULT_ENV:-}" ]]; then
		python_venv="${PYTHON_VENV_CHAR:-}${CONDA_DEFAULT_ENV:-} "
	elif [[ -n "${VIRTUAL_ENV:-}" ]]; then
		python_venv="$PYTHON_VENV_CHAR${VIRTUAL_ENV##*/} "
	fi

	scm_char="$(scm_char)"
	scm_prompt_info="$(scm_prompt_info)"
	PS1="\\n${ssh_info} ${purple}${scm_char}${python_venv}${dir_color}\\w${normal}${scm_prompt_info}${command_duration}${exit_code}"
	[[ ${#PS1} -gt $((COLUMNS * 2)) ]] && wrap_char="\\n"
	PS1="${PS1}${wrap_char}❯${normal} "
}

safe_append_prompt_command _prompt
