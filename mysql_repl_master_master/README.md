# Master-slave replication

## Master-master

### Master-1

create user 'repl'@'%' identified by 'pass';
grant replication slave on *.* to 'repl'@'%';
show grants for repl@'%';

show master status;

CHANGE MASTER TO 
MASTER_HOST = 'master-2', 
MASTER_USER ='repl', 
MASTER_PASSWORD = 'pass', 
MASTER_LOG_FILE = 'mysql-bin.000003', 
MASTER_LOG_POS = 660;

start slave;

create database test1;

show databases;


### Master-2

create user 'repl'@'%' identified by 'pass';
grant replication slave on *.* to 'repl'@'%';
show grants for repl@'%';

show master status;

CHANGE MASTER TO 
MASTER_HOST = 'master-1', 
MASTER_USER ='repl', 
MASTER_PASSWORD = 'pass', 
MASTER_LOG_FILE = 'mysql-bin.000003', 
MASTER_LOG_POS = 660;

start slave;

