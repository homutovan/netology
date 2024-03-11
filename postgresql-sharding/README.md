# postgresql-sharding
PostgreSQL sharding example

### Setup the first shard

docker exec -it postgres_b1 psql -U postgres -d books -f /scripts/shards.sql -a


### Setup the second shard

docker exec -it postgres_b2 psql -U postgres -d books -f /scripts/shards.sql -a

docker exec -it postgres_b2 psql -U postgres -d books -c "select * from books"

### Setup the third shard

docker exec -it postgres_b3 psql -U postgres -d books -f /scripts/shards.sql -a

docker exec -it postgres_b3 psql -U postgres -d books -c "select * from books"

### Setup the main server

docker exec -it postgres_b psql -U postgres -d books -f /scripts/shards.sql -a

docker exec -it postgres_b psql -U postgres -d books -c "select * from books"

### Check shards after inserting

docker exec -it postgres_b1 psql -U postgres -d books -c "select * from books"

docker exec -it postgres_b2 psql -U postgres -d books -c "select * from books"

docker exec -it postgres_b3 psql -U postgres -d books -c "select * from books"

### Test insert performance with sharding

docker exec -it postgres_b psql -U postgres -d books -c '\timing' -f /scripts/seed.sql
