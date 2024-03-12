SELECT movies.title FROM movies

JOIN stars ON stars.movie_id = movies.id
JOIN people ON stars.person_id = people.id
WHERE name IN ('Bradley Cooper', 'Jennifer Lawrence')
GROUP By movies.id, title
HAVING COUNT(*)=2;


