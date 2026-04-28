#!/usr/bin/env nu

def main [cmd: string, --name: string = '*fifo*']: nothing -> path {
    let output = mktemp --dry kak-fifo
    $output
    mkfifo $output 
    let cmd = $"\(($cmd)) | to text"
    sh -c $"nu -c '($cmd)' > ($output) 2>&1 &"
    $output
}
