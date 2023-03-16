# dotfiles

## prerequisites

- stow

clone repo

```bash
git clone git@github.com:andiexer/dotfiles.git ~/.dotfiles
```

Run `stow` to symlink everything or just select what you want

```
stow */ # Everything (the / ignores the README)
```

or just a single config

```bash
stow zsh
```

