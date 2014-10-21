createHerokuFuelApp
===================

FuelPHPのプロジェクトを作ってHerokuに公開するシェルスクリプト。

## 使い方
------
```
./createHerokuFuelApp.sh [アプリ名]
```

※herokuのアプリ名は大文字、アンダースコアなどには対応していません。

## 事前準備
------
下記のツールを事前にインストールしておく必要があります。
###FuelPHP oilコマンド
```
$ curl get.fuelphp.com/oil | sh
```

### Heroku Toolbelt 
ここからインストール
https://toolbelt.heroku.com/
