{
  description = "My NixOS setup";

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    neovim.url = "github:rxtsel/nvim";
    llm-agents.url = "github:numtide/llm-agents.nix";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };

  outputs = {
    flake-parts,
    import-tree,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
        (import-tree ./modules)
      ];
    };
}
