{...}: {
  flake.modules.homeManager.wezterm = {
    lib,
    osConfig,
    ...
  }: {
    programs.wezterm = {
      enable = osConfig.my.desktop.terminal == "wezterm";

      settings = {
        color_scheme = lib.generators.mkLuaInline ''
          (function()
            local appearance = "Dark"

            if wezterm.gui then
              appearance = wezterm.gui.get_appearance()
            end

            if appearance:find("Dark") then
              return "Solarized Osaka"
            end

            return "Solarized Osaka Light"
          end)()
        '';

        colors = lib.generators.mkLuaInline ''
          (function()
            local appearance = "Dark"

            if wezterm.gui then
              appearance = wezterm.gui.get_appearance()
            end

            if appearance:find("Dark") then
              return {
                tab_bar = {
                  background = "#002c38",
                },
              }
            end

            return {
              tab_bar = {
                background = "#ede7d3",
              },
            }
          end)()
        '';

        # Prevent ssh conflict
        mux_enable_ssh_agent = false;

        # Appearance
        window_background_opacity = 0.65;
        window_decorations = "RESIZE | NONE";

        hide_tab_bar_if_only_one_tab = true;
        use_fancy_tab_bar = false;
        tab_max_width = 1000;
        show_new_tab_button_in_tab_bar = false;
        tab_bar_at_bottom = true;

        enable_scroll_bar = false;

        window_padding = {
          top = 0;
          bottom = 0;
          left = 0;
          right = 0;
        };

        # Font
        font = lib.generators.mkLuaInline ''
          wezterm.font("DankMono Nerd Font")
        '';
        font_size = 17;

        # Terminal
        term = "wezterm";
        scrollback_lines = 10000;
        cursor_blink_rate = 0;

        # Misc
        check_for_updates = false;
        adjust_window_size_when_changing_font_size = false;
        automatically_reload_config = true;

        # Leader
        leader = {
          key = "b";
          mods = "CTRL";
          timeout_milliseconds = 500;
        };

        # Keymaps
        keys = [
          {
            key = "v";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })
            '';
          }
          {
            key = "s";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })
            '';
          }

          {
            key = "h";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.ActivatePaneDirection("Left")
            '';
          }
          {
            key = "j";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.ActivatePaneDirection("Down")
            '';
          }
          {
            key = "k";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.ActivatePaneDirection("Up")
            '';
          }
          {
            key = "l";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.ActivatePaneDirection("Right")
            '';
          }

          {
            key = "z";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.TogglePaneZoomState
            '';
          }

          {
            key = "c";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.SpawnTab("CurrentPaneDomain")
            '';
          }

          {
            key = "n";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.ActivateTabRelative(1)
            '';
          }

          {
            key = "p";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.ActivateTabRelative(-1)
            '';
          }

          {
            key = "w";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.CloseCurrentTab({ confirm = true })
            '';
          }

          {
            key = "g";
            mods = "LEADER";
            action = lib.generators.mkLuaInline ''
              wezterm.action.SpawnCommandInNewTab({ args = { "lazygit" } })
            '';
          }
        ];
      };

      colorSchemes = {
        "Solarized Osaka" = {
          foreground = "#839395";
          background = "#001419";

          cursor_bg = "#839395";
          cursor_border = "#839395";
          cursor_fg = "#001419";

          selection_bg = "#1a6397";
          selection_fg = "#839395";

          ansi = [
            "#001014"
            "#db302d"
            "#849900"
            "#b28500"
            "#268bd3"
            "#d23681"
            "#29a298"
            "#9eabac"
          ];

          brights = [
            "#001419"
            "#db302d"
            "#849900"
            "#b28500"
            "#268bd3"
            "#d23681"
            "#29a298"
            "#839395"
          ];

          tab_bar = {
            inactive_tab_edge = "#002c38";
            background = "#191b28";

            active_tab = {
              fg_color = "#268bd3";
              bg_color = "#001419";
            };

            inactive_tab = {
              bg_color = "#002c38";
              fg_color = "#063540";
            };

            inactive_tab_hover = {
              bg_color = "#002c38";
              fg_color = "#268bd3";
            };

            new_tab_hover = {
              fg_color = "#002c38";
              bg_color = "#268bd3";
            };

            new_tab = {
              fg_color = "#268bd3";
              bg_color = "#191b28";
            };
          };
        };

        "Solarized Osaka Light" = {
          foreground = "#576d74";
          background = "#fdf5e2";

          cursor_bg = "#576d74";
          cursor_border = "#576d74";
          cursor_fg = "#fdf5e2";

          selection_bg = "#46acf5";
          selection_fg = "#576d74";

          ansi = [
            "#cac4b5"
            "#db302d"
            "#849900"
            "#b28500"
            "#268bd3"
            "#d23681"
            "#29a298"
            "#637981"
          ];

          brights = [
            "#fdf5e2"
            "#db302d"
            "#849900"
            "#b28500"
            "#268bd3"
            "#d23681"
            "#29a298"
            "#576d74"
          ];

          tab_bar = {
            inactive_tab_edge = "#fdf5e2";
            background = "#191b28";

            active_tab = {
              fg_color = "#268bd3";
              bg_color = "#fdf5e2";
            };

            inactive_tab = {
              bg_color = "#fdf5e2";
              fg_color = "#ede7d3";
            };

            inactive_tab_hover = {
              bg_color = "#fdf5e2";
              fg_color = "#268bd3";
            };

            new_tab_hover = {
              fg_color = "#fdf5e2";
              bg_color = "#268bd3";
            };

            new_tab = {
              fg_color = "#268bd3";
              bg_color = "#191b28";
            };
          };
        };
      };

      extraConfig = ''
        local wezterm = require("wezterm")

        wezterm.on("format-tab-title", function(tab, _, _, cfg, _, _)
          local tab_bar_palette = cfg.resolved_palette.tab_bar
          local palette = cfg.resolved_palette

          local index = tab.tab_index + 1
          local title = tab.active_pane.title

          if title == "" then
            title = "shell"
          end

          if tab.is_active then
            return {
              { Background = { Color = "#fdf5e2" } },
              { Foreground = { Color = tab_bar_palette.background } },
              { Text = "" },

              { Background = { Color = "#fdf5e2" } },
              { Foreground = { Color = palette.ansi[4] } },
              { Attribute = { Intensity = "Bold" } },
              { Text = string.format(" %d ", index) },

              { Background = { Color = palette.ansi[4] } },
              { Foreground = { Color = "#fdf5e2" } },
              { Text = "" },

              { Background = { Color = palette.ansi[4] } },
              { Foreground = { Color = "#fdf5e2" } },
              { Text = " " .. title .. " " },

              { Background = { Color = tab_bar_palette.background } },
              { Foreground = { Color = palette.ansi[4] } },
              { Text = "" },
            }
          end

          return {
            { Background = { Color = tab_bar_palette.background } },
            { Foreground = { Color = palette.ansi[8] } },
            { Text = " " .. index .. " " },

            { Foreground = { Color = palette.ansi[8] } },
            { Text = "" },

            { Foreground = { Color = palette.ansi[8] } },
            { Text = " " .. title .. " " },
          }
        end)
      '';
    };
  };
}
