{ ... }:

{
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.cargo/bin"
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    autocd = true;
    setOptions = [
      "NO_BEEP"
    ];
    history = {
      size = 100000;
      save = 100000;

      ignoreDups = true;
      ignoreSpace = true;
      share = true;

      expireDuplicatesFirst = true;
      saveNoDups = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "gallois";

      plugins = [
        "git"
        "sudo"
      ];
    };
    shellAliases = {
      nbuild = "sudo nixos-rebuild build --flake ~/nix#framework";
      ndiff = "nix store diff-closures /run/current-system ~/nix/result";
      nswitch = "sudo nixos-rebuild switch --flake ~/nix#framework";
      nupdate = "cd ~/nix && nix flake update";
    };
    siteFunctions = {
      ssm = ''
        local host

        host="$(
          awk '/^Host / {
            for (i = 2; i <= NF; i++)
              if ($i != "*")
                print $i
          }' "$HOME/.ssh/config" 2>/dev/null | fzf
        )"

        [ -n "$host" ] && ssh "$host"
      '';
      kb = ''
        if [[ ! "$1" =~ ^([0-9]|[1-9][0-9]|100)$ ]]; then
          echo "Usage: kb <0-100>"
          return 1
        fi

        sudo framework_tool --kblight "$1"
      '';

      key = ''
        watch -n 1 \
          'awk "/Dirty:|Writeback:/ {
            printf \"%-12s %8.1f MiB  %6.3f GiB\n\", \$1, \$2/1024, \$2/1024/1024
          }" /proc/meminfo'
      '';

      run = ''
        gcc "$1" && ./a.out && rm -f ./a.out
      '';

      asm = ''
        nasm -f elf64 "$1.asm" -o "$1.o" &&
        ld "$1.o" -o "$1"
      '';

      # Specific bluetooth workaround for small sound quality changes when microphone if used.
      rb = ''
        local device="AC:80:0A:42:8F:3F"

        pactl set-default-source \
          alsa_input.pci-0000_c1_00.6.analog-stereo || return 1

        wpctl settings --save \
          bluetooth.autoswitch-to-headset-profile false || return 1

        bluetoothctl disconnect "$device"
        sleep 1
        bluetoothctl connect "$device"
      '';

      npreview = ''

        local config="$HOME/nix"

        cd "$config" || return 1

        echo "== Updating flake inputs =="
        nix flake update || return 1

        echo
        echo "== Lock file changes =="
        git diff -- flake.lock

        echo
        echo "== Building new system =="
        sudo nixos-rebuild build --flake .#framework || return 1

        echo
        echo "== System changes =="
        nix store diff-closures /run/current-system ./result

      '';

    };

  };
}
