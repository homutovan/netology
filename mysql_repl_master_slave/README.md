# Master-slave replication

## Master-slave

### Master

CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'slaverepl';

GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

SHOW GRANTS FOR repl@'%';

SHOW MASTER STATUS;

### Slave

CHANGE MASTER TO
MASTER_HOST='mysql-master',
MASTER_USER='repl',
MASTER_PASSWORD='slaverepl',
MASTER_LOG_FILE='mysql-bin.000003',
MASTER_LOG_POS=660;

START SLAVE;

SHOW SLAVE STATUS\G;

## Master-master