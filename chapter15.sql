--Chapter 15

CREATE OR REPLACE VIEW NEVADA_COUNTIES_POP_2010 AS
SELECT GEO_NAME,
	STATE_FIPS,
	COUNTY_FIPS,
	P0010001 AS POP_2010
FROM US_COUNTIES_2010
WHERE STATE_US_ABBREVIATION = 'NV'
ORDER BY COUNTY_FIPS;

SELECT *
FROM NEVADA_COUNTIES_POP_2010
LIMIT 5;

CREATE OR REPLACE VIEW county_pop_change_2010_2000 AS
 SELECT c2010.geo_name,
 c2010.state_us_abbreviation AS st,
 c2010.state_fips,
 c2010.county_fips,
 c2010.p0010001 AS pop_2010,
 c2000.p0010001 AS pop_2000,
 round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001) 
 / c2000.p0010001 * 100, 1 ) AS pct_change_2010_2000
 FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
 ON c2010.state_fips = c2000.state_fips
 AND c2010.county_fips = c2000.county_fips
 ORDER BY c2010.state_fips, c2010.county_fips;
 
 SELECT GEO_NAME, ST,
	POP_2010,
	PCT_CHANGE_2010_2000
FROM COUNTY_POP_CHANGE_2010_2000
WHERE ST = 'NV'
LIMIT 5;

CREATE OR REPLACE VIEW EMPLOYEES_TAX_DEPT AS
SELECT EMP_ID,
	FIRST_NAME,
	LAST_NAME,
	DEPT_ID
FROM EMPLOYEES
WHERE DEPT_ID = 1
ORDER BY EMP_ID WITH LOCAL CHECK OPTION;

SELECT * FROM employees_tax_dept;

INSERT INTO employees_tax_dept (first_name, last_name, dept_id)
VALUES ('Suzanne', 'Legere', 1);

INSERT INTO employees_tax_dept (first_name, last_name, dept_id)
VALUES ('Jamil', 'White', 2);

SELECT * FROM employees_tax_dept;
SELECT * FROM employees;

UPDATE EMPLOYEES_TAX_DEPT
SET LAST_NAME = 'Le Gere'
WHERE EMP_ID = 5;


SELECT *
FROM EMPLOYEES_TAX_DEPT;

DELETE
FROM EMPLOYEES_TAX_DEPT
WHERE EMP_ID = 5;

CREATE OR REPLACE FUNCTION PERCENT_CHANGE(NEW_VALUE numeric, OLD_VALUE numeric, DECIMAL_PLACES integer DEFAULT 1) 
RETURNS numeric 
AS 'SELECT round(
 ((new_value - old_value) / old_value) * 100, decimal_places
);' LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT;

SELECT percent_change(110, 108, 2);

SELECT c2010.geo_name,
c2010.state_us_abbreviation AS st,
c2010.p0010001 AS pop_2010,
percent_change(c2010.p0010001, c2000.p0010001) AS pct_chg_func,
round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
/ c2000.p0010001 * 100, 1 ) AS pct_chg_formula
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips 
AND c2010.county_fips = c2000.county_fips
ORDER BY pct_chg_func DESC
LIMIT 5;

ALTER TABLE TEACHERS ADD COLUMN PERSONAL_DAYS integer;


SELECT FIRST_NAME,
	LAST_NAME,
	HIRE_DATE,
	PERSONAL_DAYS
FROM TEACHERS;

CREATE OR REPLACE FUNCTION UPDATE_PERSONAL_DAYS() RETURNS VOID AS $$
 BEGIN
 UPDATE teachers
 SET personal_days =
  CASE WHEN (now() - hire_date) BETWEEN '5 years'::interval
 AND '10 years'::interval THEN 4
 WHEN (now() - hire_date) > '10 years'::interval THEN 5
 ELSE 3
 END;
  RAISE NOTICE 'personal_days updated!';
END;
 $$ LANGUAGE PLPGSQL;
 
SELECT update_personal_days();

CREATE EXTENSION plpythonu;

CREATE OR REPLACE FUNCTION TRIM_COUNTY(INPUT_STRING text) RETURNS text AS $$
  import re
  cleaned = re.sub(r' County', '', input_string)
 return cleaned
 $$ LANGUAGE PLPYTHONU;
 
SELECT GEO_NAME,
	TRIM_COUNTY
FROM US_COUNTIES_2010
ORDER BY STATE_FIPS,
	COUNTY_FIPS
LIMIT 5;

CREATE TABLE grades (
 student_id bigint,
 course_id bigint,
 course varchar(30) NOT NULL,
 grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id)
);
 INSERT INTO grades
VALUES
 (1, 1, 'Biology 2', 'F'),
 (1, 2, 'English 11B', 'D'),
 (1, 3, 'World History 11B', 'C'),
 (1, 4, 'Trig 2', 'B');
CREATE TABLE grades_history (
 student_id bigint NOT NULL,
 course_id bigint NOT NULL,
 change_time timestamp with time zone NOT NULL,
 course varchar(30) NOT NULL,
 old_grade varchar(5) NOT NULL,
 new_grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id, change_time)
);

CREATE OR REPLACE FUNCTION record_if_grade_changed()
  RETURNS trigger AS
$$
BEGIN
  IF NEW.grade <> OLD.grade THEN
 INSERT INTO grades_history (
 student_id,
 course_id,
 change_time,
 course,
 old_grade,
 new_grade)
 VALUES
 (OLD.student_id,
 OLD.course_id,
 now(),
 OLD.course,
  OLD.grade,
  NEW.grade);
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER GRADES_UPDATE AFTER
UPDATE ON GRADES
FOR EACH ROW 
EXECUTE PROCEDURE RECORD_IF_GRADE_CHANGED();

UPDATE grades
SET grade = 'C'
WHERE student_id = 1 AND course_id = 1;

SELECT STUDENT_ID,
	CHANGE_TIME,
	COURSE,
	OLD_GRADE,
	NEW_GRADE
FROM GRADES_HISTORY;

CREATE TABLE temperature_test (
 station_name varchar(50),
 observation_date date,
 max_temp integer,
 min_temp integer,
 max_temp_group varchar(40),
PRIMARY KEY (station_name, observation_date)
);

CREATE OR REPLACE FUNCTION CLASSIFY_MAX_TEMP() RETURNS TRIGGER AS $$
BEGIN
 CASE
 WHEN NEW.max_temp >= 90 THEN
 NEW.max_temp_group := 'Hot';
 WHEN NEW.max_temp BETWEEN 70 AND 89 THEN
 NEW.max_temp_group := 'Warm';
 WHEN NEW.max_temp BETWEEN 50 AND 69 THEN
 NEW.max_temp_group := 'Pleasant';
 WHEN NEW.max_temp BETWEEN 33 AND 49 THEN
 NEW.max_temp_group := 'Cold';
 WHEN NEW.max_temp BETWEEN 20 AND 32 THEN
 NEW.max_temp_group := 'Freezing';
 ELSE NEW.max_temp_group := 'Inhumane';
 END CASE;
 RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER temperature_insert
 BEFORE INSERT
 ON temperature_test
 FOR EACH ROW 
 EXECUTE PROCEDURE classify_max_temp();
 
SET datestyle = 'ISO, MDY';
 
INSERT INTO temperature_test (station_name, observation_date, max_temp, min_temp)
VALUES
 ('North Station', '1/19/2019', 10, -3),
 ('North Station', '3/20/2019', 28, 19),
 ('North Station', '5/2/2019', 65, 42),
 ('North Station', '8/9/2019', 93, 74);
 
SELECT * FROM temperature_test;

-- Try it yourself 1

CREATE OR REPLACE VIEW New_York_City_taxi_trips_per_hour  AS
SELECT
 date_part('hour', tpep_pickup_datetime) AS trip_hour,
 count(*)
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY trip_hour;

SELECT * FROM New_York_City_taxi_trips_per_hour

-- Try it yourself 2

CREATE OR REPLACE FUNCTION

rates_per_thousand