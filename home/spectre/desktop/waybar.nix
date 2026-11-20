{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 6;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "group/clock-dnd"
        ];

        "group/clock-dnd" = {
          orientation = "horizontal";
          modules = [ "clock" "custom/dnd" ];
        };

        modules-right = [
          "pulseaudio"
          "network"
          "backlight"
          "battery"
          "power-profiles-daemon"
          "tray"
        ];
        "custom/dnd" = {
          exec = ''
            if ${pkgs.mako}/bin/makoctl mode | ${pkgs.gnugrep}/bin/grep -qx do-not-disturb; then
              echo ""
            else
              echo ""
            fi
          '';
          interval = 2;
          format = "{text}";
          align = 0.5;
          hide-empty-text = true;
          tooltip-format = "Do Not Disturb enabled — click to disable";
          on-click = "${pkgs.mako}/bin/makoctl mode -r do-not-disturb";
        };

        "hyprland/workspaces" = {
          format = "{name}";
          disable-scroll = true;
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%A, %d %B %Y}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰤭";
          tooltip-format = "{ifname}\n{ipaddr}";
        };

        backlight = {
          device = "amdgpu_bl1";
          format = "󰃠 {percent}%";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
            very_critical = 5;
            cooked = 2;
            events = {
              on-discharging-warning = "${pkgs.libnotify}/bin/notify-send -u normal 'Low battery' 'Battery is at or below 30%.'";
              on-discharging-critical = "${pkgs.libnotify}/bin/notify-send -u critical 'Battery critical' 'Battery is at or below 15%.'";
              on-discharging-very_critical = "${pkgs.libnotify}/bin/notify-send -u critical 'Battery critical' 'Battery is at or below 5%.'";
              on-discharging-cooked = "${pkgs.libnotify}/bin/notify-send -u critical 'Battery critical' 'Battery is at or below 5%.'";
            };
          };

          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";

          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        "power-profiles-daemon" = {
          format = "{icon}";

          format-icons = {
            performance = "󰓅";
            balanced = "󰾅";
            "power-saver" = "󰌪";
          };
        };

        tray = {
          spacing = 8;
          icon-size = 18;
        };
      };
    };

    style = ''
      * {
        font-family: "0xProto Nerd Font";
        font-size: 13px;
        min-height: 0;
        border: none;
      }

      window#waybar {
        background: rgba(36, 39, 58, 0.92);
        color: #cad3f5;
      }

      #workspaces {
        margin: 4px 6px;
      }

      #workspaces button {
        padding: 0 8px;
        margin: 2px;
        border-radius: 8px;
        color: #a5adcb;
        background: transparent;
      }

      #workspaces button.active {
        color: #24273a;
        background: #c6a0f6;
      }

      #workspaces button.urgent {
        background: #ed8796;
        color: #24273a;
      }

      #clock-dnd {
        padding: 0 14px;
        margin: 4px 0;
        border-radius: 10px;
        background: #363a4f;
      }

      #clock {
        padding: 0;
        margin: 0;
        background: transparent;
        color: #c6a0f6;
        font-weight: bold;
      }

      #pulseaudio,
      #network,
      #backlight,
      #battery,
      #power-profiles-daemon,
      #tray {
        padding: 0 9px;
        margin: 4px 2px;
        border-radius: 9px;
        background: #363a4f;
      }

      #battery.warning {
        color: #eed49f;
      }

      #battery.critical {
        color: #ed8796;
      }

      #network.disconnected {
        color: #ed8796;
      }

      #custom-dnd {
        font-family: "0xProto Nerd Font Propo";
        font-size: 13px;
        font-weight: normal;
        min-width: 20px;
        color: #eed49f;
        background: transparent;
        padding: 0;
        margin: 0 0 0 6px;
      }
    '';
  };
}
