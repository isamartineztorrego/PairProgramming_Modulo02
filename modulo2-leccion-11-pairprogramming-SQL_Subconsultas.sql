/* 1. Extraed los pedidos con el máximo "order_date" para cada empleado.
Nuestro jefe quiere saber la fecha de los pedidos más recientes que ha gestionado cada empleado. 
Para eso nos pide que lo hagamos con una query correlacionada. */
-- Devuelve todos los employee_id con sus últimos order_date correspondientes (la fecha de sus últimos pedidos)
SELECT order_id AS OrderID, customer_id AS CustomerID, employee_id AS EmployeeID, order_date AS OrderDate, required_date AS RequiredDate
FROM orders AS O1
WHERE order_date =
	(SELECT MAX(order_date)
	FROM orders AS O2
    WHERE O1.employee_id = O2.employee_id);

/* 2. Extraed el precio unitario máximo (unit_price) de cada producto vendido.
Supongamos que ahora nuestro jefe quiere un informe de los productos vendidos y su precio unitario. 
De nuevo lo tendréis que hacer con queries correlacionadas. */
-- ******* El resultado da correcto sólo añadiendo el alias (si ponemos la columna order_details. no funciona).
SELECT DISTINCT o1.product_id, o1.unit_price AS max_unit_price_sold
FROM order_details AS o1
WHERE o1.unit_price =
	(SELECT MAX(unit_price)
    FROM order_details AS o2
    WHERE o1.product_id = o2.product_id)
ORDER BY product_id;

/* 3. Extraed información de los productos "Beverages"
En este caso nuestro jefe nos pide que le devolvamos toda la información necesaria para identificar un tipo de producto. 
En concreto, tienen especial interés por los productos con categoría "Beverages". 
Devuelve el ID del producto, el nombre del producto y su ID de categoría. */
SELECT product_id, product_name, category_id
FROM products
WHERE category_id =
	(SELECT category_id
    FROM categories
    WHERE products.category_id = categories.category_id);

/* 4. Extraed la lista de países donde viven los clientes, pero no hay ningún proveedor ubicado en ese país.
Suponemos que si se trata de ofrecer un mejor tiempo de entrega a los clientes, entonces podría dirigirse a estos países para buscar proveedores adicionales. */
SELECT country, company_name
FROM customers
WHERE NOT EXISTS
	(SELECT country
	FROM suppliers
    WHERE customers.country = suppliers.country);
-- Estos dos scripts dan el mismo resultado (NOT EXISTS y NOT IN)
SELECT country
FROM customers
WHERE country NOT IN
	(SELECT country
	FROM suppliers);

/* 5. Extraer los clientes que compraron mas de 20 articulos "Grandma's Boysenberry Spread".
Extraed el OrderId y el nombre del cliente que pidieron más de 20 artículos del producto "Grandma's Boysenberry Spread" (ProductID 6) en un solo pedido. */
-- Funciona perfectamente pero no entendemos por qué el >20 no está dentro de la consulta a order_details (en orders no hay quantity)
SELECT order_id, customer_id
FROM orders
WHERE
	(SELECT quantity
    FROM order_details
    INNER JOIN products USING(product_id) -- usamos USING porque la columna product_id es igual en ambas tablas (order_details y products)
    WHERE orders.order_id = order_details.order_id AND product_name = "Grandma's Boysenberry Spread")
> 20;

/* BONUS:
6. Qué producto es más popular.
Extraed cuál es el producto que más ha sido comprado y la cantidad que se compró. */
SELECT SUM(quantity) AS Cantidad, product_name
FROM order_details
INNER JOIN products
ON order_details.product_id = products.product_id
GROUP BY product_name
HAVING Cantidad =
	(SELECT MAX(Cantidad)
    FROM
		(SELECT product_id, SUM(quantity) AS Cantidad
        FROM order_details
        GROUP BY product_id) AS t); -- sin este alias (AS t) no funciona el código