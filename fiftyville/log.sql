-- Keep a log of any SQL queries you execute as you solve the mystery.

sqlite> .table
airports              crime_scene_reports   people
atm_transactions      flights               phone_calls
bakery_security_logs  interviews
bank_accounts         passengers



sqlite> .schema
CREATE TABLE crime_scene_reports (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    street TEXT,
    description TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE interviews (
    id INTEGER,
    name TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    transcript TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE atm_transactions (
    id INTEGER,
    account_number INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    atm_location TEXT,
    transaction_type TEXT,
    amount INTEGER,
    PRIMARY KEY(id)
);
CREATE TABLE bank_accounts (
    account_number INTEGER,
    person_id INTEGER,
    creation_year INTEGER,
    FOREIGN KEY(person_id) REFERENCES people(id)
);
CREATE TABLE airports (
    id INTEGER,
    abbreviation TEXT,
    full_name TEXT,
    city TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE flights (
    id INTEGER,
    origin_airport_id INTEGER,
    destination_airport_id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(origin_airport_id) REFERENCES airports(id),
    FOREIGN KEY(destination_airport_id) REFERENCES airports(id)
);
CREATE TABLE passengers (
    flight_id INTEGER,
    passport_number INTEGER,
    seat TEXT,
    FOREIGN KEY(flight_id) REFERENCES flights(id)
);
CREATE TABLE phone_calls (
    id INTEGER,
    caller TEXT,
    receiver TEXT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    duration INTEGER,
    PRIMARY KEY(id)
);
CREATE TABLE people (
    id INTEGER,
    name TEXT,
    phone_number TEXT,
    passport_number INTEGER,
    license_plate TEXT,
    PRIMARY KEY(id)
);
CREATE TABLE bakery_security_logs (
    id INTEGER,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    minute INTEGER,
    activity TEXT,
    license_plate TEXT,
    PRIMARY KEY(id)
);

sqlite> SELECT description FROM crime_scene_reports  WHERE month = 7 AND  day = 28 AND street = 'Humphrey Street';
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                       description                                                                                                        |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery. Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery. |
| Littering took place at 16:36. No known witnesses.                                                                                                                                                                       |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

SELECT transcript FROM interviews  WHERE month = 7 AND  day = 28;

sqlite> SELECT transcript FROM interviews  WHERE month = 7 AND  day = 28;
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                                                                     transcript                                                                                                                                                      |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| “Ah,” said he, “I forgot that I had not seen you for some weeks. It is a little souvenir from the King of Bohemia in return for my assistance in the case of the Irene Adler papers.”                                                                                                                               |
| “I suppose,” said Holmes, “that when Mr. Windibank came back from France he was very annoyed at your having gone to the ball.”                                                                                                                                                                                      |
| “You had my note?” he asked with a deep harsh voice and a strongly marked German accent. “I told you that I would call.” He looked from one to the other of us, as if uncertain which to address.                                                                                                                   |
| Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
| "I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
| As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
| Our neighboring courthouse has a very annoying rooster that crows loudly at 6am every day. My sons Robert and Patrick took the rooster to a city far, far away, so it may never bother us again. My sons have successfully arrived in Paris.                                                                        |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

"



sqlite>
SELECT name
FROM people
WHERE people.id IN(
    SELECT id
    FROM people
    WHERE license_plate IN(
        SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND hour = 10 AND minute > 5 AND minute < 20)
    ORDER BY name
);

SELECT transcript
FROM interviews
WHERE day = 28 AND month = 7 AND transcript LIKE "%bakery%";

+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                                                                                                                                     transcript                                                                                                                                                      |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
| "I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
| As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
"

sqlite> SELECT id
   ...>     FROM people
   ...>     WHERE license_plate IN(
   ...>         SELECT license_plate
   ...>     FROM bakery_security_logs
   ...>     WHERE year = 2023
   ...>     AND month = 7
   ...>     AND day = 28
   ...>     AND hour = 10 AND minute > 5 AND minute < 20)
   ...>     ORDER BY name ;
+--------+
|   id   |
+--------+
| 243696 |
| 325548 |
| 686048 |
| 467400 |
| 745650 |
| 221103 |
+--------+
SELECT name
FROM people
WHERE people.id IN(
    SELECT id
    FROM people
    WHERE license_plate IN(
        SELECT license_plate
    FROM bakery_security_logs
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND hour = 10 AND minute > 5 AND minute < 20)
    ORDER BY name
);
+---------+
|  name   |
+---------+
| Vanessa |
| Barry   |
| Brandon |
| Luca    |
| Bruce   |
| Sophia  |
+---------+


Now i have names and their licenceplate in order

|   id   |
+--------+
| 243696 |
| 325548 |
| 686048 |
| 467400 |
| 745650 |
| 221103 |
+--------+

+---------+
|  name   |
+---------+
| Vanessa |
| Barry   |
| Brandon |
| Luca    |
| Bruce   |
| Sophia  |
+---------+

in the transcript they mention how they saw the same person at "legget street" earlier in the day. No specific time, so i will search for the whole day and cross reference with the people and licence plates

SELECT account_number FROM atm_transactions WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street';
+----------------+
| account_number |
+----------------+
| 28500762       |
| 28296815       |
| 76054385       |
| 49610011       |
| 16153065       |
| 86363979       |
| 25506511       |
| 81061156       |
| 26013199       |
+----------------+

SELECT name FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE year = 2023 AND month = 7 AND day = 28 AND atm_location = 'Leggett Street';

+---------+
|  name   |
+---------+
| Bruce   |
| Kaelyn  |
| Diana   |
| Brooke  |
| Kenny   |
| Iman    |
| Luca    |
| Taylor  |
| Benista |
+---------+

Now i know its either Bruce or luca, since they are the only ones listed at both the bakery and atm logs.

The only leads i have to go on, are the fact that the thief had a conversation less than 60 seconds, boking an airplane ticket.

ill seach for phonecalls less than 60 seconds during the whole day


sqlite> SELECT name
   ...> FROM people
   ...> WHERE people.id IN(
   ...>     SELECT id
   ...>     FROM people
   ...>     WHERE phone_number IN(
   ...>         SELECT caller
   ...>     FROM phone_calls
   ...>     WHERE year = 2023
   ...>     AND month = 7
   ...>     AND day = 28
   ...>     AND duration <= 60)
   ...> );
+---------+
|  name   |
+---------+
| Kenny   |
| Sofia   |
| Benista |
| Taylor  |
| Diana   |
| Kelsey  |
| Kathryn |
| Bruce   |
| Carina  |
+---------+

ahaaaaa, ive found the thief, it must be BRUCE!!

in the answers.txt, ill need to find the Accomplice and where he went. since the witness said it would be the earliest flight.

);
CREATE TABLE flights (
    id INTEGER,
    origin_airport_id INTEGER,
    destination_airport_id INTEGER,

Since the airports are dvided in origin and dsetination id, i will need to find the origin id_number of Fiftyville


sqlite> Select id FROM airports WHERE city = 'Fiftyville';
+----+
| id |
+----+
| 8  |
+----+

Fiftyvilles airport id is number 8.

Now i can find the earliest flight from fiftyville thtat morning


sqlite> SELECT * FROM flights
   ...> WHERE origin_airport_id = 8 AND year = 2023 AND month = 7 AND day = 29;
+----+-------------------+------------------------+------+-------+-----+------+--------+
| id | origin_airport_id | destination_airport_id | year | month | day | hour | minute |
+----+-------------------+------------------------+------+-------+-----+------+--------+
| 18 | 8                 | 6                      | 2023 | 7     | 29  | 16   | 0      |
| 23 | 8                 | 11                     | 2023 | 7     | 29  | 12   | 15     |
| 36 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     |
| 43 | 8                 | 1                      | 2023 | 7     | 29  | 9    | 30     |
| 53 | 8                 | 9                      | 2023 | 7     | 29  | 15   | 20     |
+----+-------------------+------------------------+------+-------+-----+------+--------+

The earliest flight is at 8.20

Now i can find the destination

SELECT airports.city FROM airports
JOIN flights On airports.id = destination_airport_id
WHERE origin_airport_id = 8 AND year = 2023 AND month = 7 AND day = 29 AND hour = 8 AND minute = 20;

+---------------+
|     city      |
+---------------+
| New York City |
+---------------+ babyyyyy

Now i just need to find put who called him on his phone which is easy, with the caller table.

SELECT phone_number FROM people WHERE name = 'Bruce';
|  phone_number  |
+----------------+
| (367) 555-5533 |
+----------------+
SELECT name
FROM people
WHERE phone_number IN(
    SELECT receiver
    FROM phone_calls
    WHERE year = 2023
    AND month = 7
    AND day = 28
    AND duration < 60
    AND caller = '(367) 555-5533'
);

| name  |
+-------+
| Robin |
+-------+ Found the guy!!

SO COOL!
