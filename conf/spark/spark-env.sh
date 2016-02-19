spark_opts="-Djava.security.krb5.conf=${KRB5_CONFIG} -Djava.security.krb5.realm=CUA.SURFSARA.NL -Djava.security.krb5.kdc=kdc.hathi.surfsara.nl -Dscala.usejavacp=true"

export SPARK_SUBMIT_OPTS="${spark_opts}"
export SPARK_HISTORY_OPTS="${spark_opts}"
