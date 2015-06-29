FROM centos:centos7

# Pre-requirements
RUN yum install -y libaio bc; \
    yum clean all

# Install Oracle XE
ADD rpm/oracle-xe-11.2.0-1.0.x86_64.rpm.tar.gz /tmp/
RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm;
RUN yum install wget -y;
ADD config/start.sh /
RUN adduser oracle
RUN groupadd dba
# Configure instance
ADD config/xe.rsp config/init.ora config/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/
RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chmod 755        /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                      u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chown -R oracle:dba /u01/app/oracle
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora
RUN /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# Run script
CMD /start.sh

EXPOSE 1521
EXPOSE 8081
