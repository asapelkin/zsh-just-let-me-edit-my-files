# zsh-just-let-me-edit-my-files

ZSH plugin that lets you restart your editor with sudo when accidentally open non-writable files

## Install (Oh My Zsh)

1. Install plugin:

```bash
git clone https://github.com/asapelkin/zsh-just-let-me-edit-my-files.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-just-let-me-edit-my-files
```

1. Add zsh-just-let-me-edit-my-files to plugins in ~/.zshrc.
1. Reload shell:

```bash
exec zsh
```

## How it works

- Wraps editor commands and checks write permissions for target files/paths.
- If a target is not writable:
  - `Enter` -> reopen with `sudo`
  - `Esc` -> open normally (without `sudo`)

## Editors

- Wrapped editors: `vim`, `vi`, `nano`.
