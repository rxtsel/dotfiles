{
  flake.modules.homeManager.lazygit = let
    focusNeovim = ''nvim --server "$NVIM" --remote-send "q"; nvim --server "$NVIM" --remote-send "<C-\\><C-n><Cmd>lua local win = vim.g.rxtsel_lazygit_win; if win and vim.api.nvim_win_is_valid(win) then vim.api.nvim_set_current_win(win) end<CR>"'';
    editCommand = atLine: let
      lineArg = if atLine then "+{{line}} " else "";
      goToLine = if atLine then ''nvim --server "$NVIM" --remote-send ":{{line}}<CR>";'' else "";
    in ''begin; if test -z "$NVIM"; nvim ${lineArg}-- {{filename}}; else; ${focusNeovim}; nvim --server "$NVIM" --remote {{filename}}; ${goToLine} end; end'';
  in {
    programs.lazygit = {
      enable = true;

      settings = {
        gui = {
          nerdFontsVersion = "3";
          mouseEvents = false;

          theme = {
            activeBorderColor = [
              "#c94c16"
              "bold"
            ];
            inactiveBorderColor = ["#664c00"];
            searchingActiveBorderColor = [
              "#c94c16"
              "bold"
            ];
            optionsTextColor = ["#268bd3"];
            selectedLineBgColor = ["#1a6397"];
            cherryPickedCommitFgColor = ["#268bd3"];
            cherryPickedCommitBgColor = ["#d23681"];
            markedBaseCommitFgColor = ["#268bd3"];
            markedBaseCommitBgColor = ["#b28500"];
            unstagedChangesColor = ["#f55350"];
            defaultFgColor = ["#839395"];
          };
        };

        git = {
          autoFetch = false;
          diffRenderers = [
            {
              type = "stdinFilter";
              colorArg = "always";
              command = ''delta --dark --paging=never --syntax-theme="Solarized (dark)"'';
            }
          ];
        };

        os = {
          editPreset = "nvim-remote";
          edit = editCommand false;
          editAtLine = editCommand true;
        };

        customCommands = [
          {
            key = "C";
            context = "files";
            command = "git cz";
            description = "Commit with Commitizen";
            output = "terminal";
          }
        ];
      };
    };
  };
}
