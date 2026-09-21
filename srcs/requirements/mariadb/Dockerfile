FROM debian:bullseye

RUN apt update -y && apt upgrade -y && \
    apt install -y mariadb-server

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql
    
COPY tools/init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

COPY conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306

WORKDIR /usr/bin/

# Remove the conflicting CMD
ENTRYPOINT ["/usr/bin/init.sh"]