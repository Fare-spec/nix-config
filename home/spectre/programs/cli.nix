{ ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.fastfetch.enable = true;

  programs.gitui.enable = true;
  programs.lazygit.enable = true;

  programs.lsd.enable = true;

  programs.tmux.enable = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
