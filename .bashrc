# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#Show current git branch in bash
function parse_git_branch {
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo " ("${ref#refs/heads/}")"
}

# User specific environment and startup programs
color_prompt="yes"
if [ "$color_prompt" = yes ]; then
        PS1='[\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]]\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
        PS1='[\u@\h \W]$(parse_git_branch)\$ '
fi

gitresetfunction() {
  git fetch origin
  git reset --hard origin/$1
}

gitpullfunction() {
  git fetch origin
  git pull origin $1
}

gitgrepfunction() {
  # Ensure we have at least 2 params: a file name and a pattern.
  if [ "$#" -lt 2 ]; then
    echo "usage: $0 FILE_SPEC PATTERN..." >&2; 
  else  
    pattern="-e $1"  # Next argument is the first pattern.
    shift
    while test ${#} -gt 0
    do
      pattern="$pattern --and -e $1 "
      shift
    done
    # Find the patterns in the files.
    git grep -i -c $pattern
  fi
}

alias gitgrep=gitgrepfunction

alias gitreset=gitresetfunction

alias githead="git reset --hard HEAD@{0}"
alias gitpull=gitpullfunction

alias gitclean="git clean -f -d"

alias reloadbash="source ~/.bashrc"

alias apacheload="tail -n10000 /var/log/httpd/dev-access_log | awk '{print \$1}' | sort | uniq -c | sort -n | awk '{ if (\$1 > 20)print \$1,\$2}'"

export PATH="$PATH:~/node_modules/.bin" 
