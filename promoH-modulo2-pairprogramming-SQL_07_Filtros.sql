/* 1. Ciudades que empiezan con "A" o "B".
Por un extraño motivo, nuestro jefe quiere que le devolvamos una tabla con aquelas compañias que están afincadas en ciudades que empiezan por "A" o "B". 
Necesita que le devolvamos la ciudad, el nombre de la compañia y el nombre de contacto. */
SELECT city, customer_name AS CompanyName, CONCAT(contact_first_name, " ", contact_last_name) AS ContactName
FROM customers
WHERE city LIKE "A%" OR city LIKE "B%"
ORDER BY city;

/* 2. Número de pedidos que han hecho en las ciudades que empiezan con L.
En este caso, nuestro objetivo es devolver los mismos campos que en la query anterior el número de total de pedidos que han hecho todas las ciudades que empiezan por "L". */
SELECT city AS "ciudad", customer_name AS empresa, CONCAT(contact_first_name, " ", contact_last_name) AS persona_contacto, COUNT(order_number) AS "numero_pedidos"
FROM customers
INNER JOIN orders
ON customers.customer_number = orders.customer_number
WHERE city LIKE "L%"
GROUP BY city, customer_name, contact_first_name, contact_last_name;

/* 3. Todos los clientes cuyo "country" no incluya "USA".
Nuestro objetivo es extraer los clientes que no sean de USA. 
Extraer el nombre de contacto, su pais y el nombre de la compañia. */
SELECT CONCAT(contact_first_name, " ", contact_last_name) AS persona_contacto, country, customer_name
FROM customers
WHERE country NOT IN ("USA");

-- La finalidad del "LIKE" no es buscar por palabras, sino por estructuras, pero lo añadimos como opción porque da el mismo resultado.
SELECT CONCAT(contact_first_name, " ", contact_last_name) AS persona_contacto, country, customer_name
FROM customers
WHERE country NOT LIKE "USA";

/* 4. Todos los clientes que no tengan una "A" en segunda posición en su nombre.
Devolved unicamente el nombre de contacto. */
SELECT CONCAT(contact_first_name, " ", contact_last_name) AS ContactName
FROM customers
WHERE contact_first_name NOT LIKE "_A%";

/* 5. Extraer toda la información sobre las compañias que tengamos en la BBDD
Nuestros jefes nos han pedido que creemos una query que nos devuelva todos los clientes y proveedores que tenemos en la BBDD. 
Mostrad la ciudad a la que pertenecen, el nombre de la empresa y el nombre del contacto, además de la relación (Proveedor o Cliente). 
Pero importante! No debe haber duplicados en nuestra respuesta. 
La columna Relationship no existe y debe ser creada como columna temporal. 
Para ello añade el valor que le quieras dar al campo y utilizada como alias Relationship.
Nota: Deberás crear esta columna temporal en cada instrucción SELECT. */
SELECT city, customer_name AS CompanyName, CONCAT(contact_first_name, " ", contact_last_name) AS ContactName, "Customers" AS Relationship
FROM customers
UNION
SELECT city, product_vendor AS CompanyName, CONCAT(contact_first_name, " ", contact_last_name) AS ContactName, "Suppliers" AS Relationship
FROM suppliers;
-- Necesitamos que exista una tabla llamada "Suppliers" para que la solución anterior sea correcta.

/* 6. Extraer todas las categorías de la tabla categories que contengan en la descripción "sweet" o "Sweet". */
-- No se puede realizar el ejercicio porque las tablas no existen en esta versión de base de datos.

/* 7. Extraed todos los nombres y apellidos de los clientes y empleados que tenemos en la BBDD:
💡 Pista 💡 ¿Ambas tablas tienen las mismas columnas para nombre y apellido? 
Tendremos que combinar dos columnas usando concat para unir dos columnas. */
SELECT CONCAT(contact_first_name, " ", contact_last_name) AS ContactName, "Customers" AS Relacion
FROM customers
UNION
SELECT CONCAT(first_name, " ", last_name) AS ContactName, "Employees" AS Relacion
FROM employees;