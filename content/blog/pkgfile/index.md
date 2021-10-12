---
title: "Arch 使うなら pkgfile を使うと良い"
date: 2021-10-03T02:19:07+09:00
draft: false
---

## はじめに

みなさん Arch Linux 使っていますか。

使っていない人は入れましょう。 [https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89https://wiki.archlinux.jp/index.php/%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%82%AC%E3%82%A4%E3%83%89]

今回は `pkgfile`コマンドのご紹介です。

### 対象読者

この記事は Arch Linux、 もしくはそのフォークである Manjaro, alter linux 向けです。

## pkgfile とは

みんな大好き Arch Wiki に該当ページがあるのでリンクを貼ります。
[Arch Wiki](https://wiki.archlinux.jp/index.php/Pkgfile)

pkgfile はあるコマンドがどのパッケージに所属しているのかを表示するコマンドです。

あなたと Arch Linux の旅はパッケージがほとんど何も入っていない状態で始まります。
そんな中あのコマンド使いたいのに入っていない！！！！なんてことありますせんか？ありますよね？

そこで pkgfile です。

## pkgfile を導入する

Manjaro にはすでに導入されています。私も manjaro を使用していたときにこのコマンドを知りました。

導入方法は Arch Wiki を見てください。
pkgfile は公式リポジトリに含まれていますから pacman でダウンロードできます。
`yay`を使えない人は`yay`を導入することもおすすめです。このコマンドは AUR からのダウンロードも`pacman`のように扱えます。

```bash
yay -S pkgfile
```

## command-not-found フックを有効にする

以下のコマンドを`.bashrc`に追加してください。

```bash
source /usr/share/doc/pkgfile/command-not-found.bash
```

## これで

`pkgfile`の導入、そして`command-not-found`フックの有効化が無事に出来ると以下のようにインストールされていないパッケージ由来のコマンドを入力したときに、そのコマンドが含まれているパッケージを表示できます。

```text
$ sl
sl may be found in the following packages:
  community/python-softlayer 5.9.3-1	/usr/bin/sl
  community/sl 5.02-6               	/usr/bin/sl
```

## おわりに

ぜひ快適な Arch Linux ライフをお送りください！
