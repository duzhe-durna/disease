-- { <fg>, [bg], [attr] } or just <fg>
-- Color: "#RRGGBB" or 'MenuInfo = "Default"', exception: func = "function"
-- Attribute: "+..."
--- Palette ---
local default       = "default"
local seaFoam       = "#C7CCD1"
local fujiWhite     = "#DCD7BA"
local oldWhite      = "#C8C093"
local sumiInk0      = "#16161D"
local sumiInk1      = "#1F1F28"
local sumiInk2      = "#2A2A37"
local sumiInk3      = "#363646"
local sumiInk4      = "#54546D"
local waveBlue1     = "#223249"
local waveBlue2     = "#2D4F67"
local winterGreen   = "#2B3328"
local winterYellow  = "#49443C"
local winterRed     = "#43242B"
local winterBlue    = "#252535"
local autumnGreen   = "#76946A"
local autumnRed     = "#C34043"
local autumnYellow  = "#DCA561"
local samuraiRed    = "#E82424"
local roninYellow   = "#FF9E3B"
local waveAqua1     = "#6A9589"
local dragonBlue    = "#658594"
local fujiGray      = "#727169"
local springViolet1 = "#938AA9"
local oniViolet     = "#957FB8"
local crystalBlue   = "#7E9CD8"
local springViolet2 = "#9CABCA"
local springBlue    = "#7FB4CA"
local lightBlue     = "#A3D4D5"
local waveAqua2     = "#7AA89F"
local springGreen   = "#98BB6C"
local boatYellow1   = "#938056"
local boatYellow2   = "#C0A36E"
local carpYellow    = "#E6C384"
local sakuraPink    = "#D27E99"
local waveRed       = "#E46876"
local peachRed      = "#FF5D62"
local surimiOrange  = "#FFA066"
local katanaGray    = "#717C7C"

return {
    Colorscheme_name       = "kanagawa",

    --- Builtins ---
    Default                = {fujiWhite,sumiInk1},
    InsertCursor           = {sumiInk1, autumnGreen, "+b"},
    PrimarySelection       = {default,sumiInk3, "+g"},
    SecondarySelection     = {default,sumiInk2, "+g"},
    PrimaryCursor          = {sumiInk1,fujiWhite, "+g"},
    SecondaryCursor        = {sumiInk1,waveAqua1, "+g"},
    PrimaryCursorEol       = {sumiInk1,fujiWhite, "+g"},
    SecondaryCursorEol     = {sumiInk1,waveAqua2, "+g"},
    LineNumbers            = {sumiInk4,sumiInk1},
    LineNumberCursor       = {roninYellow,sumiInk1, "+b"},
    LineNumbersWrapped     = {sumiInk4,sumiInk1},
    MenuForeground         = {sumiInk0,oldWhite, "+b"},
    MenuBackground         = {oldWhite,sumiInk0},
    MenuInfo               = "MenuBackground",
    Information            = "MenuBackground",
    Error                  = {sumiInk0,waveRed},
    StatusLine             = "Default",
    StatusLineMode         = "Prompt",
    StatusLineInfo         = "StatusLine",
    StatusLineValue        = "StatusLine",
    StatusCursor           = "PrimaryCursor",
    Prompt                 = {sumiInk0,autumnGreen},
    MatchingChar           = {roninYellow,sumiInk1, "+b"},
    Whitespace             = {fujiWhite,sumiInk1, "+f"},
    WrapMarker             = "Whitespace",
    BufferPadding          = {sumiInk4,sumiInk1},

    --- Code ---
    value                  = carpYellow,
    type                   = waveAqua2,
    variable               = fujiWhite,
    module                 = surimiOrange,
    func                   = crystalBlue,
    string                 = springGreen,
    keyword                = {oniViolet, "+b"},
    operator               = springViolet2,
    attribute              = waveRed,
    comment                = {fujiGray, "+i"},
    documentation          = fujiGray,
    meta                   = peachRed,
    builtin                = {waveRed, "+b"},

    --- LSP ---
    DiagnosticError        = samuraiRed,
    DiagnosticWarning      = roninYellow,
    DiagnosticHint         = dragonBlue,
    DiagnosticInfo         = waveAqua1,
    LineFlagError          = samuraiRed,
    LineFlagWarning        = roninYellow,
    LineFlagHint           = dragonBlue,
    LineFlagInfo           = waveAqua1,
    InlayDiagnosticError   = samuraiRed,
    InlayDiagnosticWarning = roninYellow,
    InlayDiagnosticHint    = dragonBlue,
    InlayDiagnosticInfo    = waveAqua1,
    InlayCodeLens          = waveAqua1,
    InlayHint              = waveAqua1,

    --- Markup ---
    title                  = springViolet2,
    header                 = {surimiOrange, "+b"},
    bold                   = {fujiWhite, "+b"},
    italic                 = {fujiWhite, "+i"},
    mono                   = fujiWhite,
    block                  = fujiWhite,
    link                   = {springBlue, "+c"},
    bullet                 = springViolet1,
    list                   = sakuraPink,
}
