spark_krb_opts="-Djava.security.krb5.conf=${KRB5_CONFIG} -Djava.security.krb5.realm=CUA.SURFSARA.NL -Djava.security.krb5.kdc=kdc.hathi.surfsara.nl"

export SPARK_SUBMIT_OPTS="${spark_krb_opts} ${SPARK_SUBMIT_OPTS}"
export SPARK_HISTORY_OPTS="${spark_krb_opts} ${SPARK_HISTORY_OPTS}"
