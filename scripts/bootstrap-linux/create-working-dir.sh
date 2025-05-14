#!/usr/bin/env bash
#
# @(#) : setup base, XDG, workspaces directories
#
# @version  1.0.0
# @author 	atsushifx
# @since  	2025-05-03
# @license 	MIT
#
# @description <<
#
# create directories or symbolic links for Linux base use:
#   basic directories: ~/bin, ~/temp
#   XDG directories: ~/.config, ~/.local/<xxx>
#   workspaces directories: ~/workspaces/<xxx>
#
#<<

set -euCo pipefail

## ホームディレクトリに移動
pushd ~ > /dev/null

# ユーザー固有の実行可能ファイルを保存するディレクトリ
mkdir -p ~/bin
# 一時ファイルを保存するディレクトリ
mkdir -p ~/temp

# 設定ディレクトリを作成 (XDG Base Directory仕様に準拠)
mkdir -p ~/.config \
  ~/.local/share \
  ~/.local/cache \
  ~/.local/state

# Gitの設定ファイル用ディレクトリを作成
mkdir -p \
  ~/.config/git \
  ~/.local/share/git

# プログラミング用に`workspaces`ディレクトリを作成
mkdir -p ~/workspaces/{develop,education,sandbox,temp}


## All mkdir is success
popd  > /dev/null
# 成功メッセージ
echo "✅ ディレクトリ構成の作成が完了しました。"
