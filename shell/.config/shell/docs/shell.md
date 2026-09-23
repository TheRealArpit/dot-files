# Shell & CLI Utilities Quick Reference

── FZF Fuzzy Search (Global Shell Shortcuts) ─────────────────────
  `Ctrl + R`          Interactive fuzzy search through shell command history
  `Ctrl + T`          Fuzzy search files from current dir & paste path into prompt
  `Alt + C`           Fuzzy search sub-directories and cd into selected folder

── Core Aliases & Helpers ─────────────────────────────────────────
  `reload`            Restart shell session and reload all dotfile configs
  `c`                 Clear terminal screen
  `caf`               Keep Mac awake (caffeinate -d)
  `..` / `...`        cd .. / cd ../..
  `velox`             Jump to APIC repository root ($VELOX / ~/apic)
  `idig-br`           Jump to idig-broker directory
  `idig-op`           Jump to idig-operator directory

── Modern Replacement Tools ───────────────────────────────────────
  `ls`                eza with icons, git status, and directories first
  `ll`                eza detailed list with headers, permissions, git status
  `lt`                eza tree view (level 2, respects .gitignore)
  `cat` / `bat`       bat with Catppuccin syntax highlighting and line numbers
  `z <folder>`        zoxide teleport jump to frequent/recent folder
  `zi`                Interactive fzf directory jump list
  `lg`                Open Lazygit terminal interface
  `ld`                Open Lazydocker terminal interface
