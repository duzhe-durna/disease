-- { <fg>, [bg], [attr] } or just <fg>
-- Color: "#RRGGBB" or 'MenuInfo = "Default"', exception: func = "function"
-- Attribute: "+..."
--- Palette ---
local default = "default"
local bg0     = "#fbf1c7"
local bg1     = "#ebdbb2"
local bg2     = "#d5c4a1"
local bg3     = "#bdae93"
local bg4     = "#a89984"
local fg0     = "#282828"
local fg1     = "#3c3836"
local fg2     = "#504945"
local fg3     = "#665c54"
local fg4     = "#7c6f64"
local gray0   = "#7c6f64"
local gray1   = "#928374"
local red0    = "#cc241d"
local red1    = "#9d0006"
local green0  = "#98971a"
local green1  = "#79740e"
local yellow0 = "#d79921"
local yellow1 = "#b57614"
local blue0   = "#458588"
local blue1   = "#076678"
local purple0 = "#b16286"
local purple1 = "#8f3f71"
local aqua0   = "#689d6a"
local aqua1   = "#427b58"
local orange0 = "#d65d0e"
local orange1 = "#af3a03"

return {
    Colorscheme_name       = "gruv-light",

    --- Builtins ---
    Default                = {fg1, bg0},
    PrimarySelection       = {default, bg1, "+g"},
    SecondarySelection     = {default, bg2, "+g"},
    PrimaryCursor          = {bg0, blue1, "+g"},
    InsertCursor           = {bg0, yellow0}, 
    PrimaryCursorEol       = {bg0, blue1, "+g"},
    SecondaryCursor        = {bg0, blue0, "+g"},
    SecondaryCursorEol     = {bg0, blue0, "+g"},
    LineNumbers            = {bg4, bg0},
    LineNumberCursor       = {yellow1, bg0, "+b"},
    LineNumbersWrapped     = "LineNumbers",
    MenuForeground         = {bg2, blue1, "+b"},
    MenuBackground         = {fg1, bg2},
    MenuInfo               = {aqua1, default},
    Information            = "MenuBackground",
    Error                  = {red1, default},
    StatusLine             = {fg1, bg0},
    StatusLineMode         = {bg0, blue0, "+b"},
    StatusLineInfo         = "StatusLine",
    StatusLineValue        = "StatusLine",
    StatusCursor           = "PrimaryCursor",
    Prompt                 = {fg1, orange0},
    MatchingChar           = {orange0, default},
    Whitespace             = "Default",
    WrapMarker             = "Whitespace",
    BufferPadding          = "LineNumbers",

    --- Code ---
    value                  = blue1,
    type                   = {yellow1},
    variable               = fg1,
    module                 = aqua1,
    func                   = green1,
    string                 = green1,
    keyword                = red1,
    operator               = fg1,
    attribute              = aqua1,
    comment                = {gray1, "+i"},
    documentation          = "comment",
    meta                   = red0,
    builtin                = fg1,

    --- LSP ---
    DiagnosticError        = red1,
    DiagnosticWarning      = orange1,
    DiagnosticHint         = blue1,
    DiagnosticInfo         = aqua1,
    LineFlagError          = "DiagnosticError",
    LineFlagWarning        = "DiagnosticWarning",
    LineFlagHint           = "DiagnosticHint",
    LineFlagInfo           = "DiagnosticInfo",
    InlayDiagnosticError   = "DiagnosticError",
    InlayDiagnosticWarning = "DiagnosticWarning",
    InlayDiagnosticHint    = "DiagnosticHint",
    InlayDiagnosticInfo    = "DiagnosticInfo",
    InlayCodeLens          = "DiagnosticInfo",
    InlayHint              = "DiagnosticHint",

    --- Markup ---
    title                  = {orange0, "+b"},
    header                 = aqua1,
    bold                   = aqua0,
    italic                 = aqua0,
    mono                   = fg4,
    block                  = aqua0,
    link                   = {green1, "+c"},
    bullet                 = orange0,
    list                   = fg0,
}
