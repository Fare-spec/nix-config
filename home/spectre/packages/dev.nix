{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python
    (python314.withPackages (
      ps: with ps; [
        numpy
        unrpa
      ]
    ))
    black
    uv
    pyright

    # C / C++ / low-level
    bc
    bison
    clang-tools
    cmake
    flex
    gcc
    gdb
    gnumake
    nasm
    pahole
    patchelf
    pkg-config

    # Rust
    bacon
    cargo
    cargo-flamegraph
    cargo-tauri
    rust-analyzer
    rustc
    hotspot

    # Other languages/toolchains
    lua
    nil

    # General development tools
    geckodriver
    pandoc
    shellcheck
  ];
}
