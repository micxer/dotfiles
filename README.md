# dotfiles

Just my collection of dotfiles. Feel free to use it as you like but please make sure, you know what these configurations
do!

**I won't be responsible for any loss of revenue or data!**

## Backup/Restore macOS defaults

Backup:

Find out what keys to backup:

```sh
defaults export com.googlecode.iterm2 > before.txt
# change preferred settings
defaults export com.googlecode.iterm2 > after.txt
diff -wyW200 before.txt after.txt
```

```sh
.config/backup/bdefaults backup --all --path .config/backup/defaults
```

Restore:

```sh
.config/backup/bdefaults restore --all --path .config/backup/defaults
```
