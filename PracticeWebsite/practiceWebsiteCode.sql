-- Practice website

-- EASY level questions

--Question 1 : Show first name, last name, and gender of patients whose gender is 'M'

SELECT first_name, last_name, gender
FROM patients
WHERE gender = 'M';

--Question 2 : Show first name and last name of patients who does not have allergies. (null)

SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;

--Question 3 : Show first name of patients that start with the letter 'C'

SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';

--Question 4 : Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT first_name, last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;

--Question 5 : Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;

--Question 6 : Show first name and last name concatinated into one column to show their full name.

SELECT 
CONCAT (first_name, ' ', last_name) AS full_name
FROM patients;

--Question 7: Show first name, last name, and the full province name of each patient.

SELECT pt.first_name, pt.last_name, pn.province_name
FROM patients AS pt
JOIN province_names AS pn
ON pt.province_id = pn.province_id;

--Question 8: Show how many patients have a birth_date with 2010 as the birth year.

SELECT COUNT (birth_date) 
FROM patients
WHERE YEAR(birth_date) = 2010;

--Question 9: Show the first_name, last_name, and height of the patient with the greatest height.

SELECT first_name, last_name, MAX(height) AS height
FROM patients;

--Question 10: Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000

SELECT *
FROM patients 
WHERE patient_id IN (1,45,534,879,1000);

--Question 11: Show the total number of admissions

SELECT COUNT (admission_date)
FROM admissions;

--Question 12: Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT *
FROM admissions
WHERE admission_date = discharge_date;

--Question 13: Show the patient id and the total number of admissions for patient_id 579.

SELECT patient_id, COUNT(admission_date) AS total_admissions
from admissions
WHERE patient_id = 579;

--Question 14: Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

SELECT DISTINCT (city) AS unique_cities
from patients
where province_id = 'NS';

--Question 15: Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70

SELECT first_name, last_name, birth_date
from patients
WHERE height > 160 AND weight > 70;

--Question 16: Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null

select first_name, last_name, allergies
FROM patients
where city = 'Hamilton' 
	  AND allergies IS NOT NULL;
	  
--Question 17: Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.

SELECT distinct city 
from patients
WHERE city LIKE 'a%'
	OR city LIKE 'e%'
    OR city like 'i%'
    OR city LIKE 'o%'
    OR city LIKE 'u%'
ORDER by city;

-- MEDIUM level questions

--Question 1: Show unique birth years from patients and order them by ascending.

SELECT distinct YEAR(birth_date) AS birth_year
from patients
order by birth_year;

--Question 2: Show unique first names from the patients table which only occurs once in the list.
--For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.

select first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

--Question 3: Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

select patient_id, first_name
from patients 
where first_name LIKE 's____%s';

--Question 4: Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
--Primary diagnosis is stored in the admissions table.

select admissions.patient_id, patients.first_name, patients.last_name
from patients
	JOIN admissions ON admissions.patient_id = patients.patient_id
where diagnosis = 'Dementia';

--Question 5: Display every patient's first_name.
--Order the list by the length of each name and then by alphbetically

select first_name
from patients
order by len(first_name), first_name; 

--Question 6: Show the total amount of male patients and the total amount of female patients in the patients table.
--Display the two results in the same row.

SELECT 
	(SELECT COUNT(*) FROM patients WHERE gender = 'M') AS male_count,
	(SELECT COUNT(*) FROM patients WHERE gender = 'F') AS female_count;
 
--Question 7: Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.

select first_name, last_name, allergies
from patients
where allergies IN ('Penicillin', 'Morphine')
order BY allergies, first_name , last_name;

--Question 8: Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

--Question 9: Show the city and the total number of patients in the city.
--Order from most to least patients and then by city name ascending.

SELECT city, COUNT(*) AS num_patients 
from patients
GROUP BY city
order by num_patients desc, city asc;

--Question 9: Show first name, last name and role of every person that is either patient or doctor.
--The roles are either "Patient" or "Doctor"

select first_name, last_name, 'Patient' AS role FROM patients
	union all
select first_name, last_name, 'Doctor' from doctors;

--Question 10: Show all allergies ordered by popularity. Remove NULL values from query.

select allergies, count(*) AS total_diagnosis
from patients
WHERE allergies IS NOT NULL
group by allergies
order by total_diagnosis DESC;

--Question 11: Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

select first_name, last_name, birth_date
from patients
WHERE YEAR(birth_date) between 1970 and 1979
order by birth_date asc;

--Question 12: We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order
--EX: SMITH,jane

SELECT CONCAT(upper(last_name) , ',' , lower(first_name))
FROM patients
ORDER BY first_name DESC;

--Question 13: Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

select province_id, SUM(height) AS total_height
from patients
group by province_id
having total_height >= 7000;

--Question 14: Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

select (max(weight) - MIN(weight)) AS weight_diff
from patients
where last_name = 'Maroni';

--Question 15: Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

select day(admission_date) AS day_number, count(*) number_of_admissions
from admissions
group by day_number
ORDER by number_of_admissions desc;

--Question 16: Show all columns for patient_id 542's most recent admission_date.

select *
FROM admissions
where patient_id = 542
group by patient_id
HAVING admission_date = MAX(admission_date);

--Question 17: Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
--1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
--2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

select patient_id, attending_doctor_id, diagnosis
from admissions
WHERE 
	(attending_doctor_id IN (1, 5, 19)
     AND patient_id % 2 !=0
    )
    or 
    (
      attending_doctor_id LIKE '%2%'
      AND len(patient_id) = 3
    );
	
--Question 18: Show first_name, last_name, and the total number of admissions attended for each doctor.
--Every admission has been attended by a doctor.

select first_name, last_name, COUNT(*) AS total_admissions
FROM admissions AS a 
JOIN doctors AS dr
ON dr.doctor_id = a.attending_doctor_id
group by attending_doctor_id;

--Question 19: For each doctor, display their id, full name, and the first and last admission date they attended.

select 	doctor_id, 
		concat(first_name,' ',last_name) AS full_name,
        MIN(admission_date) AS first_admission_date,
        MAX(admission_date) AS last_admission_date
from admissions AS a 
JOIN doctors AS dr
ON dr.doctor_id = a.attending_doctor_id
group BY doctor_id;

--Question 20: Display the total amount of patients for each province. Order by descending.

select province_name, count (*) AS total_patients
FROM patients AS p
JOIN province_names AS pr 
ON pr.province_id = p.province_id
group by pr.province_id
order by total_patients desc;

--Question 21: For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.

select 	concat(patients.first_name, ' ' ,patients.last_name) AS patient_name, 
		diagnosis, 
        CONCAT(doctors.first_name, ' ', doctors.last_name) as doctor_name
FROM patients
JOIN admissions on admissions.patient_id = patients.patient_id
JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;

--Question 22: display the number of duplicate patients based on their first_name and last_name.

select first_name, last_name, count(*) AS num_of_duplicates
from patients
group by first_name, last_name
having count(*) > 1;

--Question 23: Display patient's full name,
--height in the units feet rounded to 1 decimal,
--weight in the unit pounds rounded to 0 decimals,
--birth_date,
--gender non abbreviated.

--Convert CM to feet by dividing by 30.48.
--Convert KG to pounds by multiplying by 2.205.

select 	concat (first_name, ' ' , last_name) AS 'patient_name',
		ROUND (height / 30.48, 1) AS 'height "Feet"',
        ROUND (weight * 2.205, 0) AS 'weight "Pounds"',
        birth_date,
CASE 
		WHEN gender = 'M' THEN 'MALE'
	ELSE 'FEMALE'
END AS 'gender_type'
FROM patients;