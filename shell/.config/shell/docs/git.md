# Git Aliases Quick Reference

── Status & Staging ──────────────────────────────────────────────
  `gs`                git status
  `gd`                git diff (unstaged changes)
  `gds`               git diff --staged
  `ga .`              git add all changes
  `ga <file>`         git add specific file
  `gc "message"`      git commit -m "message"

── Branching & Switching ─────────────────────────────────────────
  `gb`                git branch (list local branches)
  `gco <branch>`      git checkout <branch>
  `gcb <branch>`      git checkout -b <branch> (create and switch)
  `gcl <url>`         git clone <url>
  `gm <branch>`       git merge <branch>
  `grb <branch>`      git rebase <branch>
  `gclean`            Prune local branches merged into main

── Remote Sync ───────────────────────────────────────────────────
  `gp`                git push origin <current-branch>
  `gpl`               git pull
  `gf`                git fetch --all --prune

── Stash & Logs ──────────────────────────────────────────────────
  `gst`               git stash
  `gstp`              git stash pop
  `gl`                Compact colorized commit log graph (last 20)
  `gla`               Full commit log graph across all branches
  `lg`                Open Lazygit terminal UI
