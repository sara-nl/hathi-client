hathi-client
============

This repository contains client software for the SURFsara Hadoop cluster Hathi.

At the moment it contains the HDP 2.1 versions of Hadoop and Pig.

Prerequisites
-------------

This software is tested on Linux and OSX. On Linux you need to make sure that Java 7 and the Kerberos client libraries are installed. On OSX these should already be installed. 

Debian-based Linux (Debian, Ubuntu, Mint): `apt-get install openjdk-7-jdk krb5-user`  
Enterprise Linux (Redhat, CentOS, Fedora): `yum install java-1.7.0-openjdk krb5-workstation`

Note that when using the Oracle JDK (e.g. OSX) you will need to install the Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files for your specific JVM version. For Oracle Java 7 they can be found here: [http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)

Usage
-----

`cd` to the top level directory and source the settings file for your platform:

    cd git/hathi-client && . conf/settings.linux
    cd -

(You can add these lines to your `~/.profile` so that they are run automatically on login).

Now you can authenticate using Kerberos:

    kinit USERNAME

And use the hadoop and pig utilities:

    hdfs dfs -ls /
    yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 5 5

Browser setup
-------------

In order to authenticate to the webapps you will need to use Firefox and alter the about:config (promise to be careful). Search for the key network.negotiate-auth.trusted-uris and add the value hathi.surfsara.nl.

The resource manager of the cluster: [http://head05.hathi.surfsara.nl](head05.hathi.surfsara.nl)

The namenode of the cluster: [http://namenode.hathi.surfsara.nl](namenode.hathi.surfsara.nl)


Support
-------

For more information about the SURFsara Hadoop cluster see <https://www.surfsara.nl/systems/hadoop>.
