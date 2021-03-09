# イベントフォロー

イベントフォローは、自分の興味の方向に近い技術イベントを見逃してしまう問題を解決したい、技術イベント発見サービスです。ユーザーは、Twitterの友達がシェアしたDoorkeeper、connpassのイベントを発見することができ、キーワードで検索することとは違い、検索せずに自分の興味の方向に近いイベントを発見できることが特徴です。

# 機能一覧

### イベント一覧の表示

* Twitterでフォローしたユーザー（以下、友達）が投稿したイベント情報を表示します。
* 1ページに最大10件ずつイベントを表示します。

### イベントのソート機能

* 以下の4つの種別にもとづきソートできます。
  * Friend数
  * 新着順
  * 投稿順
  * 開催が近い順

### イベントの絞り込み機能

* Friend数のソートを選択した場合、以下の9つの時間軸の種別にもとづき絞り込みできます。
  * 過去8時間
  * 過去24時間
  * 過去2日
  * 過去3日
  * 過去4日
  * 過去5日
  * 過去6日
  * 過去1週間
  * All
* Friend数以外のソートを選択した場合、以下の4つのFriend数の種別にもとづき絞り込みできます。
  * Friends 1+
  * Friends 2+
  * Friends 3+
  * Friends 4+
  * Friends 5+

### イベント情報を投稿した友達の一覧の表示

* イベント情報を投稿した友達のアイコンを一覧を一覧表示します。

### イベントを投稿した友達のツイートの表示

* イベント情報を投稿したツイートやリツイート、引用ツイートの内容を時系列順に表示できます。

### Twitterログイン機能

* Twitterのアカウントを使ってログインできます。

# 使用技術

### フロントエンド

- Nuxt.js
  - Nuxt Compositon API
- Firebase Authentication

### バックエンド

- Ruby 3.0.0
- Rails 6.1.3
  - Rails APIモード

### アプリケーションサーバ

- Puma 5.2.2

### データベース

- PostgreSQL

### キャッシュサーバ

- Redis

### ツール

- Storybook
- Sentry
- Skylight
- OpenAPI
  - API仕様のドキュメント
  - APIのリクエスト・レスポンスのバリデーション

### インフラ

- docker-compose（開発環境）
- HerokuのDockerによるデプロイ（本番環境）
  - Nuxt.jsのコンテナー
    - Webプロセス
  - Railsのコンテナー
    - Webプロセス
    - Workerプロセス
      - Twitterのツイートやイベント収集用
- GitHub Actions
  - デプロイ
  - ReviewDog
  - Slack連携
  - 定期的なヘルスチェック
  - Lint
- Dependabot

### インフラ構成

#### 開発環境

docker-compseを使ってDockerコンテナーを起動し、Dockerコンテナーを開発環境として使用します。
開発環境のDockerコンテナーとしては、以下の4つを使用しています。

* Nuxt.js（フロントエンド）
* Rails（バックエンド）
* PostgreSQL（データベース）
* Redis（キャッシュサーバ）

![infra](docs/infra_dev.drawio.svg)

#### 本番環境

GitHubのmainブランチにコードをマージすると、GitHub Actionsを使って本番環境にデプロイを実施します。
本番環境のデプロイでは、開発環境と同じNuxt.jsとRailsのDockerコンテナーを使って、HerokuにDockerコンテナーのデプロイされます。PostgreSQLとRedisについては、HerokuのAddonを使用します。

![infra](docs/infra_prod.drawio.svg)

### ER図

![infra](docs/er.drawio.svg)

# 開発環境のセットアップ

### リポジトリのClone

```bash
$ git clone https://github.com/mh-mobile/event_follow.git
```

### 環境変数の設定

Docker起動に必要な環境変数を定義します。

| 環境変数名    | 値  |  説明 |
| --- | --- | --- |
| WORKDIR   | app | コンテナー内部のワーキングディレクト |
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

### Dockerの起動

docker-comopseを使用して、以下のコンテナーを起動します。


| コンテナー名    | 説明  |
| --- | --- |
| event_api  | Rails API（サーバ） |
| event_front  | Nuxt.js（フロント） |
| event_redis  | Redis |
| event_db  | PosgreSQL |


```bash
$ docker-compose up
```

### アプリの動作確認

Dockerの起動後に、ブラウザで[http://localhost:8080](http://localhost:8080)にアクセスします。

## 使用方法

### Railsのテスト

RSpecのテストを実行します。

```bash
$ docker exec -it event_api bin/rspec
```

### Railsのリント

Rubocopを実行します。

```bash
$ docker exec -it event_api bin/lint
```

### Nuxt.jsのテスト

jestのテストを実行します。

```bash
$ docker exec -it event_front yarn run test
```

### Nuxt.jsのフォーマット

Prettierを実行します。

```bash
$ docker exec -it event_front yarn run prettier
```

### Nuxt.jsのリント

ESLintを実行します。

```bash
$ docker exec -it event_front yarn run lint
```

自動修正を行う場合は、lint-fixを使用します。

```bash
$ docker exec -it event_front yarn run lint-fix
```

### Storybookの起動

```bash
$ docker exec -it event_front yarn run storybook
```

| ツール    | URL    |
| --- | --- |
|  Storybook  | [http://localhost:3003](http://localhost:3003)  |

### OpenAPIの起動

docker-comopseを使用して、以下のコンテナーを起動します。

| コンテナー名    | 説明   |
| --- | --- |
|  Swagger Editor  | Swagger Editorのコンテナー  |
|  Swagger UI  | Swagger UIのコンテナー  |
|  Redoc  | Redocのコンテナー |

コンテナーを起動するために、api/docsに移動し、`docker-compose up`を実行します。

```bash
$ cd api/docs
$ docker-compose up
```

| ツール    | URL    |
| --- | --- |
|  Swagger Editor  | [http://localhost:8083](http://localhost:8083)  |
|  Swagger UI  | [http://localhost:8082](http://localhost:8082)  |
|  Redoc  | [http://localhost:8081](http://localhost:8081)  |

# Author

* [Github](https://github.com/mh-mobile)
* [Qiita](https://qiita.com/mh_mobiler)
* [Twitter](https://twitter.com/mh_mobiler)

# ライセンス

本ソフトウェアは、MITライセンスの元提供されています。

