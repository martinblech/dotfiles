autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

rb_prompt(){
  if (( $+commands[rbenv] ))
  then
	  echo "%{$fg_bold[yellow]%}$(rbenv version | awk '{print $1}')%{$reset_color%}"
	else
	  echo ""
  fi
}

# This keeps the number of todos always available the right hand side of my
# command line. I filter it to only count those tagged as "+next", so it's more
# of a motivation to clear out the list.
todo(){
  if (( $+commands[todo.sh] ))
  then
    num=$(echo $(todo.sh ls +next | wc -l))
    let todos=num-2
    if [ $todos != 0 ]
    then
      echo "$todos"
    else
      echo ""
    fi
  else
    echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%~%\/%{$reset_color%}"
}

export PROMPT=$'\n%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in $(directory_name)\n› '

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{28}●'
zstyle ':vcs_info:*' unstagedstr '%F{11}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' [%F{green}%b%c%u%F{blue}]'
    } else {
        zstyle ':vcs_info:*' formats ' [%F{green}%b%c%u%F{red}●%F{blue}]'
    }
 
    vcs_info
}

export RPROMPT=$'${vcs_info_msg_0_}%{$reset_color%}'
