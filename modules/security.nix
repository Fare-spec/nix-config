{ ... }:

{
  programs.firejail.enable = true;
  security.apparmor = {
    enable = true;

    policies.firefox = {
      state = "enforce";
      path = ./apparmor/firefox;
    };
  };
}
