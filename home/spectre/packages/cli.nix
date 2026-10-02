{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Archives / files
    _7zz
    file
    unzip
    xz
    zip

    # General CLI
    age
    bingrep
    btop
    dua
    dust
    ent
    fclones
    fd
    gping
    grex
    hexyl
    hyperfine
    just
    miniserve
    ncurses
    pastel
    presenterm
    procs
    qsv
    ripgrep
    skim
    stress
    tldr
    toipe
    tokei
    tree
    vim
    viu
    xan
    xh

    # Inspection / data
    binwalk
    exiftool
    imagemagick
    inxi
    jq
    qpdf

    # Network/download basics
    curl
    wget
    openssl

    # Nix tooling
    hydra-check
    nh
    nixfmt
    nvd

    # Backup
    restic

    # Document/image tools
    ghostscript
  ];
}
