{ lib, pkgs, ... }:

let
  displayCycle = pkgs.writeShellApplication {
    name = "display-cycle";

    runtimeInputs = with pkgs; [
      hyprland
      jq
      libnotify
    ];

    text = ''
      laptop="eDP-1"
      external="DP-3"

      monitors="$(hyprctl -j monitors all)"

      # If the Samsung isn't connected, always fall back to the laptop.
      if ! jq -e --arg name "$external" \
        'any(.[]; .name == $name)' <<< "$monitors" >/dev/null; then

        hyprctl eval 'hl.monitor({
          output = "eDP-1",
          disabled = false,
          mode = "2256x1504@60",
          position = "0x0",
          scale = 1,
          mirror = ""
        })' >/dev/null

        notify-send "Displays" "Laptop only"
        exit 0
      fi

      laptop_disabled="$(
        jq -r --arg name "$laptop" \
          '.[] | select(.name == $name) | .disabled' <<< "$monitors"
      )"

      external_disabled="$(
        jq -r --arg name "$external" \
          '.[] | select(.name == $name) | .disabled' <<< "$monitors"
      )"

      external_mirror="$(
        jq -r --arg name "$external" \
          '.[] | select(.name == $name) | .mirrorOf' <<< "$monitors"
      )"

      if [[ "$laptop_disabled" == "true" && "$external_disabled" == "false" ]]; then
        current="external"
      elif [[ "$laptop_disabled" == "false" &&
              "$external_disabled" == "false" &&
              "$external_mirror" == "$laptop" ]]; then
        current="mirror"
      elif [[ "$laptop_disabled" == "false" &&
              "$external_disabled" == "false" ]]; then
        current="extend"
      else
        current="laptop"
      fi

      case "$current" in
        external)
          # MIRROR
          # 1920x1080 is supported by both displays.
          hyprctl eval 'hl.monitor({
            output = "eDP-1",
            disabled = false,
            mode = "1920x1080@60",
            position = "0x0",
            scale = 1,
            mirror = ""
          })' >/dev/null

          hyprctl eval 'hl.monitor({
            output = "DP-3",
            disabled = false,
            mode = "1920x1080@60",
            position = "0x0",
            scale = 1,
            mirror = "eDP-1"
          })' >/dev/null

          notify-send "Displays" "Mirror"
          ;;

        mirror)
          # EXTEND - laptop on the left, Samsung on the right.
          hyprctl eval 'hl.monitor({
            output = "eDP-1",
            disabled = false,
            mode = "2256x1504@60",
            position = "0x0",
            scale = 1,
            mirror = ""
          })' >/dev/null

          hyprctl eval 'hl.monitor({
            output = "DP-3",
            disabled = false,
            mode = "3840x2160@60",
            position = "2256x0",
            scale = 1,
            mirror = ""
          })' >/dev/null

          notify-send "Displays" "Extended"
          ;;

        extend)
          # LAPTOP ONLY
          hyprctl eval 'hl.monitor({
            output = "eDP-1",
            disabled = false,
            mode = "2256x1504@60",
            position = "0x0",
            scale = 1,
            mirror = ""
          })' >/dev/null

          hyprctl eval 'hl.monitor({
            output = "DP-3",
            disabled = true
          })' >/dev/null

          notify-send "Displays" "Laptop only"
          ;;

        *)
          # EXTERNAL ONLY
          # Enable the Samsung before disabling the laptop so we never
          # momentarily have zero active displays.
          hyprctl eval 'hl.monitor({
            output = "DP-3",
            disabled = false,
            mode = "3840x2160@60",
            position = "0x0",
            scale = 1,
            mirror = ""
          })' >/dev/null

          hyprctl eval 'hl.monitor({
            output = "eDP-1",
            disabled = true
          })' >/dev/null

          notify-send "Displays" "External only"
          ;;
      esac
    '';
  };
  lua = lib.generators.mkLuaInline;

  workspaceKeys = [
    {
      workspace = 1;
      keycode = 10;
    }
    {
      workspace = 2;
      keycode = 11;
    }
    {
      workspace = 3;
      keycode = 12;
    }
    {
      workspace = 4;
      keycode = 13;
    }
    {
      workspace = 5;
      keycode = 14;
    }
    {
      workspace = 6;
      keycode = 15;
    }
    {
      workspace = 7;
      keycode = 16;
    }
    {
      workspace = 8;
      keycode = 17;
    }
    {
      workspace = 9;
      keycode = 18;
    }
    {
      workspace = 10;
      keycode = 19;
    }
  ];

  workspaceBinds = lib.concatMap (
    { workspace, keycode }:
    [
      {
        _args = [
          (lua ''mainMod .. " + code:${toString keycode}"'')
          (lua "hl.dsp.focus({ workspace = ${toString workspace} })")
        ];
      }

      {
        _args = [
          (lua ''mainMod .. " + SHIFT + code:${toString keycode}"'')
          (lua "hl.dsp.window.move({ workspace = ${toString workspace} })")
        ];
      }
    ]
  ) workspaceKeys;
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    systemd.enable = false;

    package = null;
    portalPackage = null;

    settings = {
      terminal = {
        _var = "kitty";
      };

      fileManager = {
        _var = "thunar";
      };

      menu = {
        _var = "rofi -show drun";
      };

      mainMod = {
        _var = "SUPER";
      };

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      };

      config = {
        animations = {
          enabled = true;
        };
        general = {
          gaps_in = 5;
          gaps_out = 10;

          border_size = 0;

          layout = "dwindle";
        };

        decoration = {
          rounding = 12;

          active_opacity = 0.9;
          inactive_opacity = 0.86;

          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };
        };

        input = {
          kb_layout = "fr";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
            tap_to_click = true;
          };
        };
      };
      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 1.6;
          bezier = "default";
        }

        {
          leaf = "workspaces";
          enabled = true;
          speed = 1.6;
          bezier = "default";
          style = "slide";
        }

        {
          leaf = "fade";
          enabled = true;
          speed = 1.1;
          bezier = "default";
        }
      ];

      bind = [
        # SUPER + Enter -> terminal
        {
          _args = [
            (lua ''mainMod .. " + Return"'')
            (lua "hl.dsp.exec_cmd(terminal)")
          ];
        }

        # SUPER + D -> application launcher
        {
          _args = [
            (lua ''mainMod .. " + D"'')
            (lua "hl.dsp.exec_cmd(menu)")
          ];
        }

        # SUPER + E -> file manager
        {
          _args = [
            (lua ''mainMod .. " + E"'')
            (lua "hl.dsp.exec_cmd(fileManager)")
          ];
        }
        # SUPER + Q -> close active window
        {
          _args = [
            (lua ''mainMod .. " + Q"'')
            (lua "hl.dsp.window.close()")
          ];
        }

        # SUPER + F -> fullscreen
        {
          _args = [
            (lua ''mainMod .. " + F"'')
            (lua "hl.dsp.window.fullscreen()")
          ];
        }

        # SUPER + SHIFT + Space -> toggle floating
        {
          _args = [
            (lua ''mainMod .. " + SHIFT + Space"'')
            (lua ''hl.dsp.window.float({ action = "toggle" })'')
          ];
        }

        # Vim-style focus
        {
          _args = [
            (lua ''mainMod .. " + H"'')
            (lua ''hl.dsp.focus({ direction = "left" })'')
          ];
        }

        {
          _args = [
            (lua ''mainMod .. " + J"'')
            (lua ''hl.dsp.focus({ direction = "down" })'')
          ];
        }

        {
          _args = [
            (lua ''mainMod .. " + K"'')
            (lua ''hl.dsp.focus({ direction = "up" })'')
          ];
        }

        {
          _args = [
            (lua ''mainMod .. " + L"'')
            (lua ''hl.dsp.focus({ direction = "right" })'')
          ];
        }

        # SUPER + SHIFT + H/J/K/L -> move windows
        {
          _args = [
            (lua ''mainMod .. " + SHIFT + H"'')
            (lua ''hl.dsp.window.move({ direction = "left" })'')
          ];
        }

        {
          _args = [
            (lua ''mainMod .. " + SHIFT + J"'')
            (lua ''hl.dsp.window.move({ direction = "down" })'')
          ];
        }

        {
          _args = [
            (lua ''mainMod .. " + SHIFT + K"'')
            (lua ''hl.dsp.window.move({ direction = "up" })'')
          ];
        }

        {
          _args = [
            (lua ''mainMod .. " + SHIFT + L"'')
            (lua ''hl.dsp.window.move({ direction = "right" })'')
          ];
        }

        # ALT + F4 -> force-kill active window
        {
          _args = [
            "ALT + F4"
            (lua "hl.dsp.window.kill()")
          ];
        }
        # CTRL + SHIFT + Enter -> play / pause
        {
          _args = [
            "CTRL + SHIFT + Return"
            (lua ''hl.dsp.exec_cmd("playerctl play-pause")'')
          ];
        }

        # CTRL + * -> next track
        # Physical * key: wev 51 -> Hyprland code:59
        {
          _args = [
            "CTRL + code:59"
            (lua ''hl.dsp.exec_cmd("playerctl next")'')
          ];
        }

        # CTRL + SHIFT + * -> previous track
        {
          _args = [
            "CTRL + SHIFT + code:59"
            (lua ''hl.dsp.exec_cmd("playerctl previous")'')
          ];
        }

        # Volume up
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lua ''
              hl.dsp.exec_cmd(
                "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
              )
            '')
            (lua "{ locked = true, repeating = true }")
          ];
        }

        # Volume down
        {
          _args = [
            "XF86AudioLowerVolume"
            (lua ''
              hl.dsp.exec_cmd(
                "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              )
            '')
            (lua "{ locked = true, repeating = true }")
          ];
        }

        # Mute
        {
          _args = [
            "XF86AudioMute"
            (lua ''
              hl.dsp.exec_cmd(
                "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              )
            '')
            (lua "{ locked = true }")
          ];
        }
      ]
      ++ workspaceBinds
      ++ [
        # ALT + Tab -> cycle windows
        {
          _args = [
            "ALT + Tab"
            (lua ''
              function()
                hl.dispatch(hl.dsp.window.cycle_next())
                hl.dispatch(hl.dsp.window.bring_to_top())
              end
            '')
          ];
        }

        # ALT + ² -> previous workspace on this monitor
        {
          _args = [
            "ALT + code:57"
            (lua ''hl.dsp.focus({ workspace = "previous_per_monitor" })'')
          ];
        }
        # SUPER + S -> select region, save screenshot, copy to clipboard
        {
          _args = [
            (lua ''mainMod .. " + S"'')
            (lua ''
              hl.dsp.exec_cmd(
                'mkdir -p "$HOME/Pictures/Screenshots"; file="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"; grim -g "$(slurp)" - | tee "$file" | wl-copy --type image/png'
              )
            '')
          ];
        }

        # SUPER + SHIFT + S -> screenshot entire screen, save, copy to clipboard
        {
          _args = [
            (lua ''mainMod .. " + SHIFT + S"'')
            (lua ''
              hl.dsp.exec_cmd(
                'mkdir -p "$HOME/Pictures/Screenshots"; file="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"; grim - | tee "$file" | wl-copy --type image/png'
              )
            '')
          ];
        }

        # SUPER + left-drag -> move window
        {
          _args = [
            (lua ''mainMod .. " + mouse:272"'')
            (lua "hl.dsp.window.drag()")
            (lua "{ mouse = true }")
          ];
        }

        # SUPER + right-drag -> resize window
        {
          _args = [
            (lua ''mainMod .. " + mouse:273"'')
            (lua "hl.dsp.window.resize()")
            (lua "{ mouse = true }")
          ];
        }
        # SUPER + CTRL + L -> lock session
        {
          _args = [
            (lua ''" ALT + CTRL + L"'')
            (lua ''hl.dsp.exec_cmd("hyprlock-random")'')
          ];
        }
        # F8 -> brightness up
        {
          _args = [
            "F8"
            (lua ''
              hl.dsp.exec_cmd(
                "brightnessctl -d amdgpu_bl1 set 5%+"
              )
            '')
            (lua "{ locked = true, repeating = true }")
          ];
        }

        # F7 -> brightness down
        {
          _args = [
            "F7"
            (lua ''
              hl.dsp.exec_cmd(
                "brightnessctl -d amdgpu_bl1 set 5%-"
              )
            '')
            (lua "{ locked = true, repeating = true }")
          ];
        }
        # SUPER + V -> clipboard history
        {
          _args = [
            (lua ''mainMod .. " + V"'')
            (lua ''
              hl.dsp.exec_cmd(
                "cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"
              )
            '')
          ];
        }

        # SUPER + P -> cycle display modes
        {
          _args = [
            (lua ''mainMod .. " + P"'')
            (lua ''
              hl.dsp.exec_cmd("${displayCycle}/bin/display-cycle")
            '')
          ];
        }
      ];
    };
  };
}
