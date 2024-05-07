# Using highlight (http://www.andre-simon.de/doku/highlight/en/highlight.html)
export FZF_DEFAULT_COMMAND='rg -g "" --hidden --ignore ".git/*"'

export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

function try_source() {
  if [[ -e $1 ]]; then
   source $1
  fi
}

# Auto-completion
# [[ $- == *i* ]] && try_source('/usr/local/opt/fzf/shell/completion.zsh') 2> /dev/null
# [[ $- == *i* ]] && try_source("/usr/share/fzf//completion.zsh") 2> /dev/null

# Key-bindings
try_source '/usr/local/opt/fzf/shell/key-bindings.zsh'
try_source '/usr/share/fzf/key-bindings.zsh'


function ftop() {
    ps -ef | fzf --bind 'ctrl-r:reload(ps -ef)' --header 'Press CTRL-R to reload' \
     --header-lines=1 --layout=reverse
}

# https://gist.github.com/seven1m/8c87fccb2535e74b835f0d9dcb878747#file-fzf_branch_selection-zsh
# fuzzy finder branch selection
# if run by itself, switches to the selected branch
# if run in a subshell, echos the selected branch
function fgb() {
  if [[ "$ZSH_SUBSHELL" == "0" ]]; then
    git checkout $(fgb)
  else
    gbranches |
      fzf --height 40% --ansi |
      awk '{print $1}' |
      sed 's#^remotes/[^/]*/##'
  fi
}

function gbranches() {
  local ansi_reset="\\e[0m"
  local ansi_dim="\\e[2m"
  local ansi_green="\\e[32m"
  local ansi_yellow="\\e[33m"
  git branch |
    sed 's/^..//' |
    ruby -e "puts STDIN.read.split(/\n/).map { |b| b = b.split.first; [b, %x(git log --format='%ai ${ansi_dim}%hi${ansi_reset} ${ansi_yellow}%s${ansi_reset}' #{b} | head -1)] }.sort_by(&:last).reverse.map { |b, c| %(${ansi_green} #{b.ljust(50)} ${ansi_reset} #{c}) }"
}

fzf-git-branch-accept() {
  fgb
  zle accept-line
}
zle     -N       fzf-git-branch-accept
bindkey '^X^B'   fzf-git-branch-accept
