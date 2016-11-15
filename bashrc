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
# Load Bash It
source $BASH_IT/bash_it.sh

if [ -d /usr/share/locale/zh_CN.UTF-8 ]; then
	export LANG="zh_CN.UTF-8"
	export LC_ALL="zh_CN.UTF-8"
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

if [ $(uname) = "Darwin" ]; then
	PATH=$PATH:/opt/bin:/opt/my_scripts
	if [[ -n ${CTPATH} ]]; then
		PATH=$PATH:$CTPATH
	fi
	GNUPATH=$(echo /usr/local/opt/*/libexec/gnubin | tr ' ' ':')
	if [[ -x $(which brew) ]]; then
		if [[ -n $(brew list gnu-getopt) ]]; then
			GNUPATH=$GNUPATH:$(brew --prefix gnu-getopt)/bin
		fi
		if [[ -n $(brew list gettext) ]]; then
			GNUPATH=$GNUPATH:$(brew --prefix gettext)/bin
		fi
		if [[ -n $(brew list polipo) ]]; then
			alias hp='http_proxy=http://localhost:8123'
		fi
	fi
	if [[ -x $(which boot2docker) ]]; then
		eval $(boot2docker shellinit 2>/dev/null)
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
elif [ $(uname) = "Linux" ]; then
	alias ls="ls --color=auto"
fi

if $(which vimpager >/dev/null 2>&1); then
	export PAGER="$(which vimpager)"
fi

