#!/bin/bash
export ITF="/workspaces/COBOL-1/data/KJBM010I.txt"
export OTF="/workspaces/COBOL-1/src/KJBM000/KLBM010/KJBM010Icheck.txt"
# 実行　（ 実行時詳細表示 + COPY区のデータファイルパスを指定 + 実行ファイル指定 ）
# script.shの実行権限は、手入力chmod +x script.sh
ls -al /workspaces/COBOL-1/src/KJBM000/KLBM010/KJBM010.COB
chmod +x /workspaces/COBOL-1/src/KJBM000/KLBM010/KJBM010.COB
#ファイル確認処理
if [ ! -f /workspaces/COBOL/copylib/KJCF010.COB ]; then
  echo "COPYの対象ファイルなし"
  exit 1
fi
#コンパイル　　　　コピー項目の型　　　　　コンパイル作成場所　　　　　　　　　　　　　　　　　　コンパイル対象コードファイル　　　　　
cobc -x -I/workspaces/COBOL/copylib -o /workspaces/COBOL-1/src/KJBM000/KLBM010/KJBM010 /workspaces/COBOL-1/src/KJBM000/KLBM010/KJBM010.COB
# 権限追加
chmod +x /workspaces/COBOL-1/src/KJBM000/KLBM010/KJBM010
# 実行
./KJBM010
# OTF出力ファイの中身を確認
cat "$OTF"