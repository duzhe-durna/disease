provide-module matching %{

def surround-selection-on-key %( on-key %( eval %sh(
    cargo -Zscript "$kak_runtime/autoload/matching/surround-selection" "$kak_key"
) ) )

def remove-matching-forward %(exec -save-regs '^"' 'mm;Zm;dzd')
def remove-matching-backward %(exec -save-regs '^"' '<a-m><a-m>;Zm;dzd')

def surround-replace-selection-on-key %(
    on-key %(
        eval %sh(cargo -Zscript "$kak_runtime/autoload/matching/surround-selection" "$kak_key")
        eval -draft %(remove-matching-forward)
    ) 
)

}
