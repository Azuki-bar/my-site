---
title: "Traefik を触ってみた話"
date: 2021-12-07T19:47:07+09:00
draft: false
---

## はじめに

この記事は[UEC Advent Calendar 2021](https://adventar.org/calendars/6400) 7 日目の記事となっています。

6 日目の記事は つまみ([@TrpFrog](https://twitter.com/TrpFrog))さんの徒歩ブログでした。この記事の元となったイベントには私も参加したのでぜひ記事を見てくださいね！

画像がてんこ盛りで大量にダウンロードするので安定した回線で閲覧することを推奨します。

<div style='text-align: center;'>
    <a href="https://trpfrog.hateblo.jp/entry/c2walker" target='_blank'>
        <img src='https://cdn-ak.f.st-hatena.com/images/fotolife/T/TrpFrog/20211206/20211206005055.jpg' style='max-width: 80%'>
        <div>
            中央環状線+湾岸線を歩いて一周した
        </div>
    </a>
</div>

## Docker

みなさんは Docker 使っていますか？ Docker 便利ですよね。

私も色々な目的で使用していますが、今回は時間割サイト[^1]を VPS にホストするために使用した事例を紹介します。

[^1]: UEC Advent Calendar 2021 6 日目の記事を書いた[つまみ](https://twitter.com/TrpFrog)さんが作成した[時間割](https://github.com/TrpFrog/timetable-page)

## 時間割の説明

快適な大学生活を送るためにも手間はなるべく省きたい。

- 授業ページを閲覧するのにいちいちシラバスを見る
- Zoom リンクを見るために何かしらのアプリを開く

上の事項を一括で管理したかったと思っていた矢先に時間割の Docker イメージを配布している~~徒歩バカ~~人がいました！！！！使うぞ！！！！！

時間割を自宅のサーバに置いても外部からアクセスできない環境にいます。(ドーム友達~~がいない~~とも言う) ということで、適当なサーバを借りてホストすることにしました。

## Traefik に出会う

適当なサーバに置くからには認証を掛けないといけません。Zoom のリンクや授業資料のパスワードが漏れてしまいます。

友人のネットワークスペシャリスト資格も持っている Docker とか Kubernetes のオタク[^2]に Traefik を教えてもらいました。

[^2]: ごっちさん [Twitter](https://twitter.com/0xgotti) UEC Advent Calendar 2021 の 18 日目担当

[Traefik 公式サイト](https://traefik.io/)

これはあるサーバに来た HTTP リクエストなどを適切なコンテナに割り振ってくれるソフトウェアです。一言で言えばリバースプロキシです。

traefik ではミドルウェアとして認証機能やその他のコンテナを挟むことが出来ます。説明は[公式ドキュメント](https://doc.traefik.io/traefik/middlewares/overview/)の図が詳しいです。

<div style='text-align: center;'>
    <a href="https://github.com/thomseddon/traefik-forward-auth" target='_blank'>
        <img src='https://opengraph.githubassets.com/cfdcf5bb1fd6c09bc35314a46eeb05778247268ac79b83daeaf10c5ed8387b75/thomseddon/traefik-forward-auth' style='max-width: 80%'>
    <div>
        thomseddon/traefik-forward-auth
    </div>
    </a>
</div>
