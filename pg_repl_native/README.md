# Postgres replication

## Master

createuser --replication -P repluser

## Slave

pg_basebackup --host=psql1 --username=repluser --pgdata=/var/lib/postgresql/data --wal-method=stream --write-recovery-conf

select * from pg_stat_replication;
select * from pg_stat_wal_receiver;