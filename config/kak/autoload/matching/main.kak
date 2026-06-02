provide-module matching %{

def surround-selection-on-key %{ on-key %{ eval %sh{
    cargo -Zscript "$kak_runtime/autoload/matching/surround-selection" "$kak_key"
} } }

}
