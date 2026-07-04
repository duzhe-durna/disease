#!/usr/bin/env sh

set -xe

app_dir="$HOME/Apps"

main() {
    mkdir "$app_dir" || whatever
    install_wm
    install_if_not_installed rustup install_rust
    install_if_not_installed kak install_kak
    ./spread.rs
}

install_if_not_installed() {
    if ! command -v "$1" 2>&1; then
        "$2"
    fi
}

install_rust() {
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
}

install_kakoune() {
    (
        cd "$app_dir"
        git clone --depth 1 https://github.com/mawww/kakoune || exit
        cd kakoune
        sudo make install
    )
}

install_wm() {
    sudo dnf install sway waybar alacritty
}

whatever() {
    true
}

main
