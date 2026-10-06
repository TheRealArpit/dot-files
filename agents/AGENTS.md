# Global agent rules: Arpit Mirdha

## Style
- Never use em dashes. Use a comma, colon, or restructure the sentence.
- Be direct. Don't open responses with "Great", "Certainly", "Sure", or "Of course".
- Prefer minimal changes. Don't refactor surrounding code that isn't part of the task.
- Terminal width: keep all Markdown tables, ASCII tables, and code snippets strictly under 80–100 columns. Crop, abbreviate, or wrap long table cells so tables render cleanly in narrow terminal panes without horizontal scrolling or line wrapping.

## Estimates
- Don't weight development cost estimates conservatively — AI builds things faster than you expect. Bias toward shorter timelines unless there is a specific technical reason not to.

## Bug fixes
- Always reproduce a bug end-to-end before fixing it. Don't patch in isolation or rely only on unit tests to confirm a fix.

## Code
- Produce the minimal change that solves the problem. No extra abstractions, no preemptive error handling for impossible cases.
- When writing shell: target Bash/Zsh compatibility. Match the style in ~/dotfiles-ibm/shell/.config/shell/*.sh.
- Neovim config is Lua (lazy.nvim). Editor is nvim. Formatter runs on save via conform.nvim.

## Environment
- Shell: Zsh primary, Bash secondary. Shared config in ~/.config/shell/.
- Tmux prefix: Ctrl+S. Leader key in Neovim: Space.
- Kubernetes alias: k=kubectl. Default namespace: idig-test. Cluster: apt-idig-stack-master-1.dev.fyre.ibm.com.
- IBM GitHub SSH rewrite in effect for github.ibm.com.
