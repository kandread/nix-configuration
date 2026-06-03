{ ... }:
{
  den.aspects.tmux = {
    homeManager = { pkgs, ... }: {
      programs.tmux = {
        enable = true;
        shell = "${pkgs.fish}/bin/fish";
        terminal = "tmux-256color";
        keyMode = "vi";
        prefix = "C-a";
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 50000;
        aggressiveResize = true;
        focusEvents = true;
        clock24 = true;
        disableConfirmationPrompt = true;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          yank
          vim-tmux-navigator
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavor "mocha"
              set -g @catppuccin_window_status_style "rounded"
              set -g @catppuccin_status_modules_right "directory session date_time"
            '';
          }
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '10'
            '';
          }
        ];

        extraConfig = ''
          # True color support
          set -as terminal-overrides ",xterm-256color:RGB"
          set -as terminal-overrides ",*:Smulx=\E[4::%p1%dm"
          set -as terminal-overrides ",*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m"

          # Split panes with intuitive keys, keep current path
          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"
          unbind '"'
          unbind %

          # Vim-style pane navigation (works with vim-tmux-navigator)
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # Resize panes with shift+arrow
          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          # Quick reload
          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

          # Mouse support
          set -g mouse on

          # Copy mode improvements
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          # Don't rename windows automatically
          set -g allow-rename off

          # Activity monitoring
          setw -g monitor-activity on
          set -g visual-activity off

          # Pane border styling
          set -g pane-border-lines heavy
          set -g pane-active-border-style "fg=colour4"

          # Status bar position
          set -g status-position top
        '';
      };
    };
  };
}
