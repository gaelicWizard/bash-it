#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='shadowstar'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1
export DISABLE_USER_INFO=true

if [ -z $OSTYPE ]; then
	export OSTYPE=$(uname | tr [[:upper:]] [[:lower:]])
fi

# Load Bash It
source $BASH_IT/bash_it.sh

if $(locale -a 2>/dev/null | grep -q zh_CN.UTF-8); then
	export LANG="zh_CN.UTF-8"
	export LC_ALL="zh_CN.UTF-8"
elif $(locale -a 2>/dev/null | grep -q en_US.UTF-8); then
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
else
	export LANG="POSIX"
	export LC_ALL="POSIX"
fi

unset LSCOLORS

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias lh="ls -lh"
alias grep="grep --exclude 'tags' --exclude 'cscope.*' --binary-files=without-match --color=auto"

if [[ $OSTYPE =~ "darwin" ]]; then
	PATH=$PATH:/opt/bin:/opt/my_scripts
	if [[ -n ${CTPATH} ]]; then
		PATH=$PATH:$CTPATH
	fi
	GNUPATH=$(echo /usr/local/opt/*/libexec/gnubin | tr ' ' ':')
	if command -v brew >/dev/null; then
		if [[ -n $(brew list gnu-getopt) ]]; then
			GNUPATH=$GNUPATH:$(brew --prefix gnu-getopt)/bin
		fi
		if [[ -n $(brew list gettext) ]]; then
			GNUPATH=$GNUPATH:$(brew --prefix gettext)/bin
		fi
	fi
	export PATH
	export GNUPATH
	alias pkginfo="pkgutil -v --pkg-info"
	alias pkgf="pkgutil -v --files"
	alias pkgfinfo="pkgutil -v --file-info"
	alias pkgs="pkgutil --pkgs"
	alias pkgl="pkgutil --pkgs | grep -v \"^com\.apple\""
	alias ls="ls -G -F"
	alias GetBTMMAddr="echo show Setup:/Network/BackToMyMac | scutil | sed -n 's/.* : *\(.*\).$/\1/p'"
elif [[ $OSTYPE =~ "linux" ]]; then
	alias ls="ls --color=auto"
fi

if command -v vimpager >/dev/null; then
	export PAGER="vimpager"
fi

if command -v vim >/dev/null; then
	alias vi="vim"
fi

