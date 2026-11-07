{
  flake.modules.homeManager.zsh = {pkgs, ...}: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      plugins = [
        {
          name = "sudo";
          src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/sudo";
        }
      ];

      initContent = ''
        # Only for an interactive login shell on TTY1.
        if [[ -o login && "$(tty)" == /dev/tty1 ]]; then
          exec niri-session
        fi
      '';

      shellAliases = {
        ls = "eza --group-directories-first --icons";
        la = "eza -a --group-directories-first --icons";
        ll = "eza -l --group-directories-first --icons";
        lla = "eza -la --group-directories-first --icons";
        lz = "lazygit";
        cd = "z";
        nixrs = "sudo nixos-rebuild switch --flake ~/dotfiles/#$(hostnamectl --static)";
        nixgc = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
        nixboot = "sudo bootctl cleanup";
        nixcleanall = "sudo nix-collect-garbage -d && nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      };
    };
  };
}
