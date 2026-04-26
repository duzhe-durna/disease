$env.config.table.mode = 'compact'

def path_from [...path_components: string]: nothing -> path {
    [...$path_components] | path join | path expand
}

def setup_link_paths [src_dir: path target_dir: path]: nothing -> list<record<src: path, target: path>> {
    ls -a $src_dir
    | get name 
    | each { {
        src: ($in | path expand) 
        target: (path_from $target_dir $in)
    } } 
}

(setup_link_paths ./home $env.HOME) ++ (setup_link_paths ./config (path_from $env.HOME .config))
    | each { echo $in }
    | each { ln -s $in.src $in.target }

