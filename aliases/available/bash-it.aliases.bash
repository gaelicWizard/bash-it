# shellcheck shell=bash
about-alias 'Aliases for the bash-it command (these aliases are automatically included with the "general" aliases)'

# Common misspellings of bash-it
alias shit='bash-it'
alias batshit='bash-it'
alias bashit='bash-it'
alias batbsh='bash-it'
alias babsh='bash-it'
alias bash_it='bash-it'
alias bash_ti='bash-it'

# Additional bash-it aliases for help/show
alias bshsa='bash-it show aliases'
alias bshsc='bash-it show completions'
alias bshsp='bash-it show plugins'
alias bshha='bash-it help aliases'
alias bshhc='bash-it help completions'
alias bshhp='bash-it help plugins'
alias bshsch="bash-it search"
alias bshenp="bash-it enable plugin"
alias bshena="bash-it enable alias"
alias bshenc="bash-it enable completion"

# Bash It reload alias(es):
alias bash-it-reload='source "${BASH_IT_BASHRC}"'
if [[ -n "${BASH_IT_RELOAD_LEGACY:-}" ]]; then
	_log_trace "Enabling BASH_IT_RELOAD_LEGACY"
	alias reload='source "${BASH_IT_BASHRC}"'
fi
