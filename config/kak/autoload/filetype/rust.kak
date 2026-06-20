# http://rust-lang.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](rust|rs) %{
    set-option buffer filetype rust
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=rust %<
    require-module rust
    hook window ModeChange pop:insert:.* -group rust-trim-indent c-family-trim-indent
    hook window InsertChar \n -group rust-indent c-family-indent-on-newline
    hook window InsertChar \{ -group rust-indent c-family-indent-on-opening-curly-brace
    hook window InsertChar [)}\]] -group rust-indent rust-indent-on-closing

    set buffer formatcmd 'rustfmt --edition 2024'

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window rust-.+ }
>

hook -group rust-highlight global WinSetOption filetype=rust %{
    add-highlighter window/rust ref rust
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/rust }
}

provide-module rust %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/rust regions
add-highlighter shared/rust/code default-region group
add-highlighter shared/rust/string           region %{(?<!')"} (?<!\\)(\\\\)*"              fill string
add-highlighter shared/rust/raw_string       region -match-capture %{(?<!')r(#*)"} %{"(#*)} fill string

add-highlighter shared/rust/line_doctest region ^\h*//[!/]\h*```($|should_panic|no_run|ignore|allow_fail|rust|test_harness|compile_fail|E\d{4}|edition201[58]) ^\h*//[!/]\h*```$ regions
add-highlighter shared/rust/line_doctest/marker region ``` $ group
add-highlighter shared/rust/line_doctest/marker/fence regex ``` 0:meta
add-highlighter shared/rust/line_doctest/marker/keywords regex [\d\w] 0:meta # already matched above, just ignore comma
add-highlighter shared/rust/line_doctest/inner region '^\h*//[!/]( #(?= ))?' '$| ' group
add-highlighter shared/rust/line_doctest/inner/comment regex //[!/] 0:documentation
add-highlighter shared/rust/line_doctest/inner/hidden regex '#' 0:meta
add-highlighter shared/rust/line_doctest/code default-region ref rust
add-highlighter shared/rust/line_code_rest   region ^\h*//[!/]\h*``` ^\h*//[!/]\h*```$      fill documentation # reset invalid doctest
add-highlighter shared/rust/line_comment2    region //[!/]{2} $                             fill comment
add-highlighter shared/rust/line_doc         region //[!/] $                                fill documentation
add-highlighter shared/rust/line_comment1    region // $                                    group
add-highlighter shared/rust/line_comment1/comment fill comment
add-highlighter shared/rust/line_comment1/todo regex (TODO|NOTE|FIXME): 1:meta

add-highlighter shared/rust/block_comment2   region -recurse /\*\*\* /\*\*\* \*/            fill comment
add-highlighter shared/rust/block_doc        region -recurse /\*\* /\*\* \*/ regions
add-highlighter shared/rust/block_doc/doctest region ```($|should_panic|no_run|ignore|allow_fail|rust|test_harness|compile_fail|E\d{4}|edition201[58]) ```$ regions
add-highlighter shared/rust/block_doc/doctest/marker region ``` $ group
add-highlighter shared/rust/block_doc/doctest/marker/fence regex ``` 0:meta
add-highlighter shared/rust/block_doc/doctest/marker/keywords regex [\d\w] 0:meta # already matched above, just ignore comma
add-highlighter shared/rust/block_doc/doctest/inner default-region group
add-highlighter shared/rust/block_doc/doctest/inner/hidden regex '^\h*\**\h*#' 0:meta
add-highlighter shared/rust/block_doc/doctest/inner/comment regex ^\h*\* 0:documentation
add-highlighter shared/rust/block_doc/doctest/inner/code ref rust
add-highlighter shared/rust/block_doc/code_rest region ``` ``` fill documentation
add-highlighter shared/rust/block_doc/doc    default-region fill documentation
add-highlighter shared/rust/block_comment1   region -recurse /\* /\* \*/ group
add-highlighter shared/rust/block_comment1/comment fill comment
add-highlighter shared/rust/block_comment1/todo regex (TODO|NOTE|FIXME): 1:meta

add-highlighter shared/rust/macro_attributes region -recurse "\[" "#!?\[" "\]" regions
add-highlighter shared/rust/macro_attributes/ default-region fill meta
add-highlighter shared/rust/macro_attributes/string region %{(?<!')"} (?<!\\)(\\\\)*" fill string
add-highlighter shared/rust/macro_attributes/raw_string region -match-capture %{(?<!')r(#*)"} %{"(#*)} fill string

add-highlighter shared/rust/code/operators_arithmetic   regex (\+|-|/|\*|=|\^|&|\||!|>|<|%)=? 0:operator
add-highlighter shared/rust/code/operators_as           regex \bas\b 0:operator
add-highlighter shared/rust/code/ref_ref                regex (&\h+[&~@*])[^)=\s\t\r\n] 1:type
add-highlighter shared/rust/code/ref                    regex ([&~@*])[^)=\s\t\r\n] 1:type
add-highlighter shared/rust/code/operators_logic        regex &&|\|\| 0:operator

add-highlighter shared/rust/code/lifetime_or_loop_label regex ('([a-zA-Z]\w+|_\w+))\b 1:meta
add-highlighter shared/rust/code/namespace              regex \b[a-zA-Z](\w+)?(\h+)?(?=::) 0:module
# add-highlighter shared/rust/code/mod_path_sep           regex :: 0:meta
add-highlighter shared/rust/code/question_mark          regex \? 0:meta
# the language keywords are defined here, but many of   them are reserved and unused yet:
# https://doc.rust-lang.org/reference/keywords.html
add-highlighter shared/rust/code/function_call          regex _?[a-zA-Z]\w*\s*(?=\() 0:function
add-highlighter shared/rust/code/generic_function_call  regex _?[a-zA-Z]\w*\s*(?=::<) 0:function
add-highlighter shared/rust/code/function_declaration   regex (?:fn\h+)(_?\w+)(?:<[^>]+?>)?\( 1:function
add-highlighter shared/rust/code/keywords               regex \b(?:as|break|continue|crate|else|enum|extern|false|fn|for|if|impl|in|let|loop|match|mod|pub|return|self|Self|struct|super|trait|true|type|union|unsafe|use|where|while|async|await|dyn|abstract|become|box|do|try)\b 0:keyword
add-highlighter shared/rust/code/storage                regex \b(move|mut|ref|static|const)\b 0:type
add-highlighter shared/rust/code/pub_with_scope         regex \b(pub)\h*(\()\h*(crate|super|self|in\h+[\w:]+)\h*(\)) 1:keyword 2:meta 4:meta
# after let can be an arbitrary pattern match
add-highlighter shared/rust/code/macro                  regex \b\w+! 0:meta
# the number literals syntax is defined here:
# https://doc.rust-lang.org/reference/tokens.html#numb  ers
add-highlighter shared/rust/code/values                 regex \b(?:self|true|false|[0-9][_0-9]*(?:\.[0-9][_0-9]*|(?:\.[0-9][_0-9]*)?E[\+\-][_0-9]+)(?:f(?:32|64))?|(?:0x[_0-9a-fA-F]+|0o[_0-7]+|0b[_01]+|[0-9][_0-9]*)(?:(?:i|u|f)(?:8|16|32|64|128|size))?)\b 0:value
add-highlighter shared/rust/code/char_character         regex "'([^\\]|\\(.|x[0-9a-fA-F]{2}|u\{[0-9a-fA-F]{1,6}\}))'" 0:value
# TODO highlight error for unicode or single escape by  te character
add-highlighter shared/rust/code/byte_character         regex b'([\x00-\x5B\x5D-\x7F]|\\(.|x[0-9a-fA-F]{2}))' 0:value
add-highlighter shared/rust/code/builtin_types          regex \b(?:u8|u16|u32|u64|u128|usize|i8|i16|i32|i64|i128|isize|f32|f64|bool|char|str|Self)\b 0:type

add-highlighter shared/rust/code/enum                   regex \b(Option|Result)\b 0:type
add-highlighter shared/rust/code/enum_variant           regex \b(Some|None|Ok|Err)\b 0:value
add-highlighter shared/rust/code/std_traits             regex \b(Copy|Send|Sized|Sync|Drop|Fn|FnMut|FnOnce|Box|ToOwned|Clone|PartialEq|PartialOrd|Eq|Ord|AsRef|AsMut|Into|From|Default|Iterator|Extend|IntoIterator|DoubleEndedIterator|ExactSizeIterator|SliceConcatExt|String|ToString|Vec)\b 0:type
 
# Commands
# ‾‾‾‾‾‾‾‾

# define-command -hidden rust-indent-on-opening-curly-brace %[
#     evaluate-commands -draft -itersel %~
#         # align indent with opening paren when { is entered on a new line after the closing paren
#         try %[ execute-keys -draft h <a-F> ) M <a-k> \A\(.*\)\h*\n\h*\{\z <ret> s \A|.\z <ret> 1<a-&> ]
#         # dedent standalone { after impl and related block without any { in between
#         try %@ execute-keys -draft hh <a-?> ^\h*\b(impl|((|pub\ |pub\((crate|self|super|in\ (::)?([a-zA-Z][a-zA-Z0-9_]*|_[a-zA-Z0-9_]+)(::[a-zA-Z][a-zA-Z0-9_]*|_[a-zA-Z0-9_]+)*)\)\ )((async\ |const\ )?(unsafe\ )?(extern\ ("[^"]*"\ )?)?fn|struct|enum|union))|if|for)\b <ret> <a-K> \{ <ret> <a-semicolon> <semicolon> ll x <a-k> ^\h*\{$ <ret> <a-lt> @
#     ~
# ]

define-command -hidden rust-indent-on-closing %~
    evaluate-commands -draft -itersel %_
        # align to opening curly brace or paren when alone on a line
        try %< execute-keys -draft <a-h> <a-k> ^\h*[)}\]]$ <ret> h m <a-S> 1<a-&> >
    _
~

§
