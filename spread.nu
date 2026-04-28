def setup_link_paths [src_dir: path target_dir: path]: nothing -> list<record<src: path, target: path>> {
    ls -a $src_dir
    | get name 
    | each { |entry| {
        src: ($entry | path expand) 
        target: ( $target_dir | path expand | path join ($entry | path basename) )
    } } 
}

$env.config.table.mode = 'compact'

const self_path = (path self | path dirname)
cd $self_path

let local_bin = [ $env.HOME .local bin ] | path join
print $'Creating ($local_bin)'
mkdir -v $local_bin

(
       (setup_link_paths ./home ~/) 
    ++ (setup_link_paths ./config ~/.config)
    ++ (setup_link_paths ./bin ~/.local/bin)
)
| each {
    print $in
    print $'Trying to remove existing ($in.target)'
    rm -rv $in.target
    print 'Creating symlink'
    ln -s $in.src $in.target  
} 
| ignore

