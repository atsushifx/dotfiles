# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする

# ヒストリの設定
HISTFILE="${XDG_DATA_HOME}/zsh/.zsh_hist"
HISTSIZE=1000000
SAVEHIST=1000000

# prompt
PROMPT='%F{green}%n@%m%F{magenta} /%C%f %# '


# opam configuration
# test -r /home/atsushifx/.opam/opam-init/init.sh && . /home/atsushifx/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
