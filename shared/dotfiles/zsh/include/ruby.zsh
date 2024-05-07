function try_source() {
  if [[ -e $1 ]]; then
   source $1
  fi
}

try_source /usr/share/chruby/chruby.sh
try_source /usr/share/chruby/auto.sh
