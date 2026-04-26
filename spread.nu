$env.config.table.mode = 'compact'

def setup_link_paths [src_dir: path target_dir: path]: nothing -> list<record<src: path, target: path>> {
    ls -a $src_dir
    | get name 
    | each { |entry| {
        src: ($entry | path expand) 
        target: ( $target_dir | path expand | path join ($entry | path basename) )
    } } 
}

(
    (setup_link_paths ./home ~/) 
    ++ (setup_link_paths ./config ~/.config)
    ++ ( mkdir ~/.local/bin ; setup_link_paths ./bin ~/.local/bin)
)
| each { echo $in }
| each { ln -s $in.src $in.target }

