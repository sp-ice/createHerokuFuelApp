#!/bin/bash

if [ $# -ne 1 ]; then
  echo "作成するアプリ名を指定して下さい" 1>&2
  echo "_createHerokuFuelApp.sh [appName]" 1>&2
  exit 1
fi

if [[ "$1" =~ [A-Z]|_ ]]; then
    # expr "$1" : "/.*[A-Z]+.*/" > /dev/null; then
    echo "アプリ名に大文字、アンダースコアは使用できません。" 1>&2
    echo "_createHerokuFuelApp.sh [appName]" 1>&2
    exit 1
fi

# fuelphpプロジェクト作成
oil create $1
oil refine install #必要なディレクトリを書き込み可能に
cd $1

# fuelphp git管理に不要なファイルを削除
rm -rf .git .gitmodules *.md docs fuel/core fuel/packages

# herokuアプリ作成
git init
heroku create $1

# gitサブモジュール追加
git submodule add git://github.com/fuel/core.git fuel/core
git submodule add git://github.com/fuel/oil.git fuel/packages/oil
git submodule add git://github.com/fuel/auth.git fuel/packages/auth
git submodule add git://github.com/fuel/parser.git fuel/packages/parser
git submodule add git://github.com/fuel/orm.git fuel/packages/orm
git submodule add git://github.com/fuel/email.git fuel/packages/email

# 設定ファイル変更
ed - .gitignore << END
%s/\/composer.lock/#\/composer.lock/g
w
END
ed - composer.json << END
%s/"vendor-dir": "fuel\/vendor"/"bin-dir": "vendor\/bin", "vendor-dir": "fuel\/vendor"/g
w
END

# 設定ファイル作成
echo -n > Procfile
echo "web: vendor/bin/heroku-php-apache2 public/" >> Procfile

# deploy
git add -A
git commit -m "first commit"
git push heroku master

# open
heroku open