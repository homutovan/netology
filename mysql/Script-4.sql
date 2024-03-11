USE sakila;

SELECT  * FROM actor;

SELECT last_name FROM actor;

SELECT actor_id, first_name, last_name FROM actor;

SELECT first_name, last_name 
FROM actor
WHERE (last_name = 'DAVIS') and (first_name = 'ZERO');

SELECT f.title, c.name, f.rental_rate/f.rental_duration AS cost_per_day
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc. category_id
where f.rental_rate/f.rental_duration < 1;

SELECT title, rental_rate/rental_duration AS ertqert
FROM film
ORDER BY ertqert;

SELECT *
FROM actor a
ORDER BY last_name DESC;

SELECT title, rental_duration, rental_rate, rental_rate/rental_duration AS cost_per_day 
FROM film f
ORDER BY cost_per_day;

SELECT title, rental_rate/rental_duration AS cost_per_day
FROM film
ORDER BY cost_per_day, title
LIMIT 10;

SELECT title, rental_rate/rental_duration AS cost_per_day
FROM film
ORDER BY cost_per_day DESC, title
LIMIT 10
OFFSET 150;

SELECT DISTINCT first_name FROM actor;

SELECT DISTINCT staff_id FROM payment p;

SELECT staff_id, amount, payment_date
FROM payment
WHERE (amount > 7 AND staff_id = 2)
ORDER BY staff_id DESC;

SELECT 
payment_id, 
payment_date, 
CAST(payment_date AS DATE) AS convert_data,
CAST(CAST(payment_date AS DATE) AS DATETIME) AS convert_data_2
FROM payment;

SELECT title, rental_rate/rental_duration AS cost_per_day, 
ROUND(rental_rate/rental_duration, 2) AS round_cost_per_day
FROM film
ORDER BY cost_per_day DESC, title;

# math

SELECT rental_rate, rental_duration,
rental_rate + rental_duration a,
rental_rate - rental_duration b,
rental_rate * rental_duration c,
rental_rate / rental_duration d,
rental_rate % rental_duration e,
rental_rate DIV rental_duration f,
POWER(rental_rate, rental_duration) g,
COS(rental_rate) h, SIN(rental_duration) j, TAN(rental_rate) k
FROM film;

SELECT COS(2 * 3.141);

#string

SELECT CONCAT(last_name, ' ', first_name, ' ', email) FROM customer;
SELECT CONCAT_WS('-', last_name, first_name, email) FROM customer;
SELECT CONCAT(last_name, first_name, email) AS _concat, CONCAT_WS('-', last_name, first_name, email) AS concat_ws FROM customer;

SELECT LENGTH(last_name), CHAR_LENGTH(last_name),
LENGTH('Привет'), CHAR_LENGTH('Привет'), CHAR_LENGTH('Пока')
FROM customer;

SELECT last_name, 
POSITION('D' IN last_name), 
SUBSTR(last_name, 2, 3),
LEFT(last_name, 3), RIGHT(last_name, 3)
FROM customer;

SELECT CONCAT(last_name, ' ', first_name)
FROM customer
WHERE first_name LIKE 'john%';

# DATETIME

SELECT NOW(), DATE_ADD(NOW(), INTERVAL 7 MONTH);

SELECT DATE_SUB(CURDATE(), INTERVAL 3 DAY);

SELECT YEAR(NOW()), MONTH(NOW()), WEEK(NOW()), DAY(NOW()), QUARTER(NOW());

SELECT * FROM payment WHERE amount BETWEEN 4 AND 5;

SELECT * FROM payment 
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-30'
ORDER BY payment_date DESC;

SELECT COUNT(email)  FROM customer c; 
SELECT email FROM customer c;

SELECT email, 
#CHAR_LENGTH(email) as 'length', 
#POSITION('@' IN email) as 'position', 
LEFT(email, POSITION('@' IN email) - 1) AS login,
RIGHT(email, CHAR_LENGTH(email) - POSITION('@' IN email)) as domen
FROM customer c;




