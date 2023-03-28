CREATE TABLE my_contacts ( 
	contact_id BIGSERIAL CONSTRAINT contact_id_key PRIMARY KEY,
	last_name VARCHAR(30) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	gender VARCHAR(30) NOT NULL,
	phone VARCHAR(10) UNIQUE NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL,
	zip_code VARCHAR REFERENCES zip_codes (zip_code),
	status_id BIGINT REFERENCES statuses (status_id),
	profession_id BIGINT REFERENCES professions (profession_id)
);

SELECT * FROM my_contacts;

DROP TABLE my_contacts CASCADE;

DROP TABLE users CASCADE; 

INSERT INTO my_contacts
(
	last_name,
	first_name,
	gender,
	phone,
	email,
	zip_code,
	status_id,
	profession_id
)
VALUES
	('Henry' , 'Smith' , 'M' , '0780615009' , 'henry@gmail.com' , '2000' , 2 , 1 ),
	('Gugu' , 'Ndaba' , 'F' ,'0780615012' , 'gugu@gmail.com' , '9700' , 2 , 2) ,
	('Jason' , 'Fallie' , 'M' , '0780615078' , 'jason@gmail.com' , '0699' , 1 , 15),
	('Mary' , 'Homes' , 'F' , '0610615009' , 'mary@gmail.com' , '6011' , 2 , 14),
	('Kyle' , 'Pillay' , 'M' , '0710615009' , 'kyle@gmail.com' , '6529' , 1 , 5 ),
	('Sizwe' , 'Nchabe' , 'M' , '0840615099' , 'sizwe@gmail.com' , '0250' , 1 , 11),
    ('Liz' ,'Sun' , 'F' , '0830777009' , 'liz@gmail.com' , '0003' , 1 , 9),
	('James', 'Walker' , 'M' , '0665412345' , 'james@gmail.com' , '8300' , 2 , 3),
	('Jacob' , 'Dlamini' , 'M' , '078564321' , 'jacob@gmail.com', '3200' , 2 , 8),
	('Kate' , 'Olsen' , 'F' , '0718957521' , 'kate@gmail.com' , '5200' , 1 , 13),
	('Busiswe' , 'Mzozo' , 'F' , '0634527894' , 'busi@gmail.com' , '7100' , 2 , 7),
	('Jennifer' , 'De Costa' , 'F' , '0789453321' , 'jennifer@gmail.com' , '0216' , 1 , 6),
	('Marko' , 'Hanso' , 'M' , '0712314532' , 'marko@gmail.com' , '9301' , 1 , 10),
	('Liam' , 'Howard' , 'M' , '0663214689' , 'liam@gmail.com' , '4000' , 2 , 12),
	('Amy' , 'Santiago' , 'F' , '0780906754' , 'amysant@gmail.com' , '9301' , 1 , 4);

CREATE TABLE zip_codes
(
    zip_code VARCHAR  PRIMARY KEY NOT NULL,
	city VARCHAR(30) NOT NULL,
	province VARCHAR (30) NOT NULL,
	CONSTRAINT zip_code_id_key CHECK ( length(zip_code) = 4),
	CONSTRAINT city_province UNIQUE (city, province)
);

DROP TABLE zip_codes;

INSERT INTO zip_codes (zip_code , city , province)
VALUES 
	('2000' , 'Johannesburg' , 'Gauteng'),
	('0003' , 'Pretoria' , 'Gauteng'),
	('5200' , 'East London' , 'Eastern Cape'),
	('6011' , 'Gqeberha' , 'Eastern Cape'),
	('9301' , 'Bloemfontein' , 'Free State'),
	('9700' , 'Parys' , 'Free State'),
	('4000' , 'Durban' , 'KwaZulu-Natal'),
	('3200' , 'Pietermaritzburg' , 'KwaZulu-Natal'),
	('0699' , 'Polokwane' , 'Limpopo'),
	('0480' , 'Bela-Bela' , 'Limpopo'),
	('1200' , 'Mbombela' , 'Mpumalanga'),
	('1123' , 'Lydenburg' , 'Mpumalanga'),
	('8300' , 'Kimberley' , 'Northern Cape'),
	('8815' , 'Upington' , 'Northern Cape'),
	('0250' , 'Brits' , 'North West'),
	('0216', 'Hartbeesport' , 'North West'),
	('7100' , 'Cape Town' , 'Western Cape'),
	('6529', 'George' , 'Western Cape');
	
SELECT * FROM zip_codes;

CREATE TABLE professions
(
    profession_id BIGSERIAL CONSTRAINT profession_id_key PRIMARY KEY,
	profession VARCHAR(30) UNIQUE NOT NULL
);

INSERT INTO professions (profession)
VALUES 
	('Doctor'),
	('Seamstress'),
	('Lawyer'),
	('Chief Executive Officer'),
	('Dancer'),
	('Game Ranger'),
	('Chef'),
	('Electrical Engineer'),
	('Personal Trainer'),
	('Real Estate Agent'),
	('Architect'),
	('Software Developer'),
	('Politician'),
	('Receptionist'),
	('Teacher');
	
SELECT * FROM professions;

CREATE TABLE statuses
(
    status_id BIGSERIAL CONSTRAINT status_id_key PRIMARY KEY,
	status VARCHAR(30) NOT NULL
);

INSERT INTO statuses
(
   status
);

VALUES
   ('single'),
   ('divorced');
   
SELECT * FROM statuses;

CREATE TABLE seekings
	(
		seeking_id BIGSERIAL CONSTRAINT seeking_id_key PRIMARY KEY,
		seeking VARCHAR(50) NOT NULL UNIQUE
	);
	
INSERT INTO seekings (seeking)
VALUES
	('single male'),
	('single female'),
	('same profession'),
	('employed'),
	('retired'),
	('over 50'),
	('under 50'),
	('under 25');
	
SELECT * FROM seekings;

CREATE TABLE contact_seeking
	(
		contact_id BIGINT NOT NULL REFERENCES my_contacts(contact_id),
   		seeking_id BIGINT NOT NULL REFERENCES seekings(seeking_id)
	);
	
INSERT INTO contact_seeking (contact_id, seeking_id)
VALUES 
	(1,2),
	(1,5),
	(1,6),
	(2,1),
	(2,4),
	(2,7),
	(3,2),
	(3,3),
	(3,8),
	(4,1),
	(4,5),
	(4,6),
	(5,2),
	(5,4),
	(5,8),
	(6,2),
	(6,4),
	(6,7),
	(7,1),
	(7,4),
	(7,8),
	(8,2),
	(8,3),
	(8,7),
	(9,2),
	(9,4),
	(9,8),
	(10,1),
	(10,5),
	(10,6),
	(11,1),
	(11,3),
	(11,8),
	(12,1),
	(12,4),
	(12,7),
	(13,2),
	(13,4),
	(13,7),
	(14,2),
	(14,5),
	(14,8),
	(15,1),
	(15,4),
	(15,8);

SELECT * FROM contact_seeking;

DROP TABLE contact_seeking;

SELECT mc.first_name, mc.last_name , sk.seeking 
FROM my_contacts AS mc 
LEFT JOIN contact_seeking AS cs 
ON mc.contact_id = cs.contact_id
LEFT JOIN seekings AS sk 
ON sk.seeking_id = cs.seeking_id;

CREATE TABLE interests
(
   interest_id BIGSERIAL CONSTRAINT interest_id_key PRIMARY KEY,
   interest VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO interests
(
   interest
)
VALUES
   ('hiking'),
   ('reading'),
   ('cycling'),
   ('cooking'),
   ('running'),
   ('gyming'),
   ('watching movies'),
   ('art'),
   ('bowling'),
   ('travelling'),
   ('ice-skating');
   
SELECT * FROM interests;
   
CREATE TABLE contact_interests
(
   contact_id BIGINT NOT NULL REFERENCES my_contacts(contact_id),
   interest_id BIGINT NOT NULL REFERENCES interests(interest_id)
);

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
   (7,4),
   (8,7),
   (8,10),
   (8,8),
   (9,6),
   (9,2),
   (9,10),
   (10,10),
   (10,11),
   (10,3),
   (11,5),
   (11,9),
   (11,10),
   (12,2),
   (12,4),
   (12,9),
   (13,7),
   (13,9),
   (13,11),
   (14,1),
   (14,5),
   (14,10),
   (15,2),
   (15,6),
   (15,8);
   
SELECT pr.profession, zc.zip_code, zc.city, zc.province, st.status, se.seeking, ints.interest
FROM my_contacts AS mc
LEFT JOIN professions AS PR
ON mc.profession_id = PR.profession_id
JOIN zip_codes AS ZC
ON mc.zip_code = ZC.zip_code
JOIN statuses AS ST
ON mc.status_id = ST.status_id
JOIN contact_seeking AS cs
ON mc.contact_id = cs.contact_id
JOIN seekings AS se
ON cs.seeking_id = se.seeking_id
JOIN contact_interests AS ci
ON mc.contact_id = ci.contact_id
JOIN interests AS ints
ON ci.interest_id = ints.interest_id;