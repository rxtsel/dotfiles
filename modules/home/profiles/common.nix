{inputs, ...}: {
  flake.modules.homeManager.profileCommon = {
    imports = with inputs.self.modules.homeManager; [
      base
      zsh
      starship
      ssh
      zoxide
      macchina
      yazi
    ];
  };
}
