source $"($nu.cache-dir)/carapace.nu"

$env.config.show_banner = false
$env.config.table.mode = 'compact'
$env.config.color_config.shape_garbage = { fg: red, attr: bu }
$env.config.color_config.search_result = { fg: black, bg: red }

$env.config.buffer_editor = 'kak'
alias k = kak

$env.config.keybindings ++= [
    {
        name: list_dir
        modifier: CONTROL
        keycode: Char_l
        mode: emacs
        event: {
            send: executehostcommand,
            cmd: "print ''; ls -a | sort-by type"
        }
    }
    {
        name: goto_edit
        modifier: CONTROL
        keycode: Char_g
        mode: emacs
        event: {
            send: executehostcommand,
            cmd: "goto"
        }
    }
]

