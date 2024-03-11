USE sakila;


# INNER JOIN

# SELECT COUNT(1)
SELECT f.title, CONCAT(a.last_name, ' ', a.first_name) AS actor_name
FROM film f
INNER JOIN film_actor fa ON fa.film_id = f.film_id
INNER JOIN actor a ON a.actor_id = fa.actor_id;

SELECT * FROM actor a
LIMIT 1;

SELECT COUNT(f.title) 
FROM film f 
JOIN film_actor fa ON fa.film_id = f.film_id 
JOIN actor a ON a.actor_id = fa.actor_id
WHERE a.first_name = 'PENELOPE' AND a.last_name = 'GUINESS';

SELECT f.title, CONCAT(a.last_name, ' ', a.first_name) AS actor_name
FROM film f
INNER JOIN film_actor fa ON fa.film_id = f.film_id
INNER JOIN actor a ON a.actor_id = fa.actor_id;


# LEFT JOIN

SELECT CONCAT(c.last_name, ' ', c.first_name), c2.city
FROM customer c
LEFT JOIN address a ON a.address_id = c.address_id
LEFT JOIN city c2 ON c2.city_id = a.city_id
WHERE NOT c2.city = NULL;

SELECT f.title
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_id IS NULL;


# RIGHT JOIN

# SELECT CONCAT(c.last_name, ' ', c.first_name), c2.city
SELECT c.last_name, c.first_name, c2.city
FROM customer c
RIGHT JOIN address a ON a.address_id = c.address_id
RIGHT JOIN city c2 ON c2.city_id = a.city_id;


# FULL JOIN

SELECT r.rental_id, r.rental_date, p.payment_id, p.payment_date, p.amount
FROM rental r
FULL JOIN payment p ON p.rental_id = r.rental_id


SELECT r.rental_id, r.rental_date, p.payment_id, p.payment_date, p.amount
FROM rental r
FULL JOIN payment p ON p.rental_id = r.rental_id
WHERE r.rental_id IS NULL OR p.payment_id IS NULL;


SELECT r.rental_id, r.rental_date, p.payment_id, p.payment_date, p.amount
#SELECT COUNT(1)
FROM rental r
LEFT JOIN payment p ON p.rental_id = r.rental_id
WHERE p.payment_id < 10
union
SELECT r.rental_id, r.rental_date, p.payment_id, p.payment_date, p.amount
# SELECT COUNT(1)
FROM rental r
RIGHT JOIN payment p ON p.rental_id = r.rental_id
WHERE p.payment_id > 10 AND p.payment_id < 20;

SELECT r.rental_id, r.rental_date, p.payment_id, p.payment_date, p.amount
FROM rental r
LEFT JOIN payment p ON p.rental_id = r.rental_id
UNION
SELECT r.rental_id, r.rental_date, p.payment_id, p.payment_date, p.amount
FROM rental r
RIGHT JOIN payment p ON p.rental_id = r.rental_id;


# CROSS JOI

SELECT c.city, c2.city
FROM city c
CROSS JOIN city c2
WHERE c.city > c2.city;

CREATE TABLE table_vlaues1 (
value1 VARCHAR(10) NOT NULL
);
CREATE TABLE table_vlaues2 (
value2 VARCHAR(10) NOT NULL
);

INSERT INTO table_1
VALUES('val_t1_1'), ('val_t1_2');

INSERT INTO table_2
VALUES('val_t2_1'), ('val_t2_2');


# UNION

CREATE TABLE table_1 (
color_1 VARCHAR(10) NOT NULL
);
CREATE TABLE table_2 (
color_2 VARCHAR(10) NOT NULL
);
INSERT INTO table_1
VALUES('white'), ('black'), ('red'), ('green');
INSERT INTO table_2
VALUES('black'), ('yellow'), ('blue'), ('red');

SELECT color_1 FROM table_1
UNION
SELECT color_2 FROM table_2;

SELECT color_1 FROM table_1
UNION ALL
SELECT color_2 FROM table_2;


# EXCEPT

SELECT color_1 FROM table_1
EXCEPT
SELECT color_2 FROM table_2;


# COUNT

SELECT COUNT(1)
FROM film
WHERE LOWER(LEFT(title, 1)) = 'a';

SELECT customer_id, COUNT(payment_id), SUM(amount),
AVG(amount), MIN(amount), MAX(amount)
FROM payment
GROUP BY customer_id;


# GROUP BY

SELECT customer_id, MONTH(payment_date), COUNT(payment_id), SUM(amount)
FROM payment
GROUP BY customer_id, MONTH(payment_date);

SELECT f.title, f.release_year, f.length, COUNT(fa.actor_id)
FROM film f
JOIN film_actor fa ON fa.film_id = f.film_id
GROUP BY f.film_id;


# HAVING

SELECT CONCAT(c.last_name, ' ', c.first_name), COUNT(r.rental_id)
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 40;


# SUB QUERY

SELECT MONTH(payment_date),
COUNT(payment_id) / (SELECT COUNT(1) FROM payment) * 100
FROM payment
GROUP BY MONTH(payment_date);

SELECT f.title, c.name
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.category_id IN (
SELECT category_id
FROM category
WHERE name LIKE 'C%')
ORDER BY f.title;

SELECT CONCAT(s.last_name, ' ', s.first_name), cp / cr
FROM staff s
JOIN (
SELECT staff_id, COUNT(payment_id) AS cp
FROM payment
GROUP BY staff_id) t1 ON s.staff_id = t1.staff_id
JOIN (
SELECT staff_id, COUNT(rental_id) AS cr
FROM rental
GROUP BY staff_id) t2 ON s.staff_id = t2.staff_id;


# CASE

SELECT customer_id, SUM(amount),
CASE
WHEN SUM(amount) > 200 THEN 'Good user'
WHEN SUM(amount) < 200 THEN 'Bad user'
ELSE 'Average user'
END AS good_or_bad
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5;


# IFNULL

SELECT CONCAT(c.last_name, ' ', c.first_name) AS user,
IFNULL(SUM(p.amount), 0)
FROM customer c
LEFT JOIN (
SELECT *
FROM payment
WHERE DATE(payment_date) = '2005-06-18') p
ON p.customer_id = c.customer_id
GROUP BY c.customer_id;


# COALESCE

SELECT rental_id,
COALESCE(DATEDIFF(return_date, rental_date), DATEDIFF(NOW(), return_date),
DATEDIFF(NOW(), rental_date)) AS diff
FROM rental;




