#!/usr/bin/env bash

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" |"
SCM_THEME_PROMPT_SUFFIX="${bold_yellow}|"

GIT_THEME_PROMPT_DIRTY=" ${bold_red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX="${bold_yellow}|${bold_purple}"
GIT_THEME_PROMPT_SUFFIX="${bold_yellow}|"

RVM_THEME_PROMPT_PREFIX="|"
RVM_THEME_PROMPT_SUFFIX="|"

BASH_THEME_LAST_CMD_SUCCESS="${bold_green}✓"
BASH_THEME_LAST_CMD_FAILED="${bold_red}✗"

SCM_GIT_SHOW_DETAILS=false
SCM_GIT_SHOW_REMOTE_INFO=false
SCM_GIT_IGNORE_UNTRACKED=true
SCM_GIT_SHOW_CURRENT_USER=false

SCM_GIT_CHAR=' ±'
SCM_NONE_CHAR=''

function prompt_command() {
PS1="$(last_cmd_info)$(in_vim_shell)${bold_yellow}|${bold_cyan}$(user_info)${bold_green}$(remote_info)${bold_blue}\W${bold_yellow}$(scm_char)${green}$(scm_prompt_info) ${bold_cyan}\$${normal} "
}

safe_append_prompt_command prompt_command
