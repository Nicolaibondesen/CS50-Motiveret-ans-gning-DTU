SELECT distinct(name) FROM people

JOIN movies ON stars.movie_id = movies.id
JOIN stars ON people.id = stars.person_id
WHERE title IN(
    SELECT distinct(title) FROM people
    JOIN stars ON people.id = stars.person_id
    JOIN movies ON stars.movie_id = movies.id
    WHERE name = 'Kevin Bacon' AND birth = 1958
) AND name != 'Kevin Bacon' ORDER BY name;
