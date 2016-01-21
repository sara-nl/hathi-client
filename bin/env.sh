# Usage: eval $(hathi-client/bin/set-env.sh)

hathi_root="$(cd "`dirname "$0"`"/..; pwd)"
hadoop_version="2.7.1"
pig_version="0.15.0"
spark_version="1.6.0" 

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
echo export HADOOP_HOME="${hathi_root}/hadoop-${hadoop_version}"
echo export HADOOP_CONF="${hathi_root}/hadoop-${hadoop_version}/etc/hadoop"
echo export HADOOP_CONF_DIR="${hathi_root}/hadoop-${hadoop_version}/etc/hadoop"
echo export HADOOP_CMD="${hathi_root}/hadoop-${hadoop_version}/bin/hadoop"
echo export HADOOP_STREAMING="${hathi_root}/hadoop-${hadoop_version}/share/hadoop/tools/lib/hadoop-streaming-${hadoop_version}.jar"

# Tez
echo export TEZ_CONF_DIR="${hathi_root}/conf/tez"
echo export HADOOP_CLASSPATH="${hathi_root}/conf/tez:${HADOOP_CLASSPATH}"

# Pig
echo export PIG_HOME="${hathi_root}/pig-${pig_version}"
echo export PIG_HEAPSIZE=2048

# Spark
echo export SPARK_HOME="${hathi_root}/spark-${spark_version}-bin-hadoop2.6"

echo export PATH="${hathi_root}/hadoop-${hadoop_version}/bin:${hathi_root}/pig-${pig_version}/bin:${hathi_root}/spark-${spark_version}-bin-hadoop2.6/bin:${PATH}"
