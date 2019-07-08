# Makefile
BASE_PATH := $(shell pwd)
SHELL     := $(shell which zsh)

install: ~/.zplugin/bin ~/.zshrc ~/.gitignore

~/.%:
	ln -s $(BASE_PATH)/$(shell basename $@) $@

~/.gitignore:
	ln -s $(BASE_PATH)/_gitignore ~/.gitignore

~/.gitconfig:
	ln -s $(BASE_PATH)/_gitconfig ~/.gitconfig

~/.zplugin/bin:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
