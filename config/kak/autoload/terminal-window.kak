provide-module terminal-window %{

def terminal-window -docstring %{
    terminal-window [shell-script]: open terminal with provided (optional) script
} -params ..1 %{ eval %sh{
    if [ $# -gt 0 ]; then
        alacritty msg create-window --working-directory $PWD -e sh -c "$@"
    else 
        alacritty msg create-window --working-directory $PWD
    fi
} }

}

