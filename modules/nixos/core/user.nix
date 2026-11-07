{inputs, ...}: {
  flake.modules.nixos.coreUser = {config, ...}: {
    imports = [inputs.self.modules.nixos.zsh];

    users.users.${config.preferences.user.name} = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };
}
