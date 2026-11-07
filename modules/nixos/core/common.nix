{...}: {
  flake.modules.nixos.coreCommon = {
    time.timeZone = "America/Bogota";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "dvorak";
    };

    services.libinput.enable = true;

    environment.variables.EDITOR = "nvim";

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
