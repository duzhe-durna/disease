-- copy-pasted from here: https://github.com/helix-editor/helix/blob/master/runtime/themes/rose_pine_dawn.toml
-- { <fg>, [bg], [attr] } or just <fg>
-- Color: "#RRGGBB" or 'MenuInfo = "Default"', exception: func = "function"
-- Attribute: "+..."
--- Palette ---
local default        = "default"
local base           = "#faf4ed"
local surface        = "#fffaf3"
local overlay        = "#f2e9e1"
local muted          = "#9893a5"
local subtle         = "#797593"
local text           = "#575279"
local love           = "#b4637a"
local love_10        = "#f6e4e0"
local gold           = "#ea9d34"
local gold_10        = "#fbead8"
local rose           = "#d7827e"
local rose_10        = "#fae8e1"
local pine           = "#286983"
local pine_10        = "#e5e6e2"
local foam           = "#56949f"
local foam_10        = "#eaeae5"
local iris           = "#907aa9"
local iris_10        = "#f1e8e6"
local highlight_low  = "#f4ede8"
local highlight_med  = "#dfdad9"
local highlight_high = "#cecacd"

return {
	Colorscheme_name       = "rose-pine-dawn",

	--- Builtins ---
    Default                = {text, base},
    InsertCursor           = {base, rose},
    PrimarySelection       = {default, highlight_med, "+g"},
    SecondarySelection     = {default, overlay, "+g"},
    PrimaryCursor          = {base, foam, "+g"},
    SecondaryCursor        = {text, highlight_high, "+g"},
    PrimaryCursorEol       = "PrimaryCursor",
    SecondaryCursorEol     = "SecondaryCursor",
    LineNumbers            = {muted, base},
    LineNumberCursor       = {text, base, "+b"},
    LineNumbersWrapped     = "LineNumbers",
    MenuForeground         = {text, surface, "+b"},
    MenuBackground         = {subtle, surface},
    MenuInfo               = {rose, surface},
    Information            = "MenuBackground",
    Error                  = {surface, love},
    StatusLine             = "Default",
    StatusLineMode         = {surface, rose, "+b"},
    StatusLineInfo         = "StatusLine",
    StatusLineValue        = "StatusLine",
    StatusCursor           = "PrimaryCursor",
    Prompt                 = {surface, foam},
    MatchingChar           = {rose, base},
    Whitespace             = {text, base},
    WrapMarker             = "Whitespace",
    BufferPadding          = base,

    --- Code ---
    value                  = iris,
    type                   = foam,
    variable               = text,
    module                 = iris,
    func                   = rose,
    string                 = gold,
    keyword                = pine,
    operator               = subtle,
    attribute              = iris,
    comment                = {muted, "+i"},
    documentation          = "comment",
    meta                   = rose,
    builtin                = {rose, "+b"},

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
