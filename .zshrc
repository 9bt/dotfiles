# zshrc

alias ls="ls -G"
alias tree="tree -NC"
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

alias python="python3"
alias pip="pip3"

setopt correct ## 入力しているコマンド名が間違っている場合にもしかして：を出す
setopt nobeep ## ビープを鳴らさない
setopt prompt_subst ## 色を使う
setopt ignoreeof ## ^D でログアウトしない
setopt no_tify ## バックグラウンドジョブが終了したらすぐに知らせる
setopt hist_ignore_dups ## 直前と同じコマンドをヒストリに追加しない
unsetopt auto_menu ## タブによるファイルの順番切り替えをしない
setopt auto_pushd ## cd -[tab] で過去のディレクトリにひとっ飛びできるようにする
setopt auto_cd ## ディレクトリ名を入力するだけで cd できるようにする
setopt hist_ignore_all_dups ## 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する

function chpwd() { ls }
function tab() { echo -ne "\033]0;"$*"\007" }

bindkey -e
function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup
bindkey "^R" history-incremental-search-backward

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# -------------------------------------
# Node.js
# -------------------------------------

if [[ -d "$HOME/.nvm" ]]
then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# -------------------------------------
# Python
# -------------------------------------

if [[ -d "$HOME/.pyenv" ]]
then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# -------------------------------------
# Golang
# -------------------------------------

if [[ -d "$HOME/.goenv" ]]
then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  export GOENV_DISABLE_GOPATH=1
  eval "$(goenv init -)"
fi

if [[ -d "$HOME/dev" ]]
then
  export GOPATH="$HOME/dev"
  export PATH="$PATH:$GOPATH/bin"
fi

# -------------------------------------
# Ruby
# -------------------------------------

if which rbenv > /dev/null
then
  eval "$(rbenv init -)"
fi

# -------------------------------------
# Google Cloud SDK
# -------------------------------------

## The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]
then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

## The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]
then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# -------------------------------------
# Zplugin
# -------------------------------------

## Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-bin-gem-node
## End of Zinit's installer chunk

source $HOME/.zinit/bin/zinit.zsh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_STATUS_HIDE_SIGNAME=true

zinit ice from"gh"
zinit load bhilburn/powerlevel9k

## Local dependency
if [ -f ~/.zshrc.local ]
then
    source ~/.zshrc.local
fi

## End of execution
autoload -U compinit ## 補完機能の強化
compinit

if [ ! -f "~/.zshrc.local.zwc" -o "~/.zshrc.local" -nt "~/.zshrc.local.zwc" ];
then
    zcompile ~/.zshrc.local
fi
if [ ! -f "~/.zshrc.zwc" -o "~/.zshrc" -nt "~/.zshrc.zwc" ]
then
  zcompile ~/.zshrc
fi