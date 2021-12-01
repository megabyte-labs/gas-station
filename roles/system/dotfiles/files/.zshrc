eval "$(starship init zsh)"

if type molecule &> /dev/null; then
  eval "$(_MOLECULE_COMPLETE=zsh_source molecule)"
fi
