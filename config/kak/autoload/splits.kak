provide-module splits %{
require-module terminal-window

def terminal-vertical -params ..1 %{
    nop %sh{swaymsg split vertical}
    terminal-window %arg[@]
}

def terminal-horizontal -params ..1 %{
    nop %sh{swaymsg split horizontal}
    terminal-window %arg[@]
}

def terminal-tab -params ..1 %{
    nop %sh{swaymsg 'split horizontal; layout tabbed'}
    terminal-window %arg[@]
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

}
