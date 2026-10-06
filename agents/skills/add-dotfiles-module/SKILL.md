---
name: add-dotfiles-module
description: Use when adding a new CLI tool, configuration file, or GNU Stow package to dotfiles-ibm, updating bootstrap install scripts, or wiring module symlinks.
---

# Add Dotfiles Module Workflow

Guide the user or agent through adding a new tool, configuration file, or package to `dotfiles-ibm` cleanly and idempotently.

## Step 1: Establish the Stow Directory Structure

GNU Stow mirrors file paths relative to `$HOME`.

1. Identify the intended destination path in `$HOME`:
   - Config directory: `~/.config/<tool-name>/...`
   - Top-level dotfile: `~/.<tool-name>rc` or `~/.<tool-name>.conf`
2. Create the package directory under the workspace root:
   - For `~/.config/foo/config.toml` -> create `foo/.config/foo/config.toml`
   - For `~/.barrc` -> create `bar/.barrc`

## Step 2: Security & Secrets Verification

- Ensure no API keys, tokens, passwords, or personal credentials are committed in configuration files.
- If the tool requires tokens or environment variables, reference `~/.config/shell/work.sh` (which is in `.gitignore`).

## Step 3: Update Bootstrap Scripts

Always update both install scripts to ensure cross-platform compatibility:

### macOS (`install-mac.sh`)
1. **Package Installation**:
   - If the tool is available via Homebrew, add it to `CORE_CLI` (or `brew_cask_install` if it is a GUI app).
2. **Pre-Stow Backup**:
   - Add `backup_if_real ".config/<tool-name>"` (or the top-level file) under the backup section.
3. **Stow Execution**:
   - Add the module name to the `stow` loop:
     ```bash
     for mod in shell bash zsh starship nvim tmux ghostty hammerspoon <tool-name>; do
       stow "$mod" && ok "stowed: $mod"
     done
     ```

### Linux (`install.sh`)
1. **Package Installation**:
   - Add the package to `PACKAGES` or define distro-specific mapping in `pkg_map`.
2. **Pre-Stow Backup**:
   - Add `backup_conflict "$HOME/.config/<tool-name>"` under the backup section.
3. **Stow Execution**:
   - Add the module name to the `stow` invocation list.

## Step 4: Stow and Validate

1. Run GNU Stow to link the new module into `$HOME`:
   ```bash
   stow <tool-name>
   ```
2. Verify the symlink in `$HOME` points correctly into `dotfiles-ibm`:
   ```bash
   ls -la ~/.config/<tool-name>
   ```
