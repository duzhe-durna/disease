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
%{
    evaluate-commands %sh{
        if ! cargo locate-project &> /dev/null; then
            printf "fail Not in cargo directory";
        else
            printf "nop"
        fi
    }
    try %{ db *cargo* }
    fifo -name *cargo* -script %{trap INT QUIT; cargo "$@"} -- %arg{@}

    map -docstring "Jump to current error" buffer normal <ret> %{: cargo-jump<ret>}

    set-option buffer readonly true
    set-option buffer cargo_workspace_root %sh{ dirname $(cargo locate-project --workspace --message-format plain) }

    add-highlighter buffer/cargo ref cargo
    add-highlighter buffer/ wrap -word
}

define-command -hidden cargo-open-error -params 4 %{
    evaluate-commands -try-client %opt{jumpclient} %{
        edit -existing "%arg{1}" "%arg{2}" "%arg{3}"
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
            "%opt{cargo_workspace_root}/%reg{2}" \
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

declare-user-mode cargo

map -docstring "Enter cargo mode" \
    global user c ':enter-user-mode cargo<ret>'
map -docstring "Run project" \
    global cargo r ':cargo run<ret>'
map -docstring "Run tests" \
	global cargo t %{:cargo test<ret>}
map -docstring "Check syntax" \
	global cargo c %{:cargo clippy<ret>}
map -docstring "Build documentation" \
	global cargo d %{:cargo doc<ret>}
map -docstring "Next error" \
	global cargo n %{:cargo-next-error<ret>}
map -docstring "Previous error" \
	global cargo p %{:cargo-previous-error<ret>}
map -docstring "Format" \
	global cargo f %{:sh cargo fmt --manifest-path $(cargo locate-project --message-format plain)<ret>}

map global cargo b ':b *cargo*<ret>' \
    -docstring "Open *cargo* buffer"

