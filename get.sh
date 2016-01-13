#!/bin/sh
set -e

for arg in "$@"; do
  case $arg in
    hadoop)
      pkg=hadoop-2.7.1
      url=http://www.eu.apache.org/dist/hadoop/common/hadoop-2.7.1
      ;;
    pig)
      pkg=pig-0.15.0
      url=http://www.eu.apache.org/dist/pig/pig-0.15.0
      ;;
    spark)
      pkg=spark-1.6.0
      url=http://www.eu.apache.org/dist/spark/spark-1.6.0
      ;;
    *)
      echo "unknown package $1"
      echo "usage: ./get.sh [hadoop|pig|spark]"
      exit 1
      ;;
  esac

  if [ -e $pkg ]; then
     echo "$pkg already exists, please remove manually if you wish to redownload"
     echo "skipping..."
    continue
  fi

  if [ -e $pkg.tar.gz ]; then
    echo "$pkg.tar.gz already exists, please remove manually if you wish to redownload"
    echo "using existing tarball..."
  else 
    echo "downloading $pkg"
    wget -nv  --show-progress "$url/$pkg.tar.gz"
  fi

  echo "extracting $pkg"
  tar xzf $pkg.tar.gz
  rm $pkg.tar.gz

  echo "linking SURFsara-specific configuration"
  # TODO

done
