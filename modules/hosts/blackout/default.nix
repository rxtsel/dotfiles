{inputs, ...}: {
  flake.nixosConfigurations.blackout = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [
      blackoutHardware
      coreOptions
      coreCommon
      network
      audio
      coreUser
      coreBasePackages
      nix
      homeManager
      fonts
      bluetooth
      fcitx5
      neovim
      niri
      cursorTheme
      clockify
      yaak
      pearDesktop
      tailscale
      obsidian
      brave
      beekeeper-studio
      gpg
      localsend
      android
      virtualization
      (
        {config, ...}: let
          user = config.preferences.user.name;
        in {
          networking.hostName = "blackout";

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.kernel.sysctl." vm.swappiness" = 10;

          nixpkgs.config.allowUnfree = true;

          # Uncomment and set the user information for overriding the defaults
          # preferences.user = {};

          my.desktop = {
            terminal = "wezterm";
            autostartApps = [
              "noctalia"
              "discord"
              "thunderbird"
            ];
          };

          my.host = {
            role = "desktop";
            features.ddcci = true;
            monitors = [
              {
                name = "DP-2";
                width = 2560;
                height = 1440;
                refresh = 144;
                primary = false;
              }
              {
                name = "DP-1";
                width = 2560;
                height = 1440;
                refresh = 144;
                primary = true;
              }
            ];
          };

          home-manager.users.${user} = {
            imports = with inputs.self.modules.homeManager; [
              profileCommon
              profileDev
              profileGui
              fifineAudio
            ];

            home.username = user;
            home.homeDirectory = "/home/${user}";
          };

          system.stateVersion = "25.11";
        }
      )
    ];
  };
}
