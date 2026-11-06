{...}: {
  flake.modules.nixos.coreBasePackages = {pkgs, ...}: let
    czg = pkgs.stdenvNoCC.mkDerivation rec {
      pname = "czg";
      version = "1.14.0";

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/czg/-/czg-${version}.tgz";
        hash = "sha512-pO0VNReAHu6TSArr655pYRyShn6n2MX2ohMIz/jIugbI2UkeqSGp46zIOsYKORi9l1WNcdkbCiLKc8lolCr2Tw==";
      };

      nativeBuildInputs = [pkgs.makeWrapper];
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        mkdir -p "$out/lib/czg" "$out/bin"
        cp -r bin lib package.json LICENSE "$out/lib/czg/"
        makeWrapper ${pkgs.nodejs_24}/bin/node "$out/bin/czg" \
          --add-flags "$out/lib/czg/bin/index.js"
        ln -s czg "$out/bin/git-czg"
        runHook postInstall
      '';

      meta = {
        description = "Interactive CLI for Conventional Commits";
        homepage = "https://github.com/Zhengqbbb/cz-git";
        license = pkgs.lib.licenses.mit;
        mainProgram = "czg";
      };
    };
  in {
    environment.systemPackages = with pkgs; [
      tree
      eza
      bat
      imagemagick
      btop
      jq
      ripgrep
      pnpm
      czg
      nodejs_24
      python3
      bun
      wget
      wl-clipboard
    ];
  };
}
