declare-option -hidden str walkdir %sh{echo $PWD}
declare-option -hidden str walkdir_directory_regex "^d\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)"
declare-option -hidden str walkdir_non_directory_regex "^[^d|^total]\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)"
declare-option -hidden str walkdir_link_regex "^l\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+[^>]+-> ([^\n]+)"
declare-option -hidden str walkdir_link_regex_hglt "^l\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)" 
declare-option -hidden str walkdir_exe_regex "^-\S+x\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+([^\n]+)"

def walk \
-docstring "Open the file browser buffer in the provided directory or edit the provided file." \
-override \
-params ..1 \
%{ evaluate-commands -save-regs '"' %sh{
    walkdir=$(eval echo "$1")
    if [ -z "$walkdir" ]; then
        walkdir="$kak_opt_walkdir"
        if [ -z "$walkdir" ]; then
            walkdir=$PWD
        fi
    elif [[ "$walkdir" != /* && "$walkdir" != .* ]] \
        || [[ ! -f "$walkdir" && ! -d "$walkdir" ]]; then
            walkdir="$kak_opt_walkdir/$walkdir"
    fi
    walkdir=$(realpath "$walkdir")
    if [ -f "$walkdir" ]; then
        printf "edit -existing $walkdir"
        exit
    elif ! [ -d "$walkdir" ]; then
        printf "fail Argument must be a valid directory or file: $walkdir"
        exit
    fi
    list=$(ls -ahl "$walkdir")
    if [ $? -ne 0 ]; then
        printf "fail ls command failed: 'walkdir' = $walkdir"
        exit
    fi
    printf "
            set-option global walkdir '$walkdir';
            set-register dquote '$walkdir\n\n$list';
            try %%{ delete-buffer *walk* }
            edit -scratch *walk*;
            exec Pggjjjgl;
            set-option buffer readonly true;
            set-option buffer filetype walk"
} }
complete-command walk shell-script-candidates %{ls -Ah "$kak_opt_walkdir"}

def walk-cdhere \
-docstring 'Set PWD to the current *walk* file browser directory' \
-override \
%{
    test-if-in-walk-buffer
    cd %opt{walkdir}
    echo -markup "{Information}PWD: %sh{echo $PWD}"
}

def walk-or-edit \
-override \
-hidden \
%{ evaluate-commands -save-regs 'a' %{
    set-register a %val{selection_desc}
    try %{
        execute-keys "xs%opt{walkdir_link_regex}<ret>"
        walk "%reg{1}"
    } catch %{
        # echo -debug "WALK ERR: %val{error}"
        execute-keys "xs%opt{walkdir_non_directory_regex}<ret>"
        walk "%opt{walkdir}/%reg{1}"
    } catch %{
        # echo -debug "WALK ERR: %val{error}"
        execute-keys "xs%opt{walkdir_directory_regex}<ret>"
        walk "%opt{walkdir}/%reg{1}"
    } catch %{
        # echo -debug "WALK ERR: %val{error}"
        select %reg{a}
    }
} }

def test-if-in-walk-buffer \
-override \
%{ eval %sh{
    if [[ "$kak_bufname" != "*walk*" ]]; then
        printf "fail NOT IN THE *walk* BUFFER"
    else
        printf "nop"
    fi
} }

hook -group walk-hooks global WinSetOption filetype=walk %{
    add-highlighter window/walk group
    add-highlighter window/walk/current_dir regex "(^/\S+)" 1:red 
    add-highlighter window/walk/directory regex "%opt{walkdir_directory_regex}" 1:green
    add-highlighter window/walk/link regex "%opt{walkdir_link_regex_hglt}" 1:yellow
    add-highlighter window/walk/exe regex "%opt{walkdir_exe_regex}" 1:magenta
    map buffer normal <ret> :walk-or-edit<ret>
    map buffer goto b '<esc>:walk "%opt{walkdir}/.."<ret>'
    hook -group walk-mouse-cd buffer NormalKey <mouse:release:left.* %{ walk-or-edit }
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks global walk-highlight
        remove-hooks buffer walk-mouse-cd
        remove-highlighter window/walk
    }
}

