# Load colors for Zsh
autoload -U colors && colors

# Enable prompt variable expansion
setopt prompt_subst

# Git prompt theming
ZSH_THEME_GIT_PROMPT_PREFIX="git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Ruby prompt theming
ZSH_THEME_RUBY_PROMPT_PREFIX="("
ZSH_THEME_RUBY_PROMPT_SUFFIX=")"

# Use color in diff if available
if command diff --color /dev/null{,} &>/dev/null; then
  function diff {
    command diff --color "$@"
  }
fi

# Disable ls coloring if specified
[[ "$DISABLE_LS_COLORS" == true ]] && return 0

# Set default ls coloring for BSD-based ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Set default ls coloring for GNU-based ls
if [[ -z "$LS_COLORS" ]]; then
  if command -v dircolors &>/dev/null; then
    eval "$(dircolors -b "$HOME/.dircolors" 2>/dev/null || dircolors -b)"
  else
    export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  fi
fi

# Function to test ls arguments
function test-ls-args {
  local cmd="$1"
  shift
  command "$cmd" "$@" /dev/null &>/dev/null
}

# Configure ls based on OS type
case "$OSTYPE" in
  netbsd*)
    test-ls-args gls --color && alias ls='gls --color=tty'
    ;;
  openbsd*)
    test-ls-args gls --color && alias ls='gls --color=tty'
    test-ls-args colorls -G && alias ls='colorls -G'
    ;;
  (darwin|freebsd)*)
    test-ls-args ls -G && alias ls='ls -G'
    zstyle -t ':omz:lib:theme-and-appearance' gnu-ls && test-ls-args gls --color && alias ls='gls --color=tty'
    ;;
  *)
    test-ls-args ls --color && alias ls='ls --color=tty'
    test-ls-args ls -G && alias ls='ls -G'
    ;;
esac
