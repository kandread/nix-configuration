{ ... }:
{
  den.aspects.kitty = {
    homeManager = { pkgs, ... }: {
      programs.kitty = {
        enable = true;

        font = {
          name = "MesloLGS Nerd Font";
          size = 12;
        };

        themeFile = "Nord";

        settings = {
          # Shell
          shell = "${pkgs.fish}/bin/fish";

          # Appearance
          window_padding_width = 8;
          hide_window_decorations = "no";
          # background_opacity = "0.95";
          dynamic_background_opacity = "yes";

          # Scrollback
          scrollback_lines = 10000;
          scrollback_pager_history_size = 10;

          # Performance
          repaint_delay = 10;
          input_delay = 3;
          sync_to_monitor = "yes";

          # Bell
          enable_audio_bell = "no";
          visual_bell_duration = "0.0";

          # URLs
          url_style = "curly";
          open_url_with = "default";
          detect_urls = "yes";

          # Cursor
          cursor_shape = "beam";
          cursor_blink_interval = "0.5";
          cursor_stop_blinking_after = "15.0";

          # Mouse
          mouse_hide_wait = "3.0";
          focus_follows_mouse = "yes";

          # Remote control — lets Emacs talk to kitty
          allow_remote_control = "yes";
          listen_on = "unix:/tmp/kitty";

          # SSH kitten — auto-copies terminfo to remote hosts
          # Usage: kitten ssh user@host
          shell_integration = "enabled";

          # Tab bar
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_title_template = "{index}: {title}";
        };

        keybindings = {
          # Splits via neighboring windows
          "ctrl+shift+enter" = "new_window_with_cwd";
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+h" = "neighboring_window left";
          "ctrl+shift+l" = "neighboring_window right";
          "ctrl+shift+k" = "neighboring_window up";
          "ctrl+shift+j" = "neighboring_window down";

          # Layout cycling
          "ctrl+shift+space" = "next_layout";

          # Scrollback in less
          "ctrl+shift+s" = "show_scrollback";

          # Increase/decrease font size
          "ctrl+equal" = "change_font_size all +1.0";
          "ctrl+minus" = "change_font_size all -1.0";
          "ctrl+0" = "change_font_size all 0";

          # Clipboard
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+v" = "paste_from_clipboard";
        };

        # SSH kitten config — auto terminfo on remote hosts
        extraConfig = ''
          # Use kitty kitten for ssh
          alias ssh="kitten ssh"
        '';
      };
    };
  };
}
