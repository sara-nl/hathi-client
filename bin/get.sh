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
  pkg=hadoop-"$hadoop_version"
  url=http://www.eu.apache.org/dist/hadoop/common/"$pkg"
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
  echo "linking config for $pkg"
  mv $pkg/etc/hadoop $pkg/etc/hadoop.default
  ln -s ../../conf/hadoop $pkg/etc/hadoop
}

get_pig() {
  pkg=pig-"$pig_version"
  url=http://www.eu.apache.org/dist/pig/"$pkg"
  tar="$pkg.tar.gz"
  fetch "$url" "$pkg" "$tar"
}

get_spark() {
  url=http://www.eu.apache.org/dist/spark/spark-"$spark_version"
  pkg=spark-"$spark_version"-bin-hadoop2.6
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
. bin/versions

if [[ $# -eq 0 ]] ; then
  usage
fi

for arg in "$@"; do
  case $arg in
    hadoop) get_hadoop ;;
       pig) get_pig    ;;
     spark) get_spark  ;;
        *)  usage      ;;
  esac
done
