provide-module matching %{

def remove-matching-forward %(exec -draft %(mm;Zm;dzd))
def remove-matching-backward %(exec -draft %(<a-m><a-m>;Zm;dzd))

def delete-surrounding %(on-key %(exec "<a-a>%val(key)i<del><esc>a<backspace><esc>"))

def surround-selection %{on-key %{eval -draft %sh{
        o=
        c=
        case "$kak_key" in
        '<esc>'        ) exit               ;;
        '(' | ')'      ) o='('   ; c=')'    ;;
        '{' | '}'      ) o="{"   ; c="}"    ;;
        '[' | ']'      ) o='['   ; c=']'    ;;
        '<lt>' | '<gt>') o='<lt>'; c='<gt>' ;;
                      *) o="$kak_key"  ; c="$kak_key"   ;;
        esac
        printf %s "exec 'i$o<esc>a$c'"
}}}


}
