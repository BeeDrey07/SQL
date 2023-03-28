CREATE TABLE department (
	depart_id bigserial CONSTRAINT department_key PRIMARY KEY,
	depart_name varchar(30),
	depart_city varchar(30)
);

CREATE TABLE roles (
	role_id bigserial CONSTRAINT role_key PRIMARY KEY,
	role varchar(30)
);

CREATE TABLE salaries (
	salary_id bigserial CONSTRAINT salary_key PRIMARY KEY,
	salary_pa money
);

DROP TABLE salaries;

CREATE TABLE overtime (
	overtime_id bigserial CONSTRAINT overtime_key PRIMARY KEY,
	overtime_hours numeric
);

CREATE TABLE employees (
	emp_id bigserial CONSTRAINT emp_key PRIMARY KEY,
	first_name varchar(30) NOT NULL,
	surname varchar(30) NOT NULL,
	gender char(1),
	address varchar(50),
	email varchar(30) UNIQUE NOT NULL,
	depart_id bigint REFERENCES department (depart_id),
	role_id bigint REFERENCES roles (role_id),
	salary_id bigint REFERENCES salaries (salary_id),
	overtime_id bigint REFERENCES overtime (overtime_id)
);

INSERT INTO department (depart_name, depart_city)
VALUES  ('Finance', 'Johannesburg'), -- done
		('Marketing', 'Pretoria'), -- done
		('Administration', 'Cape Town'), -- done
		('IT', 'Rosebank'),
		('Management', 'Durban'),--done
		('Human Resources', 'Bloemfontein'), --done
		('Manufacturing', 'East London');
		
SELECT * FROM department;

INSERT INTO roles (role)
VALUES  ('Financial Manager'),
		('Accountant'),
		('Marketing Manager'),
		('Promoter'),
		('Administrator'),
		('Administrative Assistant'),
		('Senior Developer'),
		('Junior Developer'),
		('Chief Executive Officer'),
		('Chief Operations Officer'),
		('Human Resources Manager'),
		('Recruiter'),
		('Engineer'),
		('Production Manager');
		
INSERT INTO salaries (salary_pa)
VALUES  (543927), --financial manager
		(419778), --accountant
		(480000), --marketing manager
		(162000), --promoter
		(300000), --administrator
		(110744), --administrative assistant
		(752400), --senior developer
		(330000), --junior developer
		(1189902), --CEO
		(985165), --COO
		(480000), --HR manager
		(246000), --recruiter
		(570000), --engineer
		(467443); --production manager
		
INSERT INTO overtime (overtime_hours)
VALUES  (1),
		(3),
		(2),
		(7),
		(4),
		(5),
		(10);
		
INSERT INTO employees (
	first_name,
	surname,
	gender,
	address,
	email,
	depart_id,
	role_id,
	salary_id,
	overtime_id
)
VALUES  ('Sarah' , 'Jacobs' , 'F' , '32 Cherry Street, Johannesburg' , 'sarahj01@gmail.com' , 1 , 2 , 2 , 4),
		('Ben' , 'Walters' , 'M' , '10 Grove Avenue, East London' , 'benwalters@gmail.com' , 7 , 13 , 13 , 2),
		('Jack' , 'Beanstalk' , 'M' , '8 Millers Drive, Durban' , 'jackbeans88@gmail.com' , 5 , 10 , 10 , 1),
		('Jenna' , 'Monroe' , 'F' , '22 Lion Street, Cape Town' , 'jenmonroe05@gmail.com' , 3 , 5 , 5 , 6),
		('Selena' , 'Gomez' , 'F' , '407 Burger Street, Pretoria' , 'selenag25@gmail.com' , 2 , 3 , 3 , 7),
		('Tarryn' , 'Smith' , 'F' , '89 Falcon Avenue, Bloemfontein' , 'tarynsmith7@gmail.com' , 6 , 12 , 12 , 1),
		('Joe' , 'Goldberg' , 'M' , '16 London Drive, Rosebank' , 'joegoldberg04@gmail.com' , 4 , 7 , 7 , 7 ),
		('Hannah' , 'Montanna' , 'F' , '12 Fantasy Avenue, Pretoria' , 'hannahmontanna@gmail.com' , 2 , 4 , 4 , 3),
		('Marko' , 'Wahlberg' , 'M' , '52 Cadbury Lane, Johannesburg' , 'mkwahlberg@gmail.com' , 1 , 1 , 1, 5),
		('Dylan' , 'Obrien' , 'M' , '30 Mystic Drive, Durban' , 'dylanobrien21@gmail.com' , 5 , 9 , 9 , 7),
		('Danny' , 'Phantom' , 'M' , '61 Spooky Street, East London' , 'dannyphantom09@gmail.com' , 7 , 14 , 14 , 6),
		('Dimika' , 'Chetty' , 'F' , '55 Rainbow Lane, Cape Town' , 'dimikachetty100@gmail.com' , 3 , 6 , 6 , 1),
		('Jane' , 'Cardosa' , 'F' , '19 Sunset Drive, Bloemfontein' , 'janecardosa32@gmail.com' , 6 , 11 , 11 , 4),
		('Candice' , 'Hudson' , 'F' , '45 Lilly Street, Rosebank' , 'candicehudson@gmail.com' , 4 , 8 , 8 , 2);
		
SELECT * FROM employees;

SELECT DP.depart_name , RL.role , SL.salary_pa , OT.overtime_hours
FROM employees AS EMP
LEFT JOIN department AS DP
ON DP.depart_id = EMP.depart_id
LEFT JOIN roles AS RL
ON RL.role_id = EMP.role_id
LEFT JOIN salaries AS SL
ON SL.salary_id = EMP.salary_id
LEFT JOIN overtime AS OT
ON OT.overtime_id = EMP.overtime_id;
