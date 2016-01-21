#!/bin/sh

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
    wget -nv  --show-progress "$url/$tar"
  fi

  echo "extracting $pkg"
  tar xzf $tar
  rm $tar
}

get_hadoop() {
  url=http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.1
  pkg=hadoop-2.7.1
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
  echo "linking config for $pkg"
  mv $pkg/etc/hadoop $pkg/etc/hadoop.default
  ln -s ../../conf/hadoop $pkg/etc/hadoop
}

get_pig() {
  url=http://www.eu.apache.org/dist/pig/pig-0.15.0
  pkg=pig-0.15.0
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
}

get_spark() {
  url=http://www.eu.apache.org/dist/spark/spark-1.6.0
  pkg=spark-1.6.0-bin-hadoop2.6
  tar="$pkg.tgz"
  fetch "$url" "$pkg" "$tar"
  echo "linking config for $pkg"
  mv $pkg/conf $pkg/conf.default
  ln -s ../conf/spark $pkg/conf
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
