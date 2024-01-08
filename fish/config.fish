alias lsa="exa --header --long --icons"
alias 7zip="7zz x '*.zip' -o'*' && rm -fr *.zip"
alias 7rar="7zz x '*.rar' -o'*' && rm -fr *.rar"
alias 77z="7zz x '*.7z' -o'*' && rm -fr *.7z"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
starship init fish | source
zoxide init fish | source
