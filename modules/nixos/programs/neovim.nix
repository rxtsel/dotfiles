{inputs, ...}: {
  flake.modules.nixos.neovim = {
    imports = [inputs.neovim.nixosModules.default];
    programs.rxtsel-neovim.enable = true;
  };
}
