#!/bin/sh
# script to set environment
# usage: eval $(hathi-client/bin/env.sh)
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

hathi_root="$(cd "`dirname "$0"`"/..; pwd)"

# Java
if [ -z ${JAVA_HOME} ]; then
  unamestr=$(uname)
  if [ ${unamestr} = "Darwin" ]; then
    java_home="$(/usr/libexec/java_home)"
  elif [ ${unamestr} = "Linux" ]; then
    candidates="/usr/lib/jvm/java-7-openjdk-amd64 /usr/lib/jvm/jre-1.7.0"
    for i in $candidates; do
      if [ -x "${i}/bin/java" ]; then
          java_home="${i}"
      	break
      fi
    done
    if [ -z ${java_home} ]; then
      java_bin="$(readlink -f $(which java))"
      java_home="${java_bin%/bin/java}"
    fi
  fi
  if [ -z ${java_home} ]; then
    echo "could not detect JAVA_HOME" >&2
  else
    echo export JAVA_HOME="${java_home}"
  fi
fi

# Kerberos
echo export KRB5_CONFIG="${hathi_root}/conf/krb5.conf"

# Hadoop
echo export HADOOP_HOME="${hathi_root}/hadoop"
echo export HADOOP_CONF="${hathi_root}/hadoop/etc/hadoop"
echo export HADOOP_CONF_DIR="${hathi_root}/hadoop/etc/hadoop"
echo export HADOOP_CMD="${hathi_root}/hadoop/bin/hadoop"
echo export HADOOP_STREAMING="${hathi_root}/hadoop/share/hadoop/tools/lib/hadoop-streaming-*.jar"

# Tez
echo export TEZ_CONF_DIR="${hathi_root}/conf/tez"
echo export HADOOP_CLASSPATH="${hathi_root}/conf/tez:${HADOOP_CLASSPATH}"

# Pig
echo export PIG_HOME="${hathi_root}/pig"
echo export PIG_HEAPSIZE=2048

# Spark
echo export SPARK_HOME="${hathi_root}/spark"

echo export PATH="${hathi_root}/hadoop/bin:${hathi_root}/pig/bin:${hathi_root}/spark/bin:${PATH}"
