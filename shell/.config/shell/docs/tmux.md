# Tmux Quick Reference

## Prefix Key
- `Ctrl + a` is `<prefix>`
- `Ctrl + a` then `Ctrl + a` sends literal `Ctrl + a` to inner program

## Pane Management
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<prefix> \|` | Vertical Split | Split current pane side-by-side (keeps current dir) |
| `<prefix> -` | Horizontal Split | Split current pane top-and-bottom (keeps current dir) |
| `Ctrl + h/j/k/l` | Navigate Panes | Smart navigation across Tmux panes & Neovim splits (no prefix) |
| `<prefix> H/J/K/L` | Resize Pane | Expand / shrink active pane by 5 cells (repeatable: tap H/J/K/L repeatedly) |
| `Ctrl + d` | Close Pane | Cleanly exit shell and close pane |
| `<prefix> x` | Kill Pane | Force terminate pane immediately (no confirmation) |

## Window Management
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<prefix> c` | New Window | Create new window tab (keeps current dir) |
| `<prefix> ,` | Rename Window | Rename the active window |
| `<prefix> [` | Previous Window | Switch to left window tab |
| `<prefix> ]` | Next Window | Switch to right window tab |
| `<prefix> X` | Kill Window | Close active window tab (no confirmation) |

## Sessions & Navigation
| Command / Key | Action | Description |
| :--- | :--- | :--- |
| `t` | Quick Attach | Attach to last active session or start a new one |
| `tls` | List Sessions | List all running tmux sessions |
| `ta` | Session Manager | Fzf picker across active sessions + project directories |
| `ta -s` | Sessions Only | Fzf picker across active sessions only |
| `tnew <name>` | Named Session | Create session with name in selected project dir |
| `tk [name]` | Kill Session | Terminate session and update resurrect snapshot |
| `<prefix> f` | Sessionizer Popup | Open floating sessionizer menu inside tmux |
| `<prefix> s` | Interactive Tree | Visual tree switcher for all windows/sessions |
| `<prefix> d` | Detach | Detach from session (leaves it running in background) |

## Copy Mode (Vi Keys)
| Keybinding | Action | Description |
| :--- | :--- | :--- |
| `<prefix> Enter` | Enter Copy Mode | Enter scrollback copy mode |
| `v` | Begin Selection | Start highlighting text |
| `y` | Yank / Copy | Copy highlighted selection to system clipboard (`pbcopy`) |
| `Escape` | Cancel | Exit copy mode |
