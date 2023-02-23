CREATE TABLE eagle_watch (
 observed_date date,
 eagles_seen integer
);

CREATE TABLE char_data_types (
	varchar_column varchar(10),
    char_column char(10),
    text_column text 
	);
	
INSERT INTO char_data_types
VALUES 
 ('abc', 'abc', 'abc'),
 ('defghi', 'defghi', 'defghi');
 
 COPY char_data_types TO 'C:\YourDirectory\typetest.txt'
 WITH (FORMAT CSV, HEADER, DELIMITER '|');
 
 CREATE TABLE people (
 id serial,
 person_name varchar(100)
);


