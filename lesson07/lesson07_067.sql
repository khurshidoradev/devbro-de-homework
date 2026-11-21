-- 1. Создать представление, которое выводит следующие колонки:
-- order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, 
-- first_name, title из таблиц orders, customers и employees.
-- Сделать select к созданному представлению, выведя все записи, где order_date больше 1го января 1997 года.

CREATE VIEW oce AS
SELECT o.order_date, o.required_date, o.shipped_date, o.ship_postal_code, c.company_name, c.contact_name,
       c.phone, e.last_name, e.first_name, e.title
FROM orders o
JOIN customers c USING (customer_id)
JOIN employees e USING (employee_id);

SELECT *
FROM oce
WHERE order_date > '1997-01-01';

-- 2. Создать представление, которое выводит следующие колонки:
-- order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone,
-- last_name, first_name, title из таблиц orders, customers, employees.
-- Попробовать добавить к представлению (после его создания) колонки ship_country, postal_code и reports_to.
-- Убедиться, что проихсодит ошибка. Переименовать представление и создать новое уже с дополнительными колонками.
-- Сделать к нему запрос, выбрав все записи, отсортировав их по ship_county.
-- Удалить переименованное представление.

CREATE VIEW oce_2 AS
SELECT o.order_date, o.required_date, o.shipped_date, o.ship_postal_code, o.ship_country, c.company_name,
       c.contact_name, c.phone, e.last_name, e.first_name, e.title
FROM orders o
JOIN customers c USING (customer_id)
JOIN employees e USING (employee_id);

CREATE OR REPLACE VIEW oce_2 AS
SELECT postal_code, reports_to 
FROM employees; -- происходит ошибка

ALTER VIEW oce_2 RENAME TO oce_old;

CREATE VIEW oce_2 AS
SELECT o.order_date, o.required_date, o.shipped_date, o.ship_postal_code, o.ship_country, c.company_name,
       c.contact_name, c.phone, e.last_name, e.first_name, e.title, e.postal_code, e.reports_to 
FROM orders o
JOIN customers c USING (customer_id)
JOIN employees e USING (employee_id);

SELECT *
FROM oce_2
ORDER BY ship_country;

DROP VIEW oce_old;

-- 3.  Создать представление "активных" (discontinued = 0) продуктов, содержащее все колонки. Представление
-- должно быть защищено от вставки записей, в которых discontinued = 1.
-- Попробовать сделать вставку записи с полем discontinued = 1 - убедиться, что не проходит.

CREATE VIEW actives AS
SELECT *
FROM products
WHERE discontinued = 0
WITH LOCAL CHECK OPTION;

INSERT INTO actives
VALUES ('81', 'notebook', '20', null, null, '5', '58', null, null, '1'); -- запись не прошел