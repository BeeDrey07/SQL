CREATE TABLE products (
	product_id bigserial PRIMARY KEY,
	product_name varchar(30),
	product_price numeric CONSTRAINT price_key CHECK(product_price > 0)
);

DROP TABLE products;

INSERT INTO products (product_name, product_price)
VALUES ('Coke', 5),
	('Chips', 10);
	
SELECT * FROM products;

CREATE TABLE users (
	user_id bigserial PRIMARY KEY,
	user_name varchar(30)
);



DROP TABLE users;

INSERT INTO users (user_name)
VALUES ('Arnold'),
	('Sheryl');

SELECT * FROM users;

CREATE TABLE cart (
	product_id int REFERENCES products(product_id) ON DELETE CASCADE UNIQUE,
	qty numeric CONSTRAINT qty_key CHECK (qty > 0)
);

DROP TABLE cart;
	
SELECT * FROM cart;

CREATE TABLE orders (
	order_id serial PRIMARY KEY,
	user_id bigint REFERENCES users(user_id) ON DELETE CASCADE,
	order_date timestamp DEFAULT current_timestamp
);

DROP TABLE orders;

CREATE TABLE order_details (
	order_id bigint REFERENCES orders(order_id) ON DELETE CASCADE,
	product_id bigint REFERENCES products(product_id) ON DELETE CASCADE,
	qty bigint CONSTRAINT qty_key CHECK(qty > 0)
);

DROP TABLE order_details;


CREATE OR REPLACE FUNCTION UPDATE_CART(PROD_ID int) RETURNS VOID AS $$
	BEGIN
	IF EXISTS (SELECT * FROM cart  WHERE product_id = prod_id)
	THEN
		UPDATE cart  SET qty = qty + 1  WHERE product_id = prod_id;
	ELSE
		INSERT INTO cart (product_id,qty) VALUES (prod_id,1);
	END IF;
 	END;
	$$ LANGUAGE PLPGSQL;

SELECT update_cart(1);

SELECT * FROM cart

SELECT update_cart(1);

SELECT update_cart(2);

INSERT INTO orders (user_id)
VALUES (2);

SELECT * FROM orders;

INSERT INTO order_details (order_id, product_id, qty)
VALUES (1, 1, 2),
	(1, 2, 1);
	
SELECT * FROM order_details;

DELETE FROM CART;

SELECT update_cart(1); -- new order(ran 5 times)

SELECT * FROM CART;

SELECT update_cart(2); -- ran 10 times

INSERT INTO orders (user_id)
VALUES (2);

SELECT * FROM orders

DELETE FROM order_details;

INSERT INTO order_details (order_id, product_id, qty)
VALUES (2, 1, 5),
	(2, 2, 10);
	
SELECT * FROM order_details;

SELECT OD.order_id, US.user_name, PR.product_name, PR.product_price, OD.qty, qty * product_price AS total
FROM products PR JOIN order_details OD
ON PR.product_id = OD.product_id
JOIN orders ORD 
ON ORD.order_id = OD.order_id
JOIN users US 
ON US.user_id = ORD.user_id
WHERE OD.order_id = 1;

SELECT OD.order_id, US.user_name, PR.product_name, PR.product_price, OD.qty, qty * product_price AS total
FROM products PR JOIN order_details OD
ON PR.product_id = OD.product_id
JOIN orders ORD 
ON ORD.order_id = OD.order_id
JOIN users US 
ON US.user_id = ORD.user_id;

SELECT OD.order_id, sum(qty * product_price) AS total
FROM products PR JOIN order_details OD
ON PR.product_id = OD.product_id
JOIN orders ORD 
ON ORD.order_id = OD.order_id
JOIN users US 
ON US.user_id = ORD.user_id
GROUP BY OD.order_id
HAVING OD.order_id = 1;

SELECT OD.order_id, sum(qty * product_price) AS total
FROM products PR JOIN order_details OD
ON PR.product_id = OD.product_id
JOIN orders ORD 
ON ORD.order_id = OD.order_id
JOIN users US 
ON US.user_id = ORD.user_id
GROUP BY OD.order_id;

CREATE OR REPLACE FUNCTION delete_product(prod_id BIGINT)
RETURNS void AS $$
BEGIN
    IF EXISTS (SELECT * FROM cart WHERE product_id = prod_id
                                  AND qty > 1)
    THEN
        UPDATE  cart
        SET qty = qty - 1
        WHERE product_id = prod_id;
    ELSE
        DELETE FROM Cart 
        WHERE product_id = prod_id;
    END IF; 
END;
$$ LANGUAGE plpgsql;

SELECT delete_product(2);

SELECT * FROM cart;

