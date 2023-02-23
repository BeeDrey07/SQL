CREATE DATABASE contacts

CREATE TABLE MY_CONTACTS ( 
   contact_id BIGSERIAL CONSTRAINT contact_id_key PRIMARY KEY,
   last_name VARCHAR(30) NOT NULL,
   first_name VARCHAR(30) NOT NULL,
   gender VARCHAR(30) NOT NULL,
   phone VARCHAR(10) UNIQUE NOT NULL,
   email VARCHAR(30) UNIQUE NOT NULL,
   zip_code_id BIGINT REFERENCES zip_codes (zip_code_id),
   status_id BIGINT REFERENCES statuses (status_id),
   profession_id BIGINT REFERENCES professions (profession_id)
)
	
SELECT * FROM my_contacts



INSERT INTO my_contacts
(
	last_name,
	first_name,
	gender,
	phone,
	email,
	zip_code_id,
	status_id,
	profession_id
)
VALUES
('Tom','Smith','F','0780615009','tom@gmail.com', 1 , 1 , 1),
('Gugu','Ndaba','F','0780615012','gugu@gmail.com', 2 , 2, 2),
('Jo','Nala','M','0780615078','jo@gmail.com', 1 ,1 , 3),
('Mary','Smith','F','0610615009','mary@gmail.com', 2 , 2 ,4),
('Kyle','Koo','M','0710615009','kyle@gmail.com',1 , 2 , 1),
('Sizwe','Nchabe','M','0840615099','sizwe@gmail.com', 3 , 1 , 3),
('Liz','Sun','F','0830777009','liz@gmail.com', 3 , 1 , 2);

DROP TABLE my_contacts
SELECT * FROM my_contacts

CREATE TABLE zip_codes
(
    zip_code_id BIGSERIAL CONSTRAINT zip_code_id_key PRIMARY KEY,
    zip_code CHAR(11) NOT NULL,
	city VARCHAR(30) NOT NULL,
	state_name VARCHAR (30) NOT NULL,
	state_abbr CHAR (2) NOT NULL
)

INSERT INTO zip_codes 
(
    zip_code,
    city,
    state_name,
    state_abbr
)
VALUES
('36013-36191','Mongomery','Alabama','AL'),
('99703-99781','Fairbanks','Alaska','AK'),
('85641-85705','Tuicson','Arizona','AR');

SELECT * FROM zip_codes


SELECT * FROM my_contacts AS mc
JOIN zip_codes AS zc
ON mc.zip_code_id = zc.zip_code_id 

CREATE TABLE professions
(
    profession_id BIGSERIAL CONSTRAINT profession_id_key PRIMARY KEY,
	profession VARCHAR(30) NOT NULL
)

INSERT INTO professions
(
   profession
)
VALUES
	('doctor'),
    ('teacher'),
    ('software developer'),
    ('student');
	
SELECT * FROM professions

SELECT * FROM my_contacts AS mc
JOIN professions AS prof
ON mc.profession_id = prof.profession_id 
	
CREATE TABLE statuses
(
    status_id BIGSERIAL CONSTRAINT status_id_key PRIMARY KEY,
	status VARCHAR(30) NOT NULL
 )

INSERT INTO statuses
(
   status
)
VALUES
   ('single'),
   ('divorced');
   
SELECT * FROM statuses

SELECT * FROM my_contacts AS mc
JOIN statuses AS st
ON mc.status_id = st.status_id 

DROP TABLE seekings
   
CREATE TABLE seekings
(
   seeking_id BIGSERIAL CONSTRAINT seeking_id_key PRIMARY KEY,
   seeking VARCHAR(50) NOT NULL UNIQUE
   );
   

INSERT INTO seekings
( 
   seeking
)
VALUES
   ('single male'),
   ('single female'),
   ('same profession'),
   ('employed'),
   ('student'),
   ('retired'),
   ('over 50'),
   ('under 50'),
   ('under 25');
   
SELECT * FROM seekings

DROP TABLE contact_seeking

CREATE TABLE contact_seeking
(
   contact_id BIGINT NOT NULL REFERENCES my_contacts(contact_id),
   seeking_id BIGINT NOT NULL REFERENCES seekings(seeking_id)
)

INSERT INTO contact_seeking
(
   contact_id,
   seeking_id
)
VALUES
   (1,1),
   (1,3),
   (1,7),
   (2,1),
   (2,4),
   (3,1),
   (3,3),
   (3,5),
   (3,6),
   (4,1),
   (5,2),
   (6,1),
   (6,3),
   (7,2);

SELECT mc.first_name, mc.last_name , sk.seeking 
FROM my_contacts AS mc 
JOIN contact_seeking AS cs 
ON mc.contact_id = cs.contact_id
JOIN seekings AS sk 
ON sk.seeking_id = cs.seeking_id

CREATE TABLE interests
(
   interest_id BIGSERIAL CONSTRAINT interest_id_key PRIMARY KEY,
   interest VARCHAR(50) NOT NULL UNIQUE
)

INSERT INTO interests
(
   interest
)
VALUES
   ('hiking'),
   ('reading'),
   ('biking'),
   ('cooking'),
   ('running'),
   ('diving'),
   ('studying'),
   ('art'),
   ('walking'),
   ('cycling');
   
DROP TABLE interests
   
SELECT * FROM interests

CREATE TABLE contact_interests
(
   contact_id BIGINT NOT NULL REFERENCES my_contacts(contact_id),
   interest_id BIGINT NOT NULL REFERENCES interests(interest_id)
)

DROP TABLE contact_interests

INSERT INTO contact_interests
(
   contact_id,
   interest_id
)
VALUES
   (1,1),
   (1,2),
   (1,3),
   (2,1),
   (2,4),
   (2,5),
   (3,1),
   (3,6),
   (3,3),
   (4,7),
   (4,2),
   (4,10),
   (5,8),
   (5,2),
   (5,10),
   (6,1),
   (6,2),
   (6,3),
   (7,9),
   (7,2),
   (7,4);
   


SELECT mc.first_name, mc.last_name , ints.interest
FROM my_contacts AS mc 
JOIN contact_interests AS ci 
ON mc.contact_id = ci.contact_id
JOIN interests AS ints
ON ints.interest_id = ci.interest_id
