---
title: "ssh 接続で公開鍵認証が使えなくなったお話"
date: 2021-02-05T23:29:05+09:00
draft: false
---

## 症状

`ssh -i (鍵アドレス)`と明記してもその秘密鍵を使用せずに
パスワード認証を要求してくる．

なおそのコマンド実行前に`ssh-copy-id`を用いて正常に公開鍵をサーバに記録した．

## 対処

```
ssh user@host -v
```

を実行したところ

```
debug1: Remote: Ignored authorized keys: bad ownership or modes for directory (ホームディレクトリ)
```

と表示されたので

```
chmod 755 $HOME
```

を実行しモードを変更した．

## 考察

どうやら`ssh`は秘密鍵の書き換えを防ぐために所有者以外に書き込み権限を与えているとその秘密鍵を使ってくれないらしい．

## 参考サイト

- [ssh の公開鍵認証で Server refused our key が出る問題について](http://shoyan.hatenablog.com/entry/20111117/1321546001)
- [SSH で公開鍵認証を使う](https://www.pistolfly.com/weblog/2007/02/ssh.html)
