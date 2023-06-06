USE sakila ;

#In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:
delimiter //
CREATE PROCEDURE get_customers_action()
BEGIN
	SELECT first_name, last_name, email
	  FROM customer
	  JOIN rental ON customer.customer_id = rental.customer_id
	  JOIN inventory ON rental.inventory_id = inventory.inventory_id
	  JOIN film ON film.film_id = inventory.film_id
	  JOIN film_category ON film_category.film_id = film.film_id
	  JOIN category ON category.category_id = film_category.category_id
	  WHERE category.NAME = "Action"
	  GROUP BY first_name, last_name, email
      ORDER BY customer.customer_id;
END //
delimiter ;

#Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.
delimiter //
CREATE PROCEDURE customer_movies_varcategories(in _category char(100))
BEGIN
SELECT first_name, last_name, email FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON film.film_id = inventory.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE category.NAME = _category
GROUP BY first_name, last_name, email;
END //
DELIMITER ;

call customer_movies_varcategories("classics") ;
#468 rows returned

#Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
#the query
SELECT c.name, COUNT(f.film_id) FROM film_category AS f
JOIN category AS c ON f.category_id = c.category_id
GROUP BY c.name ;

SELECT c.name, COUNT(f.film_id) AS count FROM film_category AS f
JOIN category AS c ON f.category_id = c.category_id
GROUP BY c.name
HAVING count > 50
ORDER BY count DESC ;

#16 rows returned

#the stored procedure
delimiter //
CREATE PROCEDURE count_films_categories(IN more_than INT) 
BEGIN
	SELECT c.name, COUNT(f.film_id) AS count FROM film_category AS f
	JOIN category AS c ON f.category_id = c.category_id
	GROUP BY c.name
	HAVING count > 50
	ORDER BY count DESC ;
END //
DELIMITER ;
