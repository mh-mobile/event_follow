# イベントフォロー

イベントフォローは、自分の興味の方向に近い技術イベントを見逃してしまう問題を解決したい、技術イベント発見サービスです。ユーザーは Twitterの友達がシェアしたDoorkeeper、connpassのイベントを発見することができ、キーワードで検索することとは違い、検索せずに自分の興味の方向に近いイベントを発見できることが特徴です。

# 開発環境のセットアップ

## リポジトリのclone

```bash
$ git clone https://github.com/mh-mobile/event_follow.git
```

## 環境変数の設定

Docker起動に必要な環境変数を定義します。

| 環境変数名    | 値  |  説明 |
| --- | --- | --- |
| WORKDIR   | app | コンテナ内部のワーキングディレクト |
| API_PORT  | 3000 | APIサーバのポート番号 |
| FRONT_PORT  | 8080 | フロントのNuxt.jsのポート番号 | 
| POSTGRES_PASSWORD  | postgres | PostgreSQLのパスワード |
| RAILS_MAX_THREADS | 10 | Railsの最大スレッド数 | 
| RAILS_MASTER_KEY | ※ master.keyの値を指定 | Railsのmaster.keyの値 | 
| REDIS_URL | redis://localhost:6379/12 | RedisのURLの値 | 

Firebaseのコンフィグの環境変数を定義します。
[Firebase Console](https://console.firebase.google.com/?hl=JA)でFirebaseプロジェクトを作成し、
作成したFirebaseプロジェクトのコンフィグの値を指定してください。

| 環境変数名 | 
| --- | 
| FIREBASE_API_KEY | 
| FIREBASE_AUTH_DOMAIN  |
| FIREBASE_PROJECT_ID  | 
| FIREBASE_STORAGE_BUCKET  |
| FIREBASE_MESSAGE_SENDER_ID  |
| FIREBASE_APP_ID  | 
| FIREBASE_MEASUREMENT_ID | 

Twitter用の環境変数を定義します。
TwitterログインやTwitter APIのアクセスに使用します。

Twitterの[Developer Portal](https://developer.twitter.com/)のサイトでTwitterアプリのプロジェクトを作成し、
作成したプロジェクトの値を指定してください。

| 環境変数名    | 説明|
| --- | --- | 
| TWITTER_KEY | Twitterのアクセストークンの値 |
| TWITTER_SECRET  | Twitterのアクセストークンシークレットの値 |
| OAUTH_CONSUMER_KEY  | Twitterのコンシューマーキーの値 |
| OAUTH_CONSUMER_SECRET  | Twitterのコンシューマーキーシークレットの値 |
| OAUTH_APP_TOKEN | TwitterのBearerトークンの値 |

Doorkeeprの認証トークンの環境変数を定義します。

| 環境変数名    | 説明|
| --- | --- | 
| DOORKEEPER_AUTH_TOKEN | Doorkeeperのアカウントで発行した認証トークンの値 |

Sentryのログトラッキング用のDSNの環境変数を定義します。

| 環境変数名    | 説明|
| --- | --- | 
| SENTRY_DSN | フロントのNuxt.js用のSentryのDSN値 |
| API_SENTRY_DSN | Rails API用のSentryのDSN値 |


## Dockerの起動

docker-comopseを使用して、以下のコンテナを起動します。


| コンテナ名    | 説明  | 
| --- | --- | 
| event_api  | Rails API(サーバ) | 
| event_front  | Nuxt.js(フロント) | 
| event_redis  | Redis | 
| event_db  | PosgreSQL | 


```bash
$ docker-compose up
```

## アプリの動作確認

Dockerの起動後に、ブラウザで[http://localhost:8080](http://localhost:8080)にアクセスします。

# Railsのテスト

RSpecのテストを実行します。

```bash
$ docker exec -it event_api bin/rspec
```

# Nuxt.jsのテスト

jestのテストを実行します。

```bash
$ docker exec -it event_front yarn run test
```

# Nuxt.jsのフォーマット

Prettierを実行します。

```bash
$ docker exec -it event_front yarn run prettier
```

# Nuxt.jsのリント

ESLintを実行します。

```bash
$ docker exec -it event_front yarn run lint
```

自動修正を行う場合は、lint-fixを使用します。

```bash
$ docker exec -it event_front yarn run lint-fix
```

# Storybookの起動

```bash
$ docker exec -it event_front yarn run storybook
```

| ツール    | URL    | 
| --- | --- | 
|  Storybook  | [http://localhost:3003](http://localhost:3003)  | 


# OpenAPIの起動

docker-comopseを使用して、以下のコンテナを起動します。

| コンテナ名    | 説明   | 
| --- | --- | 
|  Swagger Editor  | Swagger Editorのコンテナ  | 
|  Swagger UI  | Swagger UIのコンテナ  | 
|  Redoc  | Redocのコンテナ | 

コンテナを起動するために、api/docsに移動し、`docker-compose up`を実行します。

```bash
$ cd api/docs
$ docker-compose up
```

| ツール    | URL    | 
| --- | --- | 
|  Swagger Editor  | [http://localhost:8083](http://localhost:8083)  | 
|  Swagger UI  | [http://localhost:8082](http://localhost:8082)  | 
|  Redoc  | [http://localhost:8081](http://localhost:8081)  | 

# ライセンス
本ソフトウェアは、MITライセンスの元提供されています。

