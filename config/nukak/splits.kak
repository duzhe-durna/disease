def terminal -docstring 'Run command in new terminal window' -params 1 %{ eval -save-regs a %{
    reg a %arg[@]
    nop %sh{ (alacritty msg create-window --working-directory (pwd) -e nu -c $env.kak_reg_a) }
} }

def terminal-vertical -params 1 %{
    nop %sh{swaymsg split vertical}
    terminal %arg[1]
}

def terminal-horizontal -params 1 %{
    nop %sh{swaymsg split horizontal}
    terminal %arg[1]
}

def terminal-tab -params 1 %{
    nop %sh{swaymsg 'split horizontal; layout tabbed'}
    terminal %arg[1]
}

decl -hidden str buf_split_cmd
def -hidden update-buf-slit-cmd %{ set global buf_split_cmd %exp{
    kak -c '%val{session}' -e "buffer '%val{bufname}' ; select %val{selection_desc} ; exec vv"
} }

def buffer-split-vertical %{
    update-buf-slit-cmd
    terminal-vertical %opt{buf_split_cmd}
}

def buffer-split-horizontal %{
    update-buf-slit-cmd
    terminal-horizontal %opt{buf_split_cmd}
}

def buffer-split-tab %{
    update-buf-slit-cmd
    terminal-tab %opt{buf_split_cmd}
}

declare-user-mode window-mode

map global normal <c-w> ":enter-user-mode window-mode<ret>"

map global window-mode V ':terminal-horizontal nu<ret>' \
    -docstring 'Open terminal in a horizontal split'
map global window-mode T ':terminal-tab nu<ret>' \
    -docstring 'Open terminal in a tab'
map global window-mode S ':terminal-vertical nu<ret>' \
    -docstring 'Open terminal in a vertical split'

map global window-mode q ":q<ret>" \
    -docstring 'Quit current client'
map global window-mode v ':buffer-split-horizontal<ret>' \
    -docstring 'Open current buffer in a horizontal split'
map global window-mode s ':buffer-split-vertical<ret>' \
    -docstring 'Open current buffer in vertical split'
map global window-mode t ':buffer-split-tab<ret>' \
    -docstring 'Open current buffer in a tab'

