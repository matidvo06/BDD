/*
Con la base de datos “movies”, se propone crear una tabla temporal llamada “TWD” y guardar en la misma los episodios de todas las temporadas de “The Walking Dead”.
Realizar una consulta a la tabla temporal para ver los episodios de la primera temporada.
En la base de datos “movies”, seleccionar una tabla donde crear un índice y luego chequear la creación del mismo. 
Analizar por qué crearía un índice en la tabla indicada y con qué criterio se elige/n el/los campos.

Tomando la base de datos movies_db.sql, se solicita:
1. Agregar una película a la tabla movies.
2. Agregar un género a la tabla genres.
3. Asociar a la película del punto 1. genre el género creado en el punto 2.
4. Modificar la tabla actors para que al menos un actor tenga como favorita la película agregada en el punto 1.
5. Crear una tabla temporal copia de la tabla movies.
6. Eliminar de esa tabla temporal todas las películas que hayan ganado menos de 5 awards.
7. Obtener la lista de todos los géneros que tengan al menos una película.
8. Obtener la lista de actores cuya película favorita haya ganado más de 3 awards.
9. Crear un índice sobre el nombre en la tabla movies.
10. Chequee que el índice fue creado correctamente.
11. En la base de datos movies ¿Existiría una mejora notable al crear índices? Analizar y justificar la respuesta.
12. ¿En qué otra tabla crearía un índice y por qué? Justificar la respuesta
*/

/*Crear la tabla con lo requerido*/
CREATE TEMPORARY TABLE TWD
SELECT e.*
FROM episodes e
INNER JOIN seasons s ON e.season_id = s.id
INNER JOIN series se ON s.serie_id = se.id
WHERE se.title = 'The Walking Dead';

/*Ver los episodios de la 1ra temp*/
SELECT *
FROM TWD
WHERE season_id = (SELECT id FROM seasons WHERE number = 1 AND serie_id = (SELECT id FROM series WHERE title = 'The Walking Dead'));

/*Crear índice en movies*/
CREATE INDEX ejemplo_idx ON movies (column1, column2);

/* 1 */
INSERT INTO movies (title, rating, awards, release_date, length, genre_id)
VALUES ('Nueva Película', 7.5, 3, '2023-04-24', 120, 1);

/* 2 */
INSERT INTO genres (name, ranking, active)
VALUES ('Nuevo género', 1, 1);

/* 3 */
UPDATE movies
SET genre_id = 1
WHERE title = 'Nueva Película';

/* 4 */
UPDATE actors
SET favorite_movie_id = 1
WHERE id = 1;

/* 5 */
CREATE TEMPORARY TABLE tmp_movies AS SELECT * FROM movies;
DELETE FROM tmp_movies WHERE awards < 5;

/* 6 */
SELECT genres.name
FROM genres
INNER JOIN movies ON genres.id = movies.genre_id
GROUP BY genres.id
HAVING COUNT(*) >= 1;

/* 7 */
SELECT actors.first_name, actors.last_name
FROM actors
INNER JOIN movies ON actors.favorite_movie_id = movies.id
WHERE movies.awards > 3;

/* 8 */
CREATE INDEX idx_title ON movies (title);
SHOW INDEXES FROM movies;

/* 9 
En esta BDD se podrían crear índices en la tabla MOVIES para acelerar la búsqueda de películas por título o por género_id. Además, podría ser útil crear
un índice en la tabla ACTORS para acelerar la búsqueda de actores por nombre o favorite_movie_id.

10
Depende de las necesidades específicas de cada aplicación y de las consultas más frecuentes. Por ej: si se realizan consultas frecuentes para buscar 
episodios de una temporada en particular, se podría considerar la creación de un índice en la tabla EPISODES para acelerar estas consultas.
*/



