# Tmux Quick Reference
# Prefix is Ctrl + A (<prefix>)

── Panes ─────────────────────────────────────────────────────────
  `<prefix> |`        Vertical split (side-by-side, keeps current dir)
  `<prefix> -`        Horizontal split (top-and-bottom, keeps current dir)
  `Ctrl + h/j/k/l`    Navigate panes seamlessly (nvim-aware, no prefix)
  `<prefix> H/J/K/L`  Resize active pane 5 cells in direction (repeatable within 700ms)
  `Ctrl + d`          Exit shell / close pane gracefully
  `<prefix> x`        Force kill pane immediately (stuck processes)

── Windows ───────────────────────────────────────────────────────
  `<prefix> c`        Create new window tab (keeps current dir)
  `<prefix> ,`        Rename active window
  `<prefix> [`        Previous window tab
  `<prefix> ]`        Next window tab
  `<prefix> X`        Kill active window tab (no confirmation)

── Sessions ──────────────────────────────────────────────────────
  `t`                 Attach to last active session or start a new one
  `tls`               List all running tmux sessions
  `ta`                Fzf picker across active sessions + project directories
  `ta -s`             Fzf picker across active sessions only
  `tnew <name>`       Create named session in selected project directory
  `tk [name]`         Kill session (updates resurrect snapshot)
  `<prefix> f`        Open floating sessionizer popup inside tmux
  `<prefix> s`        Visual interactive tree switcher
  `<prefix> d`        Detach from session (leaves it running)
  `<prefix> Ctrl+s`   Save tmux session snapshot manually
  `<prefix> Ctrl+r`   Restore tmux session snapshot manually

── Copy Mode (Vi Keys) ───────────────────────────────────────────
  `<prefix> Enter`    Enter copy / scrollback mode
  `v`                 Begin visual selection
  `y`                 Yank / copy selection to system clipboard (pbcopy)
  `Escape`            Cancel / exit copy mode
