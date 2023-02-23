--Chapter 7

CREATE TABLE customers (
 customer_id serial
 --snip--
);
CREATE TABLE "Customers" (
customer_id serial
 --snip--
);

SELECT * FROM "Customers";

CREATE TABLE natural_key_example (
 license_id varchar(10) CONSTRAINT license_key PRIMARY KEY,
 first_name varchar(50),
 last_name varchar(50)
);

DROP TABLE natural_key_example;

CREATE TABLE natural_key_example (
 license_id varchar(10),
 first_name varchar(50),
 last_name varchar(50),
 CONSTRAINT license_key PRIMARY KEY (license_id)
);

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Sam', 'Tracy');

CREATE TABLE natural_key_composite_example (
 student_id varchar(10),
 school_day date,
 present boolean,
 CONSTRAINT student_key PRIMARY KEY (student_id, school_day) 
);

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/22/2017', 'Y');
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2017', 'Y');
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2017', 'N')

CREATE TABLE surrogate_key_example (
 order_number bigserial,
 product_name varchar(50),
 order_date date,
CONSTRAINT order_key PRIMARY KEY (order_number) 
);
INSERT INTO surrogate_key_example (product_name, order_date)
VALUES ('Beachball Polish', '2015-03-17'),
 ('Wrinkle De-Atomizer', '2017-05-22'),
 ('Flux Capacitor', '1985-10-26');
SELECT * FROM surrogate_key_example;

CREATE TABLE licenses (
 license_id varchar(10),
 first_name varchar(50),
 last_name varchar(50),
 CONSTRAINT licenses_key PRIMARY KEY (license_id)
);
CREATE TABLE registrations (
 registration_id varchar(10),
 registration_date date,
 license_id varchar(10) REFERENCES licenses (license_id),
 CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);
INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');
INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '3/17/2017', 'T229901');
INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '3/17/2017', 'T000001');

CREATE TABLE registrations (
 registration_id varchar(10),
 registration_date date,
 license_id varchar(10) REFERENCES licenses (license_id) ON DELETE CASCADE,
 CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

CREATE TABLE check_constraint_example (
 user_id bigserial,
 user_role varchar(50),
 salary integer,
 CONSTRAINT user_id_key PRIMARY KEY (user_id),
 CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff')),
 CONSTRAINT check_salary_not_zero CHECK (salary > 0)
);

CONSTRAINT grad_check CHECK (credits >= 120 AND tuition = 'Paid'),
CONSTRAINT sale_check CHECK (sale_price < retail_price)

CREATE TABLE unique_constraint_example (
 contact_id bigserial CONSTRAINT contact_id_key PRIMARY KEY,
first_name varchar(50),
 last_name varchar(50),
 email varchar(200),
 CONSTRAINT email_unique UNIQUE (email) 
);
INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Samantha', 'Lee', 'slee@example.org');
INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Betty', 'Diaz', 'bdiaz@example.org');
INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Sasha', 'Lee', 'slee@example.org');

CREATE TABLE not_null_example (
 student_id bigserial,
 first_name varchar(50) NOT NULL,
 last_name varchar(50) NOT NULL,
 CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

ALTER TABLE first_name DROP CONSTRAINT constraint_name;

ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;