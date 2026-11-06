{inputs, ...}: {
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts = {
      fontconfig.enable = true;

      packages = with pkgs; [
        noto-fonts-color-emoji
        nerd-fonts.symbols-only
        twemoji-color-font
        font-awesome
        powerline-fonts
        powerline-symbols

        (inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro.overrideAttrs (oldAttrs: {
          # Recent Apple images extract directly to a cpio Payload~.
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.cpio];
          unpackPhase = ''
            runHook preUnpack
            7z x "$src"
            if [ ! -f 'Payload~' ]; then
              7z x './*/SF Pro Fonts.pkg'
            fi
            cpio -idm --no-absolute-filenames < 'Payload~'
            runHook postUnpack
          '';
        }))
        inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono
        inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.ny
      ];

      fontconfig.defaultFonts = {
        sansSerif = [
          "SF Pro Display"
          "SF Pro Text"
          "SF Pro"
        ];

        serif = [
          "New York"
          "New York Large"
          "New York Small"
        ];

        monospace = [
          "SF Mono"
        ];
      };
    };
  };
}
