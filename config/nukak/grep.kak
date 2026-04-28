define-command -params .. -docstring %{
    grep [<arguments>]: grep utility wrapper
    All optional arguments are forwarded to the grep utility
    Passing no argument will perform a literal-string grep for the current selection
} grep %{
    evaluate-commands -save-regs gs %{
        set-register g %opt{grepcmd}
        set-register s %val{selection}
        evaluate-commands -try-client %opt{toolsclient} %{
            fifo -name *grep* -script %{
                trap - INT QUIT
                grepcmd=${kak_reg_g}
                selection=${kak_reg_s}
                if [ $# -eq 0 ]; then
                    case "$grepcmd" in
                    ag\ * | git\ grep\ * | grep\ * | rg\ * | ripgrep\ * | ugrep\ * | ug\ *)
                        set -- -F -- "$selection"
                        ;;
                    ack\ *)
                        set -- -Q -- "$selection"
                        ;;
                    *)
                        set -- -- "$selection"
                        ;;
                    esac
                fi
                eval "$grepcmd \"\$@\"" 2>&1 | tr -d '\r'
            } -- %arg{@}
            set-option buffer filetype grep
            set-option buffer jump_current_line 0
        }
    }
}

