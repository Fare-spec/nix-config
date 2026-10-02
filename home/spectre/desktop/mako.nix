{ ... }:

{
  services.mako = {
    enable = true;

    settings = {
      anchor = "top-right";

      font = "0xProto Nerd Font 11";

      width = 360;
      height = 120;

      margin = 12;
      padding = 12;

      background-color = "#24273ae6";
      text-color = "#cad3f5";

      border-size = 0;
      border-radius = 12;

      icons = true;
      markup = true;
      actions = true;
      history = true;

      default-timeout = 5000;

      progress-color = "over #c6a0f6";
    };
  };
}
