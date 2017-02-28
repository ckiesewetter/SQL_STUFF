-- Using WHERE
-- What is the population of the US? (starts with 2, ends with 000)

SELECT
  population
FROM
  country
WHERE
 name = 'United States';

-- SQL is very particular about syntax, you must use single quotes and a semicolon to end it
-- --
-- What is the area of the US? (starts with 9, ends with million square miles)

SELECT
  surfacearea
FROM
  country
WHERE
  name = 'United States';

-- List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45? (all 37 of them)

SELECT
  population
FROM
  country
WHERE
  continent = 'Africa'
  AND
  population < 30000000
  AND
  lifeexpectancy > 45;

-- Which countries are something like a republic? (are there 122 or 143 countries or ?)

SELECT
  *
FROM
  country
WHERE
  governmentform
LIKE
  '%Republic%';

-- Which countries are some kind of republic and acheived independence after 1945?

SELECT
name,
indepyear,
code,
governmentform
FROM
country
WHERE
governmentform
LIKE
'%Republic%'
AND
indepyear > 1945;

-- Which countries acheived independence after 1945 and are not some kind of republic?

SELECT
name,
indepyear,
code,
governmentform
FROM
country
WHERE
NOT(governmentform LIKE '%Republic%')
AND
indepyear > 1945;

-- using ORDER BY
-- Which fifteen countries have the lowest life expectancy?
SELECT
code,
name,
lifeexpectancy
FROM
country
WHERE lifeexpectancy IS NOT NULL
-- here we must make sure we are not getting something without data
ORDER BY lifeexpectancy DESC
LIMIT 15;

-- highest life expactancy?

SELECT
code,
name,
lifeexpectancy
FROM
country
WHERE lifeexpectancy IS NOT NULL

ORDER BY lifeexpectancy ASC
LIMIT 15;

-- Which five countries have the lowest population density?
WITH
      population_density AS
      (SELECT
          code,
          name,
          population,
          surfacearea
      FROM
          country
      Where
          population > 0)
SELECT
          code,
          name,
          population,
          population / surfacearea AS population_density
      FROM
          country
      Where
          population / surfacearea > 0

 ORDER BY population_density DESC
LIMIT 5;


-- highest population density?
WITH
      population_density AS
      (SELECT
          code,
          name,
          population,
          surfacearea
      FROM
          country
      Where
          population > 0)
SELECT
          code,
          name,
          population,
          population / surfacearea AS population_density
      FROM
          country
      Where
          population / surfacearea > 0

 ORDER BY population_density ASC
LIMIT 5;


-- Which is the smallest country, by area and population?

SELECT
          code,
          name,
          population,
          surfacearea
      FROM
          country
      WHERE poulation > 0 AND surfacearea > 0
      ORDER BY population ASC, surfacearea ASC
      LIMIT 1;
-- could not find contry with both smallest surface area and population so we did them seperately

-- the 10 smallest countries, by area and population?

SELECT
          code,
          name,
          population,
          surfacearea
      FROM
          country
      WHERE poulation > 0 AND surfacearea > 0
      ORDER BY population ASC, surfacearea ASC
      LIMIT 10;


-- Which is the biggest country, by area and population? the 10 biggest countries, by area and population?

SELECT
          code,
          name,
          population,
          surfacearea
      FROM
          country
      WHERE poulation > 0 AND surfacearea > 0
      ORDER BY population DESC, surfacearea DESC
      LIMIT 10;



-- Of the smallest 10 countries, which has the biggest gnp? (hint: use WITH and LIMIT)

WITH
      smallest_countries_gnp AS
      (SELECT
          code,
          name,
          population,
          gnp
      FROM
          country
      Where
          population > 1)
SELECT
          code,
          name,
          population,
          population AS smallest_countries
      FROM
          country
      Where
          gnp > 0

 ORDER BY smallest_countries_gnp DESC
LIMIT 10;
-- Of the smallest 10 countries, which has the biggest per capita gnp?
-- below we used WITH:
-- smallest gnp Per capita
WITH
      smallest_countries AS
      (SELECT
          code,
          name,
          population,
          gnp
      FROM
          country
      Where
          population > 1)
SELECT
          code,
          name,
          population,
          gnp / population AS smallest_countries
      FROM
          country
      Where
          gnp > 0

 ORDER BY smallest_countries DESC
LIMIT 10;

-- below we did not use WITH:
SELECT
  gnp,
  population,
  code,
  name
FROM
  country
WHERE
  population < 100000 AND gnp >10
ORDER BY gnp ASC
LIMIT 10;


--Of the biggest 10 countries, which has the biggest gnp?
WITH
      largest_countries AS
      (SELECT
          code,
          name,
          population,
          gnp
      FROM
          country
      Where
          population > 1e+8)
SELECT
          code,
          name,
          population,
          population AS largest_countries
      FROM
          country
      Where
          gnp > 1e+6

 ORDER BY largest_countries ASC
LIMIT 10;

-- biggest gnp per capita

WITH
      largest_countries AS
      (SELECT
          code,
          name,
          population,
          gnp
      FROM
          country
      Where
          population > 1e+7)
SELECT
          code,
          name,
          population,
          population AS largest_countries
      FROM
          country
      Where
          gnp > 1e+5

 ORDER BY largest_countries DESC
LIMIT 10;

-- What is the sum of surface area of the 10 biggest countries in the world? The 10 smallest?


--  we created a list of the top 10 countries by surface area
WITH
      large_sum AS
      (SELECT
          code,
          name,
          surfacearea
      FROM
          country
      Where
          surfacearea > 0)
          LIMIT 10
-- then we summed the surface areas of the 10 countries by calling on large_sum and NOT country
SELECT sum(large_sum.surfacearea)
FROM large_sum



-- GROUP BY
-- How big are the continents in terms of area and population?
-- To create a table with the sums  for each continent  for both population & surfacearea
SELECT continent, sum(country.surfacearea), sum(country.population)
FROM country
GROUP BY continent

-- Which region has the highest average gnp?
SELECT region, max(country.gnp)
FROM country
GROUP BY region

-- Who is the most influential head of state measured by population?
SELECT headofstate, population
FROM country
GROUP BY population, headofstate
ORDER BY population DESC;
-- here we did not need to use the sum because we used the population desc

-- Who is the most influential head of state measured by surface area?
SELECT headofstate, surfacearea
FROM country
WHERE headofstate != ''
GROUP BY headofstate, surfacearea
ORDER BY surfacearea DESC;

-- What are the most common forms of government? (hint: use count(*))
SELECT governmentform, count(country.name) AS forms_of_gov
FROM country
GROUP BY governmentform
ORDER BY forms_of_gov DESC;

-- What are the forms of government for the top ten countries by surface area?

-- find top ten countries by surface area
WITH
      largest_surface_area AS
      (SELECT
          name,
          surfacearea
      FROM
          country
      Where
          surfacearea > 0
          LIMIT 10)
-- then we find the forms of gov within those 10 countries
SELECT governmentform, count(country.name) AS forms_of_gov
FROM largest_surface_area
GROUP BY governmentform
ORDER BY forms_of_gov DESC
-- above we are not done with this one^^^^^^^
