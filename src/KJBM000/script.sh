#!/bin/bash
# 実行　（ 実行時詳細表示 + COPY区のデータファイルパスを指定 + 実行ファイル指定 ）
# script.shの実行権限は、手入力chmod +x script.sh
ls -al KJBM010/KJBM010.COB
chmod +x KJBM010/KJBM010.COB
#ファイル確認処理
if [ ! -f /workspaces/COBOL/copylib/KJCF010.COB ]; then
  echo "COPYの対象ファイルなし"
  exit 1
fi
cobc -x -v -I/workspaces/COBOL/copylib -o KJBM010 KJBM010/KJBM010.COB
# 権限追加
chmod +x KJBM010/KJBM010
# 実行
./KJBM010
# OTF出力ファイの中身を確認
cat OTF