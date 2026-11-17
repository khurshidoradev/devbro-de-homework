-- 1. Вывести продукты количество которых в продаже меньше самого малого среднего количества 
-- продуктов в деталях заказов (группировка по product_id). 
-- Результирующая таблица должна иметь колонки product_name и units_in_stock.

SELECT product_name, units_in_stock
FROM products 
WHERE  units_in_stock < ALL (SELECT AVG (quantity)
                          FROM order_details
						  GROUP BY product_id)
GROUP BY product_id ;

-- 2. Напишите запрос, который выводит общую сумму фрахтов заказов для компаний-заказчиков для 
-- заказов, стоимость фрахта которых больше или равна средней величине стоимости фрахта всех 
-- заказов, а также дата отгрузки заказа должна находится во второй половине июля 1996 года.
-- Результирующая таблица должна иметь колонки customer_id и freight_sum, строки которой должны
-- быть отсортированы по сумме фрахтов заказов.

SELECT o.customer_id, SUM(o.freight) freight_sum
FROM orders o
WHERE o.freight >= (SELECT AVG(o2.freight)
                   FROM orders o2
				   WHERE o2.customer_id = o.customer_id)
AND shipped_date BETWEEN '1996-07-16' AND '1996-07-31'
GROUP BY o.customer_id
ORDER BY freight_sum

-- 3. Напишите запрос, который выводит 3 заказа с наибольшей стоимостью, которые были созданы 
-- после 1 сентября 1997 года включительно и были доставлены в страны Южной Америки. Общая 
-- стоимость рассчитывается как сумма стоимости деталей заказа с учетом дисконта. Результирующая
-- таблица должна иметь колонки customer_id, ship_country и order_price, строки которой должны 
-- быть отсортированы по стоимости заказа в обратном порядке.

SELECT o.customer_id, o.ship_country, SUM(od.quantity * unit_price * (1 - discount)) AS order_price
FROM orders o
JOIN order_details od USING (order_id)
WHERE order_date >= '1997-09-01'
AND ship_country IN ('Argentina','Brazil','Venezuela')
GROUP BY o.order_id, o.customer_id, o.ship_country
ORDER BY order_price DESC
LIMIT 3

-- 4. Вывести все товары (уникальные названия продуктов), которых заказано ровно 10 единиц
-- (конечно же, это можно решить и без подзапроса).

SELECT DISTINCT product_name
FROM products p
JOIN order_details od USING (product_id)
WHERE od.quantity = '10'
