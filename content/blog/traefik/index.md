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

これはあるサーバに来た HTTP リクエストなどを適切なコンテナに割り振ってくれるソフトウェアです。一言で言えばリバースプロキシです。割り振りのルールはパスやHostヘッダーの内容など、沢山用意されています。

下にtraefikを使用したときのdocker-compose.ymlの例を掲載します。

```yaml
version: '3'

services:
  traefik:
    image: traefik:v2.5.3
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/traefik/traefik.yml:/etc/traefik/traefik.yml
      - /opt/traefik/letsencrypt/acme.json:/letsencrypt/acme.json
    scale: 1

  traefik-forward-auth:
    image: thomseddon/traefik-forward-auth:2.2
    environment:
      - DEFAULT_PROVIDER=generic-oauth
      - PROVIDERS_GENERIC_OAUTH_AUTH_URL=https://github.com/login/oauth/authorize
      - PROVIDERS_GENERIC_OAUTH_TOKEN_URL=https://github.com/login/oauth/access_token
      - PROVIDERS_GENERIC_OAUTH_USER_URL=https://api.github.com/user
      - PROVIDERS_GENERIC_OAUTH_CLIENT_ID=XXXXXXXXXXXXX
      - PROVIDERS_GENERIC_OAUTH_CLIENT_SECRET=XXXXXXXXXXXXX
      - INSECURE_COOKIE=false # Example assumes no https, do not set true in production
      - SECRET=XXXXXXXXXXXXXXXXXXX
      - WHITELIST=mail@example.com
    labels:
      - "traefik.http.middlewares.traefik-forward-auth.forwardauth.address=http://traefik-forward-auth:4181"
      - "traefik.http.middlewares.traefik-forward-auth.forwardauth.authResponseHeaders=X-Forwarded-User"
      - "traefik.http.middlewares.traefik-forward-auth.forwardauth.trustForwardHeader=true"
      - "traefik.http.services.traefik-forward-auth.loadbalancer.server.port=4181"
  timetable:
    image: ghcr.io/trpfrog/timetable:latest
    volumes:
      - ./timetable-page/src:/usr/share/nginx/html:ro
    labels:
      - "traefik.http.routers.timetable.rule=Host(`somedomain.example.com`)"
      - "traefik.http.routers.timetable.middlewares=traefik-forward-auth"
      - "traefik.http.routers.timetable.tls.certresolver=myresolver"
      - "traefik.http.routers.timetable.entrypoints=websecure"

      - "traefik.http.routers.timetable_http.entrypoints=web"
      - "traefik.http.routers.timetable_http.rule=Host(`somedomain.example.com`)"
      - "traefik.http.routers.timetable_http.middlewares=timetable_http"
      - "traefik.http.middlewares.timetable_http.redirectscheme.scheme=https"
      - "traefik.http.middlewares.timetable_http.redirectscheme.permanent=true"
```

このようにdockerのlabelとしてtraefikにして欲しいことを記述することでtraefikが交通整理してくれます。

またtraefik ではミドルウェアとして認証機能やその他のコンテナを挟むことが出来ます。説明は[公式ドキュメント](https://doc.traefik.io/traefik/middlewares/overview/)の図が詳しいです。

そこで今回は以下のイメージを挟んで認証を掛けることにしました。

<div style='text-align: center;'>
    <a href="https://github.com/thomseddon/traefik-forward-auth" target='_blank'>
        <img src='https://opengraph.githubassets.com/cfdcf5bb1fd6c09bc35314a46eeb05778247268ac79b83daeaf10c5ed8387b75/thomseddon/traefik-forward-auth' style='max-width: 80%'>
    <div>
        thomseddon/traefik-forward-auth
    </div>
    </a>
</div>

このイメージを経由することでGoogle OAuthなどの認証を掛けることができます。今回はGitHubが提供しているOAuthを間に挟みました。これにより機密情報を全世界に公開することを避けることができました。ﾔｯﾀﾈ!

## まとめ

Dockerを用いたサービスの提供をしたいならTraefikを使用することをおすすめします。簡単な設定で面倒な交通整理をしてくれます。内容がかなり薄くなってしまいましたが、今回はこの辺りで終了させていただきます。

今回のAdvent Calendarは申し込みが遅れたこともあり本日となりましたが、中間試験が翌日に控えていて非常によろしくないですね。

## 次の人

UEC Advent Calendar 2021 8日目の担当は Mr.Mountain さんの『身の上話と、メンタルヘルスについて』です。記事が投稿され次第リンクを貼ります。

それでは。

## 参考

- [Traefik公式ドキュメント](https://doc.traefik.io/traefik/)
- [thomseddon/traefik-forward-auth](https://github.com/thomseddon/traefik-forward-auth)
- [UEC Advent Calendar 2021](https://adventar.org/calendars/6400)
- [UEC Advent Calendar 2021 その2](https://adventar.org/calendars/6598)
- [つまみさんの時間割ジェネレータ](https://github.com/TrpFrog/timetable-page)

