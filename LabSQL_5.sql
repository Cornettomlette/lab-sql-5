/*Instructions
Drop column picture from staff.
A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.
Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date the user was deleted.*/
USE sakila;
-- 1) Drop column picture from staff.
ALTER TABLE staff DROP picture ;

-- 2) A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
SELECT * FROM customer 
WHERE first_name = 'TAMMY' AND last_name = 'SANDERS'; -- 75	2	TAMMY	SANDERS	TAMMY.SANDERS@sakilacustomer.org	79	1	2006-02-14 22:04:36	2006-02-15 04:57:20
SELECT * FROM staff;
INSERT INTO staff values (3, 'Tammy', 'Sanders', 79, 'TAMMY.SANDERS@sakilacustomer.org', 2, 1, 'Tammy',null, '2006-02-15 03:57:16');
SELECT * FROM staff;

-- 3) Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.
SELECT * FROM film WHERE title = 'ACADEMY DINOSAUR';
SELECT * FROM inventory ;
SELECT * FROM rental ;
select inventory_id from inventory where film_id = 1;

INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id) 
values(current_date(), 
8,
(select customer_id from customer where first_name = 'CHARLOTTE' AND last_name = 'HUNTER'),
NULL,
(select staff_id from staff where first_name = 'Mike' AND last_name = 'Hillyer')
); 
SELECT * FROM rental
ORDER BY rental_id DESC;

-- 4) Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date the user was deleted.
SELECT * FROM customer;
CREATE TABLE deleted_users AS
    SELECT customer_id, email
    FROM customer
    WHERE active = 0;
ALTER TABLE deleted_users ADD COLUMN date_deleted date AFTER email;
UPDATE deleted_users SET date_deleted = current_date();
SELECT * FROM deleted_users;

-- Change rental nad payment constraints, which were preventing cascade deletion of customers

-- CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE

alter table rental
	drop constraint fk_rental_customer;

alter table rental
	add CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE cascade ON UPDATE CASCADE;

-- CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE

alter table payment
	drop constraint fk_payment_customer;

alter table payment
	add CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE cascade ON UPDATE CASCADE;

-- Delete non-active users
SELECT * FROM customer
WHERE active = 0;
DELETE FROM customer WHERE active = 0;
select * from customer;