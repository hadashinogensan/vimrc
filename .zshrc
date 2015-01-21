
# 環境依存の設定を読み込む
if [ -e "$HOME/dotfile/.zshrc.enviroment" ]; then
  source $HOME/dotfile/.zshrc.enviroment
fi

# 色を使用出来るようにする
autoload colors
colors

# git-completetionのロード
fpath=(~/.zsh/contrib/completion/ $fpath)
autoload -U compinit
compinit -u

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info

# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# プロンプト
PROMPT="[%~/]
%{${fg[cyan]}%}%n @ %m $ %{${reset_color}%}"
RPROMPT="%{${fg[cyan]}%}%1(v|%1v|)%{${reset_color}%}"

case ${OSTYPE} in
  darwin*)
    # Macの設定
    ;;
  linux*)
    eval $(dircolors $HOME/dotfile/dircolors.ansi-light)
    ;;
esac

#cdを打ったら自動的にlsを打ってくれる関数
function chpwd(){ ls -G; }

# エイリアス
alias ls='ls --color=auto -F'
alias la='ls -laG'
alias ll='ls -l'

alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias gr='grep -rn --color'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

alias vi="vim"
alias g="git"
alias pd='popd'

# tmuxが起動していない場合にalias設定を行う
if [ $SHLVL = 1 ]; then
  alias tmux="tmux -2 attach || tmux -2 new-session \; source-file ~/dotfile/.tmux.auto_split"
fi

# コマンドラインスタック
show_buffer_stack() {
  POSTDISPLAY="
  stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack

tailf() {
  if [ $# -eq 1 ]; then
    tail -f $1
  elif [ $# -eq 2 ]; then
    tail -f $1 | grep $2;
  fi
}

# オプション # {{{

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
# 補完にもLS_COLORS の設定を反映する
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# beep を無効にする
setopt no_beep
# ディレクトリ名だけでcdする
setopt auto_cd
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
# push, popd したときにdirsを表示しないようにする
setopt pushd_silent
# = の後はパス名として補完する
setopt magic_equal_subst
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu
# 高機能なワイルドカード展開を使用する
setopt extended_glob
# 右側まで入力がきたら時間表示を消す
setopt transient_rprompt
# ディレクトリ名の補完で末尾に/を付加する
setopt auto_param_slash
# ドットなしでドットファイルの補完を行う
setopt globdots
# #の後をコメントとして扱う
setopt INTERACTIVE_COMMENTS
# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


# }}}
