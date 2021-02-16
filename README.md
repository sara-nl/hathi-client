hathi-client
============
**Deprecation notice: the SURFsara Hadoop cluster Hathi has been decommissioned. This repository is archived, but will remain available for reference purposes.**

This repository contains client configuration for the SURFsara Hadoop cluster
Hathi. At the moment it contains configuration for Hadoop 2.7.2, Pig 0.16.0
and Spark 2.1.1.

Prerequisites
-------------
This software is tested on Linux and OSX. On Linux you need to make sure that
Git, Java 7 and the Kerberos client libraries are installed. **On OSX these
should already be installed.**

Debian-based Linux (Debian, Ubuntu, Mint):

    > apt-get install git openjdk-7-jre-headless krb5-user

Enterprise Linux (Redhat, CentOS, Fedora):

    > yum install git java-1.7.0-openjdk krb5-workstation

Note that when using the Oracle JDK (e.g. OSX) you will need to install the
Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files
for your specific JVM version.

For Oracle Java 7 they can be found here:
<http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html>

For Oracle Java 8:
<http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html>

If using a JDK, please make sure to install the extension's .jar files inside the
`$JAVA_HOME/jre/lib` directory rather than the JDK's lib directory `$JAVA_HOME/lib`.

Usage
-----

The first time you need to download the official Hadoop/Pig/Spark software from
Apache and put the SURFsara configuration in the right location. We provide a
helper script that will do this automatically:

```
> git clone --depth 1 https://github.com/sara-nl/hathi-client
> /path/to/hathi-client/bin/get.sh hadoop
> /path/to/hathi-client/bin/get.sh pig
> /path/to/hathi-client/bin/get.sh spark
```

Whenever you want to use the cluster you need to perform the following once per
session.

1) Setup the environment:
```
> eval $(/path/to/hathi-client/bin/env.sh)
```
(You can add this line to your `~/.profile` so that it is run automatically on
login).

2) Now you can authenticate using Kerberos:
```
> kinit <USERNAME>
```

And use the Hadoop, Pig and Spark utilities:
```
> hdfs dfs -ls /

> yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 5 5

> spark-submit --class org.apache.spark.examples.SparkPi \
                 --master yarn  --deploy-mode cluster \
                 $SPARK_HOME/examples/jars/spark-examples_2.11-2.1.1.jar 10
```
Browser setup
-------------

In order to authenticate to the webapps you will need to use Firefox and alter
the about:config (promise to be careful). Search for the key
`network.negotiate-auth.trusted-uris` and add the value `hathi.surfsara.nl`.

In addition, Firefox needs to be aware of the Kerberos setup. For this the
Kerberos configuration `conf/krb5.conf` needs to be placed in the right
location (you will need root access for this). Note that if you work with
different Kerberos realms you can also add the KDC configuration (the
`[realms]` section) from the hathi-client file to any existing Kerberos
configuration file. To copy (and overwrite any existing files) the
configuration to the correct location:

For OSX:

    > cp git/hathi-client/conf/krb5.conf $HOME/Library/Preferences/edu.mit.Kerberos

For Linux:

    > sudo cp git/hathi-client/conf/krb5.conf /etc/

The resource manager of the cluster can then be found at
<http://head05.hathi.surfsara.nl>.

The namenode of the cluster is located at <http://head02.hathi.surfsara.nl>.

Support
-------

For more information about the SURFsara Hadoop cluster see
<https://userinfo.surfsara.nl/systems/hadoop>.

For any questions using Hadoop at SURFsara contact the [SURFsara
helpdesk](mailto:helpdesk@surfsara.nl?subject=Help%20with%20Hadoop%20hathi-client).

License
-------

Copyright 2014 SURFsara BV

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
