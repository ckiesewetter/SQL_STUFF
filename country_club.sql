--EPIC 1:
CREATE TABLE facilities (id serial PRIMARY KEY, name varchar, member_cost numeric, guest_cost numeric, initial_out_lay numeric, monthly_maintenance numeric);

CREATE TABLE bookings (id serial PRIMARY KEY, facility_id integer REFERENCES facilities(id), member_id integer REFERENCES members(id), start_time timestamp, slots integer);

--we need to edit this:
CREATE TABLE members (id serial PRIMARY KEY, facility_id integer REFERENCES facilities(id), member_id integer REFERENCES members(id), start_time timestamp, slots integer);

--EPIC 2
--Produce a list of start times for bookings by members named 'David Farrell'?

--we need to establish the common denominator between the 2 tables ==>take the id from members table
--what are the two tables that we need?

--we need the members table (id, first_name, surname david farrell) and the bookings table (member_id, start_time booking times)

SELECT
  m.id,
  m.first_name,
  m.surname,
  b.start_time
  FROM
  members m JOIN bookings b ON m.id = b.member_id
  WHERE
  surname = 'Farrell' AND first_name = 'David' ;

  --Produce a list of the start times for bookings for tennis courts, for the date '2016-09-21'? Return a list of start time and facility name pairings, ordered by the time.

  --we need to find which tables have start times and dates(specific 2016-09-21) and location (tennis courts)

  --we will use the bookings table (start_times) facilities (name)


    SELECT
    f.id,
    f.name,
    b.facility_id,
    b.start_time
    FROM
    facilities f JOIN bookings b ON b.facility_id = f.id
    WHERE
    start_time::date = date'2012-09-21' AND name LIKE 'Tennis %'
    ORDER BY start_time;

--Produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as first name, surname. Ensure no duplicate data, and order by the first name.

--find the two tables we need to use: members(id, first_name, surename), facilities(name) -- we need to use DISTINCT for no duplicates
--

--we need to create our own table that combines the info we need from facilities and members


--first we created a new table with the CREATE VIEW sql, that combines the tables members and bookings using JOIN
CREATE VIEW
members_and_bookings AS
SELECT
m.id,
m.first_name,
m.surname,
b.member_id,
b.facility_id
FROM
members m JOIN bookings b ON m.id = b.member_id;

--then we used JOIN to combine the above table members_and_bookings (mb) and facilities to give us the columns we needed
SELECT DISTINCT
f.id,
mb.facility_id,
mb.first_name,
mb.surname,
f.name
FROM
facilities f JOIN members_and_bookings mb ON f.id = mb.facility_id
WHERE f.name LIKE 'Tennis%'
ORDER BY f.name;



--Produce a number of how many times Nancy Dare has used the pool table facility?
--Taking first_name and surname from Members AND we are taking name and id from facilities.
--we can use count? for pool table 8
-- SELECT       language,
--              COUNT(language) AS common_language
--     FROM     countrylanguage
--     GROUP BY language
--     ORDER BY common_language DESC
--     LIMIT    1;


WITH
nancy_pool_table AS (SELECT
f.name,
COUNT(f.id),
b.facility_id,
b.member_id
FROM
facilities f JOIN bookings b ON f.id = b.facility_id
WHERE f.name = 'Pool Table' AND b.member_id = 7
GROUP BY f.name, b.facility_id, b.member_id)




SELECT
first_name,
surname,
np.name,
COUNT(f.id),
np.facility_id,
np.member_id
FROM
members m JOIN nancy_pool_table np ON m.id = np.member_id;


--^^^we messed around with this idea but still have not finished it 
