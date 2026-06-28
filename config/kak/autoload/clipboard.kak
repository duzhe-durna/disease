provide-module clipboard %{

def copy-sys-clipboard %{ eval %sh{ wl-copy -- "$kak_selection" 2>/dev/null } }
def paste-sys-clipboard -params 1 %{ eval -save-regs \" %{
    reg dquote %sh{wl-paste 2>/dev/null}
    exec %arg{1}
} }

}

