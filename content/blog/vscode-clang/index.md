---
title: "VS Code でC言語を書きやすくする方法"
date: 2021-03-02T15:29:45+09:00
draft: false
# categories: ["技術系"]
toc: true
---
## はじめに
みなさん VS CodeことVisual Studio Code は使っていますでしょうか。
私の所属する電通大でもプログラミングの授業等のアナウンスではVS Codeを使う
方法が紹介されています。

しかし電通大の基礎科目の一つであるコンピュータリテラシの授業では
その授業の一環としてEmacsを用いたLaTeXの書き方を紹介されています。

正直に言います。 何もカスタマイズされていないEmacsをそのまま使うのは苦行
以外の何者でもありません。

それではVSCodeなどのその他のエディタではどうでしょうか。
これらも何もカスタマイズしなければただのメモ帳でしかなく使い勝手が良いとは
お世辞にも言えません。
そのでこの記事ではVSCodeを用いたC言語やその他のプログラミング、はたまた
レポートの書き方などを紹介していきます。

私の悪い癖で前置きが長くなってしまいましたが始めます。

## 拡張機能のお話し

さてVSCodeでは拡張機能を用いて様々な拡張ができます。
拡張機能にはどのようなものがあるのでしょうか

例えばVSCodeでの表示を日本語にする拡張機能である
[Japanese Language Pack for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-ja)
であったり
コードの見た目を整えて見やすくするフォーマッタといわれるツール
[Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
(これはJavaScriptなどのツール)
であったり
VSCodeをその言語専用のエディタ並に進化させる言語パックなど様々なものがあります。

## C言語によるプログラムを書く
さて情報系のみならず理系の大学生ならCによるプログラミングが要求されることが
あると思います。

Cでプログラムを書くにあたって辛いことはたくさんありますがその中で一つ、
デバッグが大変というのがあるかと感じます。
`printf`でもデバッグはできますが限界があります。これを快適にすることを
この記事の目標として進めていきます。


