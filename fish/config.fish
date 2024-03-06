alias lsa="exa --header --long --icons"
alias 7zip="7zz x '*.zip' -o'*' && rm -fr *.zip"
alias 7rar="7zz x '*.rar' -o'*' && rm -fr *.rar"
alias 77z="7zz x '*.7z' -o'*' && rm -fr *.7z"
alias lsa="exa --all --header --long --icons"
alias 7zip="7zz x '*.zip' -o'*' && rm -fr *.zip"
alias 7rar="7zz x '*.rar' -o'*' && rm -fr *.rar"
alias 77z="7zz x '*.7z' -o'*' && rm -fr *.7z"
alias lst="exa --all --header --long --icons --tree --level=3 --git-ignore"
alias ai-server="tabby serve --device metal --model TabbyML/StarCoder-1B"
alias nv="neovide"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
starship init fish | source
zoxide init fish | source

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
