# EXPLAIN

SELECT COUNT(*) FROM city;

EXPLAIN FORMAT = TRADITIONAL 
SELECT *
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city c2 ON c2.city_id = a.city_id
WHERE c2.city_id = 100;

EXPLAIN FORMAT = JSON
SELECT *
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city c2 ON c2.city_id = a.city_id
WHERE c2.city_id = 17;

#{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "0.70"
    },
    "nested_loop": [
      {
        "table": {
          "table_name": "c2",
          "access_type": "const",
          "possible_keys": [
            "PRIMARY"
          ],
          "key": "PRIMARY",
          "used_key_parts": [
            "city_id"
          ],
          "key_length": "2",
          "ref": [
            "const"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 1,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "0.00",
            "eval_cost": "0.10",
            "prefix_cost": "0.00",
            "data_read_per_join": "216"
          },
          "used_columns": [
            "city_id",
            "city",
            "country_id",
            "last_update"
          ]
        }
      },
      {
        "table": {
          "table_name": "a",
          "access_type": "ref",
          "possible_keys": [
            "PRIMARY",
            "idx_fk_city_id"
          ],
          "key": "idx_fk_city_id",
          "used_key_parts": [
            "city_id"
          ],
          "key_length": "2",
          "ref": [
            "const"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 1,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "0.25",
            "eval_cost": "0.10",
            "prefix_cost": "0.35",
            "data_read_per_join": "632"
          },
          "used_columns": [
            "address_id",
            "address",
            "address2",
            "district",
            "city_id",
            "postal_code",
            "phone",
            "location",
            "last_update"
          ]
        }
      },
      {
        "table": {
          "table_name": "c",
          "access_type": "ref",
          "possible_keys": [
            "idx_fk_address_id"
          ],
          "key": "idx_fk_address_id",
          "used_key_parts": [
            "address_id"
          ],
          "key_length": "2",
          "ref": [
            "sakila.a.address_id"
          ],
          "rows_examined_per_scan": 1,
          "rows_produced_per_join": 1,
          "filtered": "100.00",
          "cost_info": {
            "read_cost": "0.25",
            "eval_cost": "0.10",
            "prefix_cost": "0.70",
            "data_read_per_join": "584"
          },
          "used_columns": [
            "customer_id",
            "store_id",
            "first_name",
            "last_name",
            "email",
            "address_id",
            "active",
            "create_date",
            "last_update"
          ]
        }
      }
    ]
  }
}

EXPLAIN FORMAT = TREE
SELECT *
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city c2 ON c2.city_id = a.city_id
WHERE c2.city_id = 17;

-> Limit: 200 row(s)  (cost=0.7 rows=1)
    -> Nested loop inner join  (cost=0.7 rows=1)
        -> Index lookup on a using idx_fk_city_id (city_id=17)  (cost=0.35 rows=1)
        -> Index lookup on c using idx_fk_address_id (address_id=a.address_id)  (cost=0.35 rows=1)


# EXPLAIN ANALYZE

EXPLAIN ANALYZE
SELECT *
FROM customer c
JOIN address a ON a.address_id = c.address_id
JOIN city c2 ON c2.city_id = a.city_id
WHERE c2.city_id = 17;

EXPLAIN FORMAT = TREE
SELECT * FROM actor a
WHERE a.last_name = 'CHASE';

-> Limit: 200 row(s)  (cost=0..0 rows=1)
    -> Rows fetched before execution  (cost=0..0 rows=1)
    
-> Limit: 200 row(s)  (cost=0.7 rows=2)
    -> Index lookup on a using idx_actor_last_name (last_name='CHASE')  (cost=0.7 rows=2)

-> Limit: 200 row(s)  (cost=0.7 rows=1) (actual time=0.0284..0.0304 rows=1 loops=1)
    -> Nested loop inner join  (cost=0.7 rows=1) (actual time=0.0273..0.0292 rows=1 loops=1)
        -> Index lookup on a using idx_fk_city_id (city_id=17)  (cost=0.35 rows=1) (actual time=0.0129..0.0134 rows=1 loops=1)
        -> Index lookup on c using idx_fk_address_id (address_id=a.address_id)  (cost=0.35 rows=1) (actual time=0.013..0.0141 rows=1 loops=1)



# INDEX

DROP TABLE film_temp;

CREATE TABLE film_temp2 (
film_id INT,
title VARCHAR(50),
description TEXT,
language_id INT,
release_year INT
);

INSERT INTO film_temp2
SELECT film_id, title, description, language_id, release_year FROM film;

SELECT *
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_NAME='film_temp';

SELECT COUNT(*) FROM film_temp ft;

EXPLAIN FORMAT = TREE
SELECT *
FROM film_temp
WHERE film_id = 100;

-> Limit: 200 row(s)  (cost=103 rows=100)
    -> Filter: (film_temp.film_id = 100)  (cost=103 rows=100)
        -> Table scan on film_temp  (cost=103 rows=1000)


EXPLAIN ANALYZE
SELECT *
FROM film_temp
WHERE film_id = 999;

# cost=103 rows=1000 без PK
# cost=0..0 rows=1 с PK

ALTER TABLE film_temp DROP PRIMARY KEY;
ALTER TABLE film_temp ADD PRIMARY KEY (film_id);

UPDATE film_temp
SET release_year = 2005
WHERE film_id <= 500;

EXPLAIN ANALYZE
SELECT *
FROM film_temp
WHERE language_id = 1 AND release_year = 2006;

-> Limit: 200 row(s)  (cost=103 rows=10) (actual time=0.204..0.287 rows=200 loops=1)
    -> Filter: ((film_temp.release_year = 2006) and (film_temp.language_id = 1))  (cost=103 rows=10) (actual time=0.203..0.277 rows=200 loops=1)
        -> Table scan on film_temp  (cost=103 rows=1000) (actual time=0.0322..0.247 rows=700 loops=1)
        
-> Limit: 200 row(s)  (cost=59 rows=200) (actual time=0.0516..0.344 rows=200 loops=1)
    -> Index lookup on film_temp using lang_year (language_id=1, release_year=2006)  (cost=59 rows=500) (actual time=0.0498..0.334 rows=200 loops=1)


CREATE INDEX lang_year ON film_temp(language_id, release_year);

SELECT *
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_NAME='film_temp2';

EXPLAIN
SELECT *
FROM film_temp
WHERE language_id = 1 AND release_year = 2006;

EXPLAIN ANALYZE
SELECT *
FROM film_temp
WHERE language_id = 1 AND release_year = 2006;

SELECT film_id, description
FROM film
LIMIT 3;

ALTER TABLE film_temp DROP PRIMARY KEY;

DROP INDEX lang_year ON film_temp;

SELECT COUNT(*) FROM film_temp2;

SELECT table_name, data_length, index_length
FROM INFORMATION_SCHEMA.TABLES
WHERE table_name = "film_temp2";

DROP TABLE film_temp2;

ALTER TABLE film_temp2 ADD PRIMARY KEY (film_id);

CREATE INDEX lang_year ON film_temp(language_id, release_year);
CREATE INDEX title ON film_temp(title);

SELECT table_name, data_length, index_length
FROM INFORMATION_SCHEMA.TABLES
WHERE table_name = "film_temp";

SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE table_name = "film_temp";

USE sakila;

CREATE TABLE actor_temp (
  actor_id SMALLINT,
  first_name VARCHAR(45),
  last_name VARCHAR(45)
)

INSERT INTO actor_temp
SELECT actor_id, first_name, last_name
FROM actor;

SELECT * from actor_temp
LIMIT 10;

ALTER TABLE actor_temp ADD PRIMARY KEY (actor_id);
CREATE INDEX fio ON actor_temp(first_name, last_name);

SELECT table_name, data_length, index_length
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'sakila';





