---
title: "クラウド破綻しかけた話"
date: 2021-04-03T21:44:45+09:00
draft: false
toc: true
---

# クラウド破綻しかけた話

## はじめに

こんにちは。謎の団体、[工学研究部](https://www.koken.club.uec.ac.jp)に所属している20のあずきバーと申します。

工研の内部連絡ツールであるSlackを覗いたら「工研ブログリレー」の要項が流れてきたので今記事を書いています。なお現在日付が変わるまであと3時間を切っています。まずいわよ！！！！

またこの記事タイトルに含まれる破綻は釣りワードです。実際には破綻していません。

## クラウド破綻の定義

この記事でのクラウド破綻はクラウド料金が払えなくて大変なことになってしまうこととします。


## 経緯
1月の中旬くらいに同じく工研部員であるgottiさんと工研内製WikiであるKokenWikiのホスト環境を変えられないかを議論していました。

そこで現状AppEngine + Cloud SQLで動いているWikiをCloud Run + Cloud SQL で動作させたら動作速度などは変わるのかを実験しようと試みました。
現在動いているDBを触るわけにはいきませんからCloud SQLのためのインスタンスを別に立ち上げ実験に挑戦しました。

このCloud SQLを止め忘れたのが今回の破綻の経緯です。

## 結果

Cloud SQLを止め忘れていたことに気がついたのは上の実験を行った60日後くらいです。何となくクレカの支払い明細を見たところGCPに対して支払ったことが無い金額が請求されていました。
Cloud SQLのためのインスタンスは1日動かすとおおよそ90円かかります。よって追加で5400円ほど請求されていました。

ひぇぇぇぇぇ

## 教訓

このちょっとした事件によっていくつかの学びを得ました。

一つ目はGCPを使うときは必ず適切な予算を設定した予算アラートを設定すること。

二つ目はクレカの支払い明細は高頻度で確認すること。

予算アラートはいつも払っている金額を上回る程度に設定しておきましょう。私は極端に低い額に設定していたため予算アラートが鳴っても無視してしまう状況になっていました。

二つ目は言うまでも無いです。自分が使ったお金は自分で管理して。

## まとめ

ブログリレー、大幅に遅刻して申し訳ありません。

工学研究部新歓対面説明会が2022年4月10日に電通大新C403教室でありますので電通大新入生の方はぜひお越しください。
何か怪しい企画が水面下で動いているらしい。


工研以外のサークルも対面での勧誘を行うのでぜひ！

それではあずきバーでした。

## リンク

[工研新歓ブログリレー](https://gotti.dev/post/koken_blog_relay_2022_index)
