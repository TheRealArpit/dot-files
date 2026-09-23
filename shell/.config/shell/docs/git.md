# Git Aliases Quick Reference

## Status & Changes
| Alias | Command | Description |
| :--- | :--- | :--- |
| `gs` | `git status` | Show working tree status |
| `gd` | `git diff` | Diff of unstaged changes |
| `gds` | `git diff --staged` | Diff of staged changes |
| `gl` | `git log --graph ... -20` | Compact colorized commit graph (last 20) |
| `gla` | `git log --graph ... --all` | Full colorized commit graph across all branches |

## Staging & Commits
| Alias | Command | Description |
| :--- | :--- | :--- |
| `ga` | `git add` | Stage files (`ga .` or `ga <file>`) |
| `gc` | `git commit -m` | Commit with message (`gc "commit msg"`) |

## Branching & Switching
| Alias | Command | Description |
| :--- | :--- | :--- |
| `gb` | `git branch` | List local branches |
| `gco` | `git checkout` | Switch branch or checkout files |
| `gcb` | `git checkout -b` | Create and switch to new branch |
| `gcl` | `git clone` | Clone a repository |
| `gm` | `git merge` | Merge specified branch |
| `grb` | `git rebase` | Rebase onto specified branch |
| `gclean` | Prune merged | Fetch and delete local branches merged into main |

## Remote Sync
| Alias | Command | Description |
| :--- | :--- | :--- |
| `gp` | `git push` | Push commits to origin |
| `gpl` | `git pull` | Pull latest commits from upstream |
| `gf` | `git fetch` | Fetch remote refs |

## Stash & TUI
| Alias | Command | Description |
| :--- | :--- | :--- |
| `gst` | `git stash` | Stash modified tracked files |
| `gstp` | `git stash pop` | Pop latest stash onto working tree |
| `lg` | `lazygit` | Launch terminal UI for Git |
