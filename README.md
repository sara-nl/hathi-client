hathi-client
============

This repository contains client software for the SURFsara Hadoop cluster Hathi.

At the moment it contains Hadoop 2.6.0 and Pig 0.14.0.

Prerequisites
-------------

This software is tested on Linux and OSX. On Linux you need to make sure that
Java 7 and the Kerberos client libraries are installed. On OSX these should
already be installed.

Debian-based Linux (Debian, Ubuntu, Mint): `apt-get install openjdk-7-jdk
krb5-user`
Enterprise Linux (Redhat, CentOS, Fedora): `yum install java-1.7.0-openjdk
krb5-workstation`

Note that when using the Oracle JDK (e.g. OSX) you will need to install the
Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files
for your specific JVM version. For Oracle Java 7 they can be found here:
[http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)

Usage
-----

`cd` to the top level directory and source the settings file for your platform:

    cd git/hathi-client && . conf/settings.linux
    cd -

(You can add these lines to your `~/.profile` so that they are run
automatically on login).

Now you can authenticate using Kerberos:

    kinit USERNAME

And use the hadoop and pig utilities:

    hdfs dfs -ls /
    yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar pi 5 5

Browser setup
-------------

In order to authenticate to the webapps you will need to use Firefox and alter
the about:config (promise to be careful). Search for the key
`network.negotiate-auth.trusted-uris` and add the value `hathi.surfsara.nl`.

In addition, Firefox needs to be aware of the Kerberos setup. For this the
Kerberos configuration `conf/krb5.conf` needs to be placed in the right
location (you will need root access for this). Note that if you work with
different Kerberos realms you can also add the kdc configuration (the [realms]
section) from the hathi-client file to any existing Kerberos configuration
file. To copy (and overwrite any existing files) the configuration to the
correct location:

For OSX:

    sudo cp git/hathi-client/conf/krb5.conf $HOME/Library/Preferences/edu.mit.Kerberos
	
For Linux:

    sudo cp git/hathi-client/conf/krb5.conf /etc/

The resource manager of the cluster can then be found here:
[http://head05.hathi.surfsara.nl](http://head05.hathi.surfsara.nl)

The namenode of the cluster is located here:
[http://namenode.hathi.surfsara.nl](http://namenode.hathi.surfsara.nl)


Support
-------

For more information about the SURFsara Hadoop cluster see
<https://www.surfsara.nl/systems/hadoop>.

For any questions using Hadoop on the SURFsara cluster contact:
[helpdesk@surfsara.nl](mailto:helpdesk@surfsara.nl?subject=Help with Hadoop
 hathi-client).
