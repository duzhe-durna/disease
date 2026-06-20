provide-module cargo %{
declare-user-mode cargo

map global cargo r %{:cargo run<ret>}             -docstring "Run project" 
map global cargo c %{:cargo check<ret>}           -docstring "Check syntax" 
map global cargo n %{:cargo-next-error<ret>}      -docstring "Next error" 
map global cargo p %{:cargo-previous-error<ret>}  -docstring "Previous error" 
map global cargo f %{:format<ret>}                -docstring "Format" 
map global cargo b %{:b *cargo*<ret>}             -docstring "Open *cargo* buffer"

# https://github.com/krornus/kakoune-cargo
#######################
# Syntax highlighting #
#######################
add-highlighter shared/cargo group
add-highlighter shared/cargo/items regions
add-highlighter shared/cargo-share regions

# shared highlighters
# seperate region set in shared/ so it is not loaded by default
# these are used in both error and warning message region items
add-highlighter shared/cargo-share/rust region "^[0-9]+ \|" $ ref rust
add-highlighter shared/cargo-share/help region "^\s+\|" $ regions
add-highlighter shared/cargo-share/help/rust region "`" "`" ref rust
add-highlighter shared/cargo-share/help/info default-region group
add-highlighter shared/cargo-share/help/info/help regex "help" 0:default+b
add-highlighter shared/cargo-share/attribute region "#\[" \] ref rust

# error message
add-highlighter shared/cargo/items/error region "^error" "^\n" group
add-highlighter shared/cargo/items/error/context group
add-highlighter shared/cargo/items/error/error regex "^(error)(?:\[(E[0-9]+)\])?" 1:red+b 2:cyan
add-highlighter shared/cargo/items/error/arrow regex "(?S)(-->) (.+):([0-9]+):([0-9]+)" 1:red 2:default+b 3:cyan 4:cyan
add-highlighter shared/cargo/items/error/context/pointer regex "\s(-+|\^+)\s" 1:red+b
add-highlighter shared/cargo/items/error/context/share ref cargo-share

# warning message
add-highlighter shared/cargo/items/warning region "^(warning)" "^\n" group
add-highlighter shared/cargo/items/warning/context group
add-highlighter shared/cargo/items/warning/warning regex "^(warning)(?:\[(E[0-9]+)\])?" 1:yellow+b 2:cyan
add-highlighter shared/cargo/items/warning/arrow regex "(?S)(-->) (.+):([0-9]+):([0-9]+)" 1:yellow 2:default+b 3:cyan 4:cyan
add-highlighter shared/cargo/items/warning/context/pointer regex "\s(-+|\^+)\s" 1:yellow+b
add-highlighter shared/cargo/items/warning/context/share ref cargo-share

# finished message
add-highlighter shared/cargo/items/finished region "^\s+Finished dev" $ group
add-highlighter shared/cargo/items/finished/finished regex "Finished dev" 0:green+b
add-highlighter shared/cargo/items/finished/flags regions
add-highlighter shared/cargo/items/finished/flags/flags region \[ \] group
add-highlighter shared/cargo/items/finished/flags/flags/flag regex '[a-zA-Z0-9_\-]+' 0:cyan
add-highlighter shared/cargo/items/finished/seconds regex "in ([0-9]+\.[0-9]+)s" 1:default+b

# global highlighters
add-highlighter shared/cargo/error regex "^(error):" 1:red+b
add-highlighter shared/cargo/compile regex "^\s+Compiling" 0:green+b
add-highlighter shared/cargo/check regex "^\s+Checking" 0:yellow
add-highlighter shared/cargo/lineno regex "^([0-9]+) (\|)" 1:cyan+b 2:default

declare-option -docstring "regex describing cargo error references" \
    regex cargo_error_pattern \
    "^\h*(?:error|warning|note)(?:\[[A-Z0-9]+\])?: ([^\n]*)\n *--> ([^\n]*?):(\d+)(?::(\d+))?"


declare-option -hidden int cargo_current_error_line
declare-option -hidden str cargo_workspace_root

define-command cargo \
-override \
-params .. \
-docstring 'cargo [<arguments>]: cargo utility wrapper All the optional arguments are forwarded to the cargo utility' \
%{ eval -save-regs c %{ 
    try %{ db *cargo* }
    eval %sh{
        cmd="cargo"
        root=$(cargo locate-project --workspace --message-format plain 2> /dev/null)
        if [ $? -eq 0 ]; then
            root=$(dirname "$root")
            cmd="cargo $@"
        else
            root="."
            cmd="cargo -Zscript $@ --manifest-path '$kak_buffile'"
        fi

        printf %s "
            set global cargo_workspace_root %{$root}
            reg c %{$cmd}" 
    }
    echo -debug "running cargo cmd: %reg[c]"
    fifo -scroll -name *cargo* -script %exp{trap INT QUIT; %reg[c]}
    set buffer filetype cargo
} }

hook global WinSetOption filetype=cargo %{
    set-option buffer readonly true

    add-highlighter buffer/cargo ref cargo
    add-highlighter buffer/ wrap -word

    hook -group cargo-jump buffer NormalKey <ret> cargo-jump
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window cargo-* }
}

define-command -hidden cargo-open-error -params 4 %{
    evaluate-commands -try-client %opt{jumpclient} %{
        try %{
            edit -existing "%arg{1}" "%arg{2}" "%arg{3}"
        } catch %{
            edit -existing "%opt{cargo_workspace_root}/%arg{1}" "%arg{2}" "%arg{3}"
        }
        info -anchor "%arg{2}.%arg{3}" "%arg{4}"
        # try %{ focus %val{client} }
    }
}

define-command -hidden cargo-jump %{
    evaluate-commands %{
        # We may be in the middle of an error.
        # To find it, we search for the next error
        # (which definitely moves us past the end of this error)
        # and then search backward
        execute-keys "/" %opt{cargo_error_pattern} <ret>
        execute-keys <a-/> %opt{cargo_error_pattern} <ret><a-:> "<a-;>"

        # We found a Cargo error, let's open it.
        set-option buffer cargo_current_error_line "%val{cursor_line}"
        cargo-open-error \
            "%reg{2}" \
            "%reg{3}" \
            "%sh{ echo ${kak_main_reg_4:-1} }" \
            "%reg{1}"
    }
}

define-command cargo-next-error -docstring 'Jump to the next cargo error' %{
    try %{
        evaluate-commands -try-client %opt{jumpclient} %{
            buffer '*cargo*'
            execute-keys "%opt{cargo_current_error_line}gl" "/%opt{cargo_error_pattern}<ret>"
            cargo-jump
        }
        # Make sure the selected error is visible
        try %{
            evaluate-commands -client %opt{toolsclient} %{
                buffer '*cargo*'
                execute-keys %opt{cargo_current_error_line}gvv
            }
        }
    } catch %{
    	fail "No Cargo errors found"
    }
}

define-command cargo-previous-error -docstring 'Jump to the previous cargo error' %{
    try %{
        evaluate-commands -try-client %opt{jumpclient} %{
            buffer '*cargo*'
            execute-keys "%opt{cargo_current_error_line}gl" "<a-/>%opt{cargo_error_pattern}<ret>"
            cargo-jump
        }
        # Make sure the selected error is visible
        try %{
            evaluate-commands -client %opt{toolsclient} %{
                buffer '*cargo*'
                execute-keys %opt{cargo_current_error_line}gvv
            }
        }
    } catch %{
    	fail "No Cargo errors found"
    }
}

}
