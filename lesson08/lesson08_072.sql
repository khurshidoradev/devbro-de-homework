-- 1. Выполните следующий код (записи необходимы для тестирования корректности выполнения ДЗ):
-- insert into customers(customer_id, contact_name, city, country, company_name)
-- values 
-- ('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
-- ('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');
-- После этого выполните задание:
-- Вывести имя контакта заказчика, его город и страну, отсортировав по возрастанию по имени контакта и городу,
-- а если город равен NULL, то по имени контакта и стране. Проверить результат, используя заранее вставленные строки.

INSERT INTO customers(customer_id, contact_name, city, country, company_name)
VALUES
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

SELECT contact_name, city, country
FROM customers
ORDER BY contact_name,
	CASE WHEN city IS NULL THEN country
		 ELSE city
	END;

-- 2. Вывести наименование продукта, цену продукта и столбец со значениями
-- too expensive если цена >= 100
-- average если цена >=50 но < 100
-- low price если цена < 50

SELECT product_name, unit_price, 
	CASE WHEN unit_price >= 100 THEN 'too expensive'
        WHEN unit_price >= 50 AND unit_price < 100 THEN 'average'
		WHEN unit_price < 50 THEN 'low price'
		ELSE 'undetermined'
	END AS price_description
FROM products;

-- 3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и значение 'no orders' если order_id = NULL.

SELECT c.contact_name,
	CASE WHEN o.order_id IS NULL THEN 'no orders'
	END AS order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 4. Вывести ФИО сотрудников и их должности. В случае если должность = Sales Representative вывести вместо неё Sales Stuff.

SELECT last_name, first_name, 
	CASE WHEN title = 'Sales Representative' THEN 'Sales Stuff'
		 ELSE title
	END 
FROM employees;