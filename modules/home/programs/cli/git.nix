{...}: {
  flake.modules.homeManager.git = {
    pkgs,
    osConfig,
    ...
  }: let
    user = osConfig.preferences.user;
  in {
    programs.git = {
      enable = true;
      package = pkgs.git;

      settings = {
        user = {
          name = user.fullName;
          email = user.email;
          signingkey = user.gitSigningKeyPath;
        };

        init.defaultBranch = "main";
        pull.rebase = false;
        push.autoSetupRemote = true;

        alias = {
          a = "add";
          s = "status -sb";
          c = "commit -m";
          cz = "czg";
          czai = "czg ai";
          l = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate --all";
        };

        gpg.format = "ssh";
        commit.gpgSign = true;
      };
    };

    programs.gh = {
      enable = true;
    };
  };
}
