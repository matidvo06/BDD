/*
Se tiene el siguiente DER que corresponde al esquema que presenta la base de datos de una “biblioteca”.
En base al mismo, plantear las consultas SQL para resolver los siguientes requerimientos:
1. Listar los datos de los autores.
2. Listar nombre y edad de los estudiantes
3. ¿Qué estudiantes pertenecen a la carrera informática?
4. ¿Qué autores son de nacionalidad francesa o italiana?
5. ¿Qué libros no son del área de internet?
6. Listar los libros de la editorial Salamandra.
7. Listar los datos de los estudiantes cuya edad es mayor al promedio.
8. Listar los nombres de los estudiantes cuyo apellido comience con la letra G.
9. Listar los autores del libro “El Universo: Guía de viaje”. (Se debe listar solamente los nombres).
10. ¿Qué libros se prestaron al lector “Filippo Galli”?
11. Listar el nombre del estudiante de menor edad.
12. Listar nombres de los estudiantes a los que se prestaron libros de Base de Datos.
13. Listar los libros que pertenecen a la autora J.K. Rowling.
14. Listar títulos de los libros que debían devolverse el 16/07/2021.
Implementar la base de datos en PHPMyAdmin o MySQL Workbench, cargar cinco registros en cada tabla y probar algunas consultas planteadas en el Ejercicio 1. 
*/

/* 1 */
SELECT * FROM autor;

/* 2 */
SELECT Nombre, Edad FROM estudiante;

/* 3 */
SELECT Nombre, ApellidoFROM estudiante WHERE Carrera = 'Informática';

/* 4 */
SELECT Nombre FROM autor WHERE Nacionalidad = 'Francesa' OR Nacionalidad = 'Italiana';

/* 5 */
SELECT * FROM libro WHERE Area != 'Internet';

/* 6 */
SELECT * FROM libro WHERE Editorial = 'Salamandra';

/* 7 */
SELECT * FROM estudiante WHERE Edad > (SELECT AVG(Edad) FROM estudiante);

/* 8 */
SELECT Nombre FROM estudiante WHERE apellido LIKE 'G%';

/* 9 */
SELECT autor.Nombre FROM autor
JOIN libroautor ON autor.idAutor = libroautor.idAutor
JOIN libro ON libro.idLibro = libroautor.idLibro
WHERE libro.Titulo = 'El Universo: Guía de viaje';

/* 10 */
SELECT libro.Titulo FROM libro
JOIN libroautor ON libro.idLibro = libroautor.idLibro
JOIN prestamo ON libroautor.idLibro = prestamo.idLibro
JOIN estudiante ON prestamo.idLector = estudiante.idLector
WHERE estudiante.Nombre = 'Filippo' AND estudiante.Apellido = 'Galli';

/* 11 */
SELECT Nombre FROM estudiante ORDER BY Edad LIMIT 1;

/* 12 */
SELECT estudiante.Nombre FROM estudiante
JOIN prestamo ON estudiante.idLector = prestamo.idLector
JOIN libro on prestamo.idLibro = libro.idLibro
WHERE libro.Area = 'Base de Datos';

/* 13 */
SELECT libro.Titulo FROM libro
JOIN libroautor ON libro.idLibro = libroautor.idLibro
JOIN autor ON libroautor.idAutor = autor.idAutor
WHERE autor.Nombre = 'J.K Rowling';

/* 14 */
SELECT libro.Titulo FROM libro
JOIN prestamo ON libro.idLibro = prestamo.idLibro
WHERE prestamo.FechaDevolucion = '2021-07-16';

