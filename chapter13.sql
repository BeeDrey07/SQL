-- Chapter 13

SELECT CHAR_LENGTH(TRIM(' Pat '));


SELECT SUBSTRING('The game starts at 7 p.m. on May 2, 2019.'
																	FROM '\d{4}');


CREATE TABLE CRIME_REPORTS (CRIME_ID BIGSERIAL PRIMARY KEY,
	DATE_1 timestamp WITH TIME ZONE,
	DATE_2 timestamp WITH TIME ZONE,
	STREET VARCHAR(250),
	CITY VARCHAR(100),
	CRIME_TYPE VARCHAR(100),
	DESCRIPTION text, CASE_NUMBER VARCHAR(50),
	ORIGINAL_TEXT text NOT NULL);

COPY CRIME_REPORTS (ORIGINAL_TEXT)
FROM 'C:\Users\Bianca\Documents\Bootcamp\1.SQL\practical-sql-master-20230214T093024Z-001\practical-sql-master\Chapter_13\crime_reports.csv' WITH (FORMAT CSV,
	HEADER OFF,																																																																																																																																										QUOTE '"');


SELECT CRIME_ID,
	REGEXP_MATCH(ORIGINAL_TEXT,

		'\d{1,2}\/\d{1,2}\/\d{2}')
FROM CRIME_REPORTS;


SELECT CRIME_ID,
	REGEXP_MATCHES(ORIGINAL_TEXT,

		'\d{1,2}\/\d{1,2}\/\d{2}',
		'g')
FROM CRIME_REPORTS;


SELECT CRIME_ID,
	REGEXP_MATCH(ORIGINAL_TEXT,

		'-\d{1,2}\/\d{1,2}\/\d{2}')
FROM CRIME_REPORTS;


SELECT CRIME_ID,
	REGEXP_MATCH(ORIGINAL_TEXT,

		'-(\d{1,2}\/\d{1,2}\/\d{1,2})')
FROM CRIME_REPORTS;


SELECT REGEXP_MATCH(ORIGINAL_TEXT,

								'(?:C0|SO)[0-9]+') AS CASE_NUMBER,
	REGEXP_MATCH(ORIGINAL_TEXT,

		'\d{1,2}\/\d{1,2}\/\d{2}') AS DATE_1,
	REGEXP_MATCH(ORIGINAL_TEXT,

		'\n(?:\w+ \w+|\w+)\n(.*):') AS CRIME_TYPE,
	REGEXP_MATCH(ORIGINAL_TEXT,

		'(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS CITY
FROM CRIME_REPORTS;


SELECT CRIME_ID,
	(REGEXP_MATCH(ORIGINAL_TEXT,

			'(?:C0|SO)[0-9]+'))[1] AS CASE_NUMBER
FROM CRIME_REPORTS;

UPDATE crime_reports
 SET date_1 =
(
  (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1] 
  || ' ' ||
  (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
  ||' US/Eastern'
)::timestamptz;
SELECT crime_id,
 date_1,
 original_text
FROM crime_reports;

SET datestyle = 'ISO, MDY';
UPDATE crime_reports
SET date_1 =
(
    (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
    || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1]
    ||' US/Eastern'
)::timestamptz;

SELECT crime_id,date_1 FROM crime_reports;
 

UPDATE crime_reports
SET date_1 = 
 (
 (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz,
 
 date_2 = 
 CASE
 WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NULL)
 AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
 THEN
 ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz 
 WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})') IS NOT NULL)
 AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
 THEN 
 ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
 || ' ' ||
 (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
 ||' US/Eastern'
 )::timestamptz 
 
 ELSE NULL
 END,
 street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
 city = (regexp_match(original_text,
 '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
 crime_type = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
 description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
 case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];
 
 SELECT date_1,
 street,
 city,
 crime_type
FROM crime_reports;

SELECT geo_name
FROM us_counties_2010
WHERE geo_name ~* '(.+lade.+|.+lare.+)'
ORDER BY geo_name;
SELECT geo_name
FROM us_counties_2010
WHERE geo_name ~* '.+ash.+' AND geo_name !~ 'Wash.+'
ORDER BY geo_name;

SELECT regexp_replace('05/12/2018', '\d{4}', '2017');

SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');

SELECT regexp_split_to_array('Phil Mike Tony Steve', ',');

SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', ' '), 1);

SELECT to_tsvector('I am walking across the sitting room to sit with you.');

SELECT to_tsquery('walking & sitting');

SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & sitting');
SELECT to_tsvector('I am walking across the sitting room') @@ to_tsquery('walking & running');

CREATE TABLE president_speeches (
 sotu_id serial PRIMARY KEY,
 president varchar(100) NOT NULL,
 title varchar(250) NOT NULL,
 speech_date date NOT NULL,
 speech_text text NOT NULL,
 search_speech_text tsvector
);
COPY president_speeches (president, title, speech_date, speech_text)
FROM 'C:\Users\Bianca\Documents\Bootcamp\1.SQL\practical-sql-master-20230214T093024Z-001\practical-sql-master\Chapter_13\sotu-1946-1977.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

UPDATE president_speeches
SET search_speech_text = to_tsvector('english', speech_text);

CREATE INDEX search_idx ON president_speeches USING gin(search_speech_text);

SELECT president, speech_date
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam')
ORDER BY speech_date;

SELECT president,
 speech_date,
 ts_headline(speech_text, to_tsquery('Vietnam'),
 'StartSel = <,
 StopSel = >,
 MinWords=5,
 MaxWords=7,
 MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam');

SELECT president, 
 speech_date,
 ts_headline(speech_text, to_tsquery('transportation & !roads'),
 'StartSel = <,
 StopSel = >,
 MinWords=5,
 MaxWords=7,
 MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('transportation & !roads');

SELECT president,
 speech_date,
 ts_headline(speech_text, to_tsquery('military <-> defense'),
 'StartSel = <,
 StopSel = >,
 MinWords=5,
 MaxWords=7,
 MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('military <-> defense');

SELECT president,
 speech_date,
 ts_rank(search_speech_text,
 to_tsquery('war & security & threat & enemy')) AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5

SELECT president,
 speech_date,
 ts_rank(search_speech_text,
 to_tsquery('war & security & threat & enemy'), 2)::numeric
 AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5

