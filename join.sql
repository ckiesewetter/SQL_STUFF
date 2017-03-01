--What languages are spoken in the 20 poorest countries.


SELECT
	country.code,
	c.name,
	c.gnp,
	cl.language,
	c.population,
	c.gnp / c.population AS gnppercap
FROM  country c JOIN
	      countrylanguage cl ON c.code = cl.countrycode

WHERE population > 0
ORDER BY gnppercap ASC
LIMIT 20;



-- What languages are spoken in the United States? (12) Brazil? (not Spanish...) Switzerland? (6)
-- United States:
SELECT
  c.name,
  c.code,
  cl.language,
  c.name
FROM country c JOIN countrylanguage cl ON c.code = cl.countrycode
WHERE c.name = 'United States'

  -- Brazil
SELECT
  c.name,
  c.code,
  cl.language,
  c.name
FROM country c JOIN countrylanguage cl ON c.code = cl.countrycode
WHERE c.name = 'Brazil'

  -- Switzerland

SELECT
  c.name,
  c.code,
  cl.language,
  c.name
FROM country c JOIN countrylanguage cl ON c.code = cl.countrycode
WHERE c.name = 'Switzerland'

  -- What are the cities of the US? (274) India? (341)
--
-- USA
SELECT
  c.name,
  c.code,
  ct.name
FROM country c JOIN city ct  ON c.code = ct.countrycode
WHERE c.name = 'United States'

-- India
SELECT
  c.name,
  c.code,
  ct.name
FROM country c JOIN city ct  ON c.code = ct.countrycode
WHERE c.name = 'India'

-- What are the official languages of Switzerland? (4 languages)

SELECT
  c.name,
  c.code,
  cl.language,
FROM country c JOIN countrylanguage cl ON c.code = cl.countrycode
WHERE c.name = 'Switzerland'


-- Which country or contries speak the most languages? (12 languages)
-- Hint: Use GROUP BY and COUNT(...)


SELECT
  c.name,
  COUNT(cl.language) AS most_languages
FROM country c JOIN countrylanguage cl ON c.code = cl.countrycode
GROUP BY name
ORDER BY most_languages DESC;

  --try this using with as an extra

  -- Which country or countries have the most offficial languages? (4 languages)

SELECT
  c.name,
  COUNT(cl.isofficial) AS official_language
FROM country c JOIN countrylanguage cl ON c.code = cl.countrycode
GROUP BY name
ORDER BY official_language DESC;

-- Which languages are spoken in the ten largest (area) countries?

WITH
  largest_countries AS (
SELECT
  code,
  name,
  surfacearea
FROM
  country
WHERE
  surfacearea > 0
ORDER BY surfacearea DESC
)
SELECT *
FROM
  countrylanguage cl JOIN largest_countries lc ON cl.countrycode = lc.code;

-- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0)
-- Hint: Use WITH to get the countries, and SELECT DISTINCT to remove duplicates
-- we use WITH to find the table of 20 countries with the lowest gnp per capita
WITH
  poor_countries AS (
SELECT
  code,
  name,
  gnp,
  population,
  gnp / population AS percapita
FROM
  country
WHERE
  gnp > 0
  AND
  population > 0
ORDER BY percapita
LIMIT 20
)
---then after creating the new table poor_countries, we join poor_countries with the language table to find the list of languages for each of those 20 poorest countries.
SELECT DISTINCT
name,
language,
code,
gnp / population AS percapita

FROM countrylanguage cl JOIN poor_countries pc ON cl.countrycode = pc.code
LIMIT 20;

-- Are there any countries without an official language?
-- Hint: Use NOT IN with a SELECT

--Creating a new list with countries that dont have an official_language

--- we can use NOT IN FALSE



SELECT
name,
code,
isofficial
FROM
country c JOIN countrylanguage cl ON cl.countrycode = c.code
WHERE countrycode NOT IN
(SELECT
countrycode
FROM countrylanguage
WHERE isofficial = 'TRUE')
ORDER BY
countrycode ASC;

--can also use <> instead of NOT IN by doing:
-- WHERE  isofficial <> 'F';

-- What are the languages spoken in the countries with no official language? (49 countries, 172 languages, incl. English)
-- select by language
SELECT DISTINCT
name,
code,
isofficial,
language
FROM
country c JOIN countrylanguage cl ON cl.countrycode = c.code
WHERE countrycode NOT IN
(SELECT
countrycode
FROM countrylanguage
WHERE isofficial = 'TRUE')
ORDER BY
language;


-- Which countries have the highest proportion of official language speakers? The lowest?

SELECT
c.name,
cl.language,
cl.percentage,
cl.countrycode
FROM
countrylanguage cl JOIN country c ON cl.countrycode = c.code
WHERE
percentage > 0
ORDER BY cl.percentage DESC

-- What is the most spoken language in the world?

--below this gives us english because it counts how many times english is repeated
SELECT       language,
             COUNT(language) AS common_language
    FROM     countrylanguage
    GROUP BY language
    ORDER BY common_language DESC
    LIMIT    1;

--we need to find it by population

--first we need to create a table that combines population and language

-- we could also use the countrylanguage table only and use the percentage with max()


-- what is the most spoken language
-- how many people speak each language
-- how many people per country speak each language

-- people per county speaking a langues = percentage of language per country * poplulation per country
WITH speakers_and_countries AS (
  SELECT
    cl.language as language,
    c.name as country_name,
    c.population * cl.percentage as speakers_per_country
  FROM
    country c JOIN countrylanguage cl
    ON c.code = cl.countrycode
)
SELECT
  language,
  SUM(speakers_per_country) as sum_of_speakers
FROM speakers_and_countries
-- sum people speaking each langunge in all countries
GROUP BY language
ORDER BY sum_of_speakers DESC
LIMIT 1
