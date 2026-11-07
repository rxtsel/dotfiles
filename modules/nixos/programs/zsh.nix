{inputs, ...}: {
  flake.modules.nixos.zsh = {
    config,
    pkgs,
    ...
  }: {
    programs.zsh = {
      enable = true;
      # Home Manager initializes completion for the user.
      enableCompletion = false;
    };
    environment.pathsToLink = ["/share/zsh"];
    users.users.${config.preferences.user.name}.shell = pkgs.zsh;
  };

  perSystem = {pkgs, ...}: {
    checks.zsh = let
      hosts = builtins.attrValues inputs.self.nixosConfigurations;
      checkHost = host: let
        c = host.config;
        h = c.home-manager.users.${c.preferences.user.name};
      in
        assert c.programs.zsh.enable;
        assert c.users.users.${c.preferences.user.name}.shell == host.pkgs.zsh;
        assert !c.programs.fish.enable && !h.programs.fzf.enable;
        assert h.programs.zsh.defaultKeymap == "viins";
        assert h.programs.zsh.enableCompletion;
        assert h.programs.zsh.autosuggestion.enable;
        assert h.programs.zsh.syntaxHighlighting.enable;
        assert builtins.any (plugin: plugin.name == "sudo") h.programs.zsh.plugins;
        assert c.programs.direnv.enableZshIntegration;
        assert h.programs.starship.enableZshIntegration;
        assert h.programs.zoxide.enableZshIntegration;
        assert h.programs.yazi.enableZshIntegration;
          pkgs.writeText "${c.networking.hostName}-zshrc" h.programs.zsh.initContent;
    in
      pkgs.runCommand "zsh-config-check" {} ''
        for rc in ${pkgs.lib.escapeShellArgs (map checkHost hosts)}; do
          ${pkgs.zsh}/bin/zsh -n "$rc"
        done
        touch "$out"
      '';
  };
}
