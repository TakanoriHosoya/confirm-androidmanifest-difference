#!/bin/bash

# apk以外はエラー
if [[ $1 =~ .apk ]] ; then
	echo $1
else
	echo "error : The first file is not apk."
	exit 1
fi

if [[ $2 =~ .apk ]] ; then
	echo $2
else
	echo "error : The second file is not apk."
	exit 1
fi

# ①apkをzipに変換
zip_path1=${1%.*}.zip
zip_path2=${2%.*}.zip
cp $1 $zip_path1
cp $2 $zip_path2

echo $zip_path1
echo $zip_path2

# ②zipを解答
mkdir tmp_release_apk1
mkdir tmp_release_apk2
unzip $zip_path1 -d tmp_release_apk1
unzip $zip_path2 -d tmp_release_apk2

# ③manifestを可読化
java -jar AXMLPrinter2.jar tmp_release_apk1/AndroidManifest.xml > tmp_release_apk1/ConvertedManifest.xml
java -jar AXMLPrinter2.jar tmp_release_apk2/AndroidManifest.xml > tmp_release_apk2/ConvertedManifest.xml

# ④差分を確認
diff tmp_release_apk1/ConvertedManifest.xml tmp_release_apk2/ConvertedManifest.xml > diff.txt

open diff.txt

# ⑤お掃除
rm $zip_path1 $zip_path2 tmp_release_apk1 tmp_release_apk2