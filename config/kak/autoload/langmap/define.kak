provide-module langmap %{

decl -hidden str current_langmap 'en'
def switch-langmap -params 1 %{ eval %sh{
    cargo -Zscript "$kak_runtime/autoload/langmap/switch-langmap" "$kak_opt_current_langmap" "$1"
} }

}
