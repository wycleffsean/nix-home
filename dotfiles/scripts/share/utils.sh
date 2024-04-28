# readlink -f (---canonicalize) is not available on MacOS
readlinkf(){ perl -MCwd -e 'print Cwd::abs_path shift' "$1";}

# Sourcing
try_source() {
    full_path=$(readlinkf $1)
  if [[ -e "${full_path}" ]]; then
   source "$full_path"
  fi
}

# Formatting

cprintf() {
    black='\e[0;30m' # Black - Regular
    red='\e[0;31m' # Red
    green='\e[0;32m' # Green
    yellow='\e[0;33m' # Yellow
    blue='\e[0;34m' # Blue
    purple='\e[0;35m' # Purple
    cyan='\e[0;36m' # Cyan
    white='\e[0;37m' # White

    default="${white}"

    echo -e "$1"
}

# Logging

info(){
  reset="${yellow}"
  cprintf "${reset}$1${default}" 1>&2
}

error(){
  reset="${red}"
  cprintf "${reset}ERROR: ${default}$1" 1>&2
}
