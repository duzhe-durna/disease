# wayland

provide-module wayland %{

# ensure that we're running in the right environment
evaluate-commands %sh{
    [ -z "${kak_opt_windowing_modules}" ] || [ -n "$WAYLAND_DISPLAY" ] || echo 'fail WAYLAND_DISPLAY is not set'
}

# termcmd should be set such as the next argument is the whole
# command line to execute
declare-option -docstring %{shell command run to spawn a new terminal
A shell command is appended to the one set in this option at runtime} \
    str termcmd  'alacritty msg create-window -e sh -c' 

define-command wayland-terminal-window -override -params 1.. -docstring '
wayland-terminal-window <program> [<arguments>]: create a new terminal as a Wayland window
The program passed as argument will be executed in the new terminal' \
%{
    evaluate-commands -save-regs 'a' %{
        set-register a %arg{@}
        evaluate-commands %sh{ $kak_opt_termcmd "$kak_reg_a" }
    }
}
complete-command wayland-terminal-window shell

define-command wayland-focus -params ..1 -docstring '
wayland-focus [<kakoune_client>]: focus a given client''s window
If no client is passed, then the current client is used' \
%{
    fail 'Focusing specific windows in most Wayland window managers is unsupported'
}
complete-command -menu wayland-focus client

alias global focus wayland-focus

# deprecated
define-command -hidden wayland-terminal -params 1.. %{
    wayland-terminal-window %arg{@}
}

}
