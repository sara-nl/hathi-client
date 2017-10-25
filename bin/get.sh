#!/bin/sh
# script to download upstream client packages
# usage: hathi-client/bin/get.sh [hadoop|pig|spark]
#
# Copyright 2016 SURFsara BV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

fetch() {
  echo "fetching $pkg"
  url=$1
  pkg=$2
  tar=$3

  if [ -e $pkg ]; then
    echo "$pkg already exists, please remove manually if you wish to redownload"
    echo "skipping..."
    continue
  fi

  if [ -e $tar ]; then
    echo "$tar already exists, please remove manually if you wish to redownload"
    echo "using existing tarball..."
  else
    echo "downloading $pgk"
    wget -nv "$url/$tar"
  fi

  echo "extracting $pkg"
  tar xzf $tar
  rm $tar
}

get_hadoop() {
  version=2.7.2
  url=https://archive.apache.org/dist/hadoop/common/hadoop-$version
  pkg=hadoop-$version
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
  echo "linking config for $pkg"
  mv $pkg/etc/hadoop $pkg/etc/hadoop.default
  ln -s ../../conf/hadoop $pkg/etc/hadoop
  rm -f hadoop >/dev/null
  ln -s $pkg hadoop
}

get_pig() {
  version=0.16.0
  url=http://www.eu.apache.org/dist/pig/pig-$version
  pkg=pig-$version
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
  rm -f pig >/dev/null
  ln -s $pkg pig
}

get_spark() {
  version=2.1.1
  url=http://archive.apache.org/dist/spark/spark-$version
  pkg=spark-$version-bin-without-hadoop
  tar="$pkg.tgz"
  fetch "$url" "$pkg" "$tar"
  echo "linking config for $pkg"
  mv $pkg/conf $pkg/conf.default
  ln -s ../conf/spark $pkg/conf
  rm -f spark >/dev/null
  ln -s $pkg spark
}

usage() {
  echo "no or unknown package $1"
  echo "usage: $0 [hadoop|pig|spark]"
  exit 1
}

cd "$(dirname "$0")"/..

for arg in "$@"; do
  case $arg in
    hadoop) get_hadoop ;;
       pig) get_pig    ;;
     spark) get_spark  ;;
        *)  usage      ;;
  esac
done
