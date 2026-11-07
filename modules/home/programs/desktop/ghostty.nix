{...}: {
  flake.modules.homeManager.ghostty = {osConfig, ...}: {
    programs.ghostty = {
      enable = osConfig.my.desktop.terminal == "ghostty";
      enableZshIntegration = true;
      installVimSyntax = true;

      settings = {
        theme = "light:solarized-osaka-light, dark:solarized-osaka-dark";
        background-opacity = 0.5;
        font-family = "DankMono Nerd Font";
        font-size = 18;

        cursor-invert-fg-bg = true;
        mouse-hide-while-typing = true;
        focus-follows-mouse = true;

        gtk-tabs-location = "bottom";
        gtk-wide-tabs = true;

        window-theme = "ghostty";
        window-decoration = true;
        window-padding-balance = false;
        window-save-state = "never";

        confirm-close-surface = true;
        shell-integration-features = true;
        link-url = true;
        scrollbar = "never";

        keybind = [
          "alt+r=reload_config"
          "alt+t>n=new_tab"
          "alt+p>r=new_split:right"
          "alt+p>d=new_split:down"
          "alt+p>e=equalize_splits"
          "alt+p>z=toggle_split_zoom"
          "alt+p>h=goto_split:left"
          "alt+p>j=goto_split:bottom"
          "alt+p>k=goto_split:top"
          "alt+p>l=goto_split:right"
          "alt+t>l=next_tab"
          "alt+t>h=previous_tab"
          "alt+t>o=toggle_tab_overview"
        ];
      };

      themes = {
        solarized-osaka-dark = {
          background = "001419";
          foreground = "839395";
          cursor-color = "839395";
          selection-background = "1a6397";
          selection-foreground = "839395";
          palette = [
            "0=#001419"
            "1=#db302d"
            "2=#849900"
            "3=#b28500"
            "4=#268bd3"
            "5=#d23681"
            "6=#29a298"
            "7=#fdf5e2"
            "8=#063540"
            "9=#f55350"
            "10=#b7f900"
            "11=#ffbf00"
            "12=#46acf5"
            "13=#f254a0"
            "14=#2aeddd"
            "15=#ffffff"
          ];
        };
        solarized-osaka-light = {
          background = "fdf5e2";
          foreground = "576d74";
          cursor-color = "576d74";
          selection-background = "46acf5";
          selection-foreground = "576d74";
          palette = [
            "0=#ffffff"
            "1=#db302d"
            "2=#849900"
            "3=#b28500"
            "4=#268bd3"
            "5=#d23681"
            "6=#29a298"
            "7=#002c38"
            "8=#ede7d3"
            "9=#b7211f"
            "10=#586600"
            "11=#664c00"
            "12=#1a6397"
            "13=#af2668"
            "14=#1a6265"
            "15=#001419"
          ];
        };
      };
    };
  };
}
