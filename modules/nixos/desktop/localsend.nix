{...}: {
  flake.modules.nixos.localsend = {pkgs, ...}: {
    programs.localsend.enable = true;
    programs.localsend.package = pkgs.localsend;
    programs.localsend.openFirewall = true;
  };
}
