#!/bin/sh
# script to download upstream client packages
# usage: hathi-client/bin/get.sh [hadoop|pig|spark]

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
  version=2.7.1
  url=http://www.eu.apache.org/dist/hadoop/common/hadoop-$version
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
  version=0.15.0
  url=http://www.eu.apache.org/dist/pig/pig-$version
  pkg=pig-$version
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
  rm -f pig >/dev/null
  ln -s $pkg pig
}

get_spark() {
  version=1.6.1
  url=http://www.eu.apache.org/dist/spark/spark-$version
  pkg=spark-$version-bin-hadoop2.6
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
