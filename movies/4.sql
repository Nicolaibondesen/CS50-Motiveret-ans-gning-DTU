Select COUNT(title)
FROM movies
Where id
IN (SELECT movie_id FROM ratings WHERE rating = 10.0);
