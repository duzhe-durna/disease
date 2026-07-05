decl -hidden str walkdir %sh(echo $PWD)
decl -hidden str walkdir_directory_regex "^d\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)"
decl -hidden str walkdir_non_directory_regex "^[^d|^total]\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)"
decl -hidden str walkdir_link_regex "^l\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(.+) -> [^\n]+"
decl -hidden str walkdir_exe_regex "^-\S+x\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)"
decl -hidden str walkdir_link_regex_hglt "^l\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)" 

def walk -file-completion -params ..1 -docstring %(
    walk [path]: Open the file browser buffer in the provided directory or edit the provided file.
) %( eval -save-regs \"p %(
    try  %(edit -existing %arg(1)) catch %(
        reg p %sh(
            if [ -z "$1" ]; then
                printf %s "$PWD"
            else
                expanded=$(eval echo "$1")
                printf %s "$expanded"
            fi
        )

        eval %sh([ ! -d "$kak_reg_p" ] && printf %s "fail %(neither a dir nor a file: $1)")

        try %(delete-buffer *walk*)
        edit -scratch *walk*

        reg dquote %sh(cd "$kak_reg_p" && printf %s\\n "$PWD" "$(ls -alh)")

        exec Pggjjgl

        set global walkdir %reg(p)
        set buffer filetype walk
        set buffer readonly true
    )
) )

def walk-cdhere -docstring 'Set PWD to the current *walk* file browser directory' %(
    eval -draft %(
        try %(buffer *walk*) catch %(fail *walk* buffer is closed)
        cd %opt(walkdir)
        echo -markup "{Information}PWD: %sh{echo $PWD}"
    )
)

def walk-sh -params 1.. -shell-script-candidates %(ls -A "$kak_opt_walkdir") -docstring %(
    walk-sh <shell-command>: run shell command in the ctx of the current *walk* buffer
) %( eval -save-regs oc %(
    reg o %sh(cd "$kak_opt_walkdir" && $@)
    walk %opt(walkdir)
    echo %exp(Done: %arg(@))
    info %reg(o)
))

def walk-or-edit -hidden %( eval -save-regs pl %(
    eval %sh([ "$kak_bufname" != "*walk*" ] && printf "fail not in the *walk* buffer")
    walk-select-entry
    walk "%opt(walkdir)/%reg(1)"
) )

def walk-copy-path %(
    walk-select-entry
    reg dquote "%opt(walkdir)/%reg(1)"
)

# entry saved into %reg(1) by the regex capture group
def -hidden walk-select-entry %(
    try %(
        exec "xs%opt(walkdir_link_regex)<ret>"
    ) catch %(
        exec "xs%opt(walkdir_non_directory_regex)<ret>"
    ) catch %(
        exec "xs%opt(walkdir_directory_regex)<ret>"
    )
)


hook -group walk-hooks global WinSetOption filetype=walk %(
    add-highlighter window/walk group
    add-highlighter window/walk/current_dir regex "(^/\S+)" 1:red 
    add-highlighter window/walk/directory regex "%opt{walkdir_directory_regex}" 1:green
    add-highlighter window/walk/link regex "%opt{walkdir_link_regex_hglt}" 1:yellow
    add-highlighter window/walk/exe regex "%opt{walkdir_exe_regex}" 1:magenta

    map buffer normal <ret> :walk-or-edit<ret>
    map buffer goto b <esc>ggjjj:walk-or-edit<ret> -docstring 'walk up the parent directory'

    hook -group walk-mouse-cd buffer NormalKey <mouse:release:left.* %(walk-or-edit)

    hook -once -always window WinSetOption filetype=.* %(
        remove-hooks global walk-highlight
        remove-hooks buffer walk-mouse-cd
        remove-highlighter window/walk
    )
)
