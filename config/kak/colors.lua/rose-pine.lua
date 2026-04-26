-- { <fg>, [bg], [attr] } or just <fg>
-- Color: "#RRGGBB" or 'MenuInfo = "Default"', exception: func = "function"
-- Attribute: "+..."
--- Palette ---
local default        = "default"
local base           = "#191724"
local surface        = "#1f1d2e"
local overlay        = "#26233a"
local muted          = "#6e6a86"
local subtle         = "#908caa"
local text           = "#e0def4"
local love           = "#eb6f92"
local love_10        = "#311f30"
local gold           = "#f6c177"
local gold_10        = "#30282c"
local rose           = "#ebbcba"
local rose_10        = "#2f2834"
local pine           = "#31748f"
local pine_10        = "#1a2030"
local foam           = "#9ccfd8"
local foam_10        = "#252937"
local iris           = "#c4a7e7"
local iris_10        = "#2b2539"
local highlight_low  = "#21202e"
local highlight_med  = "#403d52"
local highlight_high = "#524f67"


return {
    Colorscheme_name       = "rose-pine",

    --- Builtins ---
    Default                = {text,base},
    InsertCursor           = {base, rose, "+b"},
    PrimarySelection       = {default,overlay, "+g"},
    SecondarySelection     = {default, highlight_med, "+g"},
    PrimaryCursor          = {text,muted, "+g"},
    SecondaryCursor        = {text,highlight_high, "+g"},
    PrimaryCursorEol       = {text,muted},
    SecondaryCursorEol     = {text,highlight_high, "+g"},
    LineNumbers            = {muted,base},
    LineNumberCursor       = {text,base, "+b"},
    LineNumbersWrapped     = "LineNumbers",
    MenuForeground         = {text,surface, "+b"},
    MenuBackground         = {subtle,surface},
    MenuInfo               = {rose,surface},
    Information            = "MenuBackground",
    Error                  = {surface,love},
    StatusLine             = {subtle, base},
    StatusLineMode         = {surface,rose, "+b"},
    StatusLineInfo         = "StatusLine",
    StatusLineValue        = "StatusLine",
    StatusCursor           = "PrimaryCursor",
    Prompt                 = {surface,foam},
    MatchingChar           = {text,highlight_med},
    Whitespace             = {text,base},
    WrapMarker             = "Whitespace",
    BufferPadding          = base,

    --- Code ---
    value                  = love,
    type                   = foam,
    variable               = text,
    module                 = iris,
    func                   = rose,
    string                 = gold,
    keyword                = pine,
    attribute              = iris,
    comment                = {muted, "+i"},
    operator               = subtle,
    documentation          = "comment",
    meta                   = foam,
    builtin                = love,

    --- LSP ---
    DiagnosticError        = love,
    DiagnosticWarning      = gold,
    DiagnosticHint         = iris,
    DiagnosticInfo         = foam,
    LineFlagError          = love,
    LineFlagWarning        = gold,
    LineFlagHint           = iris,
    LineFlagInfo           = foam,
    InlayDiagnosticError   = love,
    InlayDiagnosticWarning = gold,
    InlayDiagnosticHint    = iris,
    InlayDiagnosticInfo    = foam,
    InlayCodeLens          = foam,
    InlayHint              = iris,

    --- Markup ---
    title                  = {rose, "+b"},
    header                 = rose,
    bold                   = rose,
    italic                 = rose,
    mono                   = rose,
    block                  = pine,
    link                   = {love, "+c"},
    bullet                 = rose,
    list                   = rose,
}



