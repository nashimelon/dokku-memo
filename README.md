# dokkuセットアップ手順
Heroku互換オープンソフトウェア[dokku](https://github.com/dokku/dokku)のセットアップ手順です。

## 確認した環境
  - VPS: conoha
  - サーバメモリ: 1GB
  - OS: Ubuntu 16.04 (64bit)

## SSH接続の確認
サーバ構築時に設定したパスワードを用意して、SSH接続できるか確認してください。
```shell
ssh root@<IPアドレス> -p 22
```

## ubuntuのアップデート
ubuntuを最新の状態にします。質問が表示された時は「Yキー」または「enterキー」を押下してください。
```shell
sudo apt update
sudo apt dist-upgrade
sudo apt autoremove
```

## dokkuのインストール
ホスト名を設定します。
```shell
sed -i -e "s/localhost/`hostname`/g" /etc/hosts
```

dokkuをインストールします。
```shell
wget https://raw.githubusercontent.com/dokku/dokku/v0.11.2/bootstrap.sh
sudo dokku_TAG=v0.11.2 bash bootstrap.sh
```

## rootログイン禁止の設定
dokkuインストール時にdokkuユーザが作成されています。セキュリティ強化のため、dokkuユーザをログインできるようにして、rootユーザをログインできないようにします。
```shell
mkdir -p /home/dokku/.ssh
cp /root/.ssh/authorized_keys /home/dokku/.ssh/authorized_keys
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
sudo service sshd restart
```

## dokkuの設定
http://<IPアドレス> にアクセスして、ブラウザ上で初期設定を行います。

  - Public Key
```shell
  gitで使う公開鍵(SSHサーバーの公開鍵)を入力してください。サーバ構築時に設定している場合、入力済みになっていることもあります。
```

  - Hostname
```shell
  ドメインを入力してください。ドメインを持っていない場合、<IPアドレス>.xip.io を入力してください。
```

  - Use virtualhost naming for apps
```shell
  チェックしてください。
```

入力が完了したら、最後に一番下のボタンを押下します。ここからは、dokkuユーザでログインして操作してください。タイムゾーンと言語を日本向けに設定します。

```shell
dokku config:set --global TZ="Asia/Tokyo"
dokku config:set --global LANG="ja_JP.UTF-8"
```

## dokkuプラグインのインストール

### mysql
データベースのMySQLをインストールします。

```shell
sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git
```

### postgres
データベースのMySQLをインストールします。

```shell
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
```

### logspout
ログを管理するためのプラグインをインストールします。

```shell
sudo dokku plugin:install https://github.com/michaelshobbs/dokku-logspout.git
```

Papertrailとの連携設定は
[Shipping dokku logs with Logspout to Papertrail](https://ashleyconnor.co.uk/2016/10/23/shipping-dokku-logs-with-logspout-to-papertrail.html)を参照してください。

## データベースの作成
mysqlを使う場合のデータベース作成例です。データベースの接続方法が表示されます。この表示内容を確認して、あなたが作成したWebアプリのデータベース接続設定を書き換えてください。

```shell
dokku mysql:create <アプリ名>
```

## Webアプリの公開
dokkuアプリを作成します。
```shell
dokku apps:create <アプリ名>
```

Webアプリを格納したディレクトリに移動して、gitレポジトリ作成とサーバ登録を行ってください。git push コマンド実行中に強制終了させないように気をつけてください。

```shell
git init
git add .
git commit -m "initial commit"
git remote add dokku dokku@<ホスト名 or IPアドレス>:<アプリ名>
git push -v -f dokku master
```

## TIPS
- アプリの再起動
```shell
dokku ps:restart <アプリ名>
```

- アプリのログ表示　
```shell
dokku logs <アプリ名> -t
```

- 全アプリの表示
```shell
dokku apps:list
```
