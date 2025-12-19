#!/usr/bin/env bash

for FILE in .gitconfig .gitignore .starship.toml .vimrc .zlogout .zprofile .zshrc
do
  ln -s "$(pwd)/$FILE" "$HOME/$FILE"
done
