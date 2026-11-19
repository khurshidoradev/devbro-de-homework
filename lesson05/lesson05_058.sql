-- 1. Создать таблицу exam с полями:
-- идентификатора экзамена - автоинкрементируемый, уникальный, запрещает NULL;
-- наименования экзамена
-- даты экзамена

CREATE TABLE exam
(
   exam_id serial UNIQUE NOT NULL,
   exam_name varchar,
   exam_date date
);

-- 2. Удалить ограничение уникальности с поля идентификатора

ALTER TABLE exam
DROP CONSTRAINT exam_exam_id_key;

--3. Добавить ограничение первичного ключа на поле идентификатора

ALTER TABLE exam
ADD PRIMARY KEY (exam_id);

-- 4. Создать таблицу person с полями
-- идентификатора личности (простой int, первичный ключ)
-- имя
-- фамилия

CREATE TABLE person
(
  personal_id int PRIMARY KEY,
  first_name varchar,
  last_name varchar
);


-- 5. Создать таблицу паспорта с полями:
-- идентификатора паспорта (простой int, первичный ключ)
-- серийный номер (простой int, запрещает NULL)
-- регистрация
-- ссылка на идентификатор личности (внешний ключ)

CREATE TABLE passport
(
  passport_id int PRIMARY KEY,
  serial_num int NOT NULL,
  registration date,
  personal_id int,

  CONSTRAINT FK_passport_person FOREIGN KEY (personal_id) REFERENCES person(personal_id)
);

-- 6. Добавить колонку веса в таблицу book (создавали ранее) с ограничением, проверяющим вес (больше 0 но меньше
-- 100)

ALTER TABLE book
ADD COLUMN weight numeric CONSTRAINT CHK_book_weight CHECK (weight > 0 AND weight < 100);

-- 7. Убедиться в том, что ограничение на вес работает (попробуйте вставить невалидное значение)

INSERT INTO book
VALUES 
(1,'title', 'isbn', 1, 108);

INSERT INTO book
VALUES 
(1,'title', 'isbn', 1, 57);

SELECT * FROM book; -- работает отлично

-- 8. Создать таблицу student с полями:
-- идентификатора (автоинкремент)
-- полное имя
-- курс (по умолчанию 1)

CREATE TABLE student
(
  student_id serial,
  full_name varchar,
  course int DEFAULT '1'
);

-- 9. Вставить запись в таблицу студентов и убедиться, что ограничение на вставку значения по умолчанию работает

INSERT INTO student (full_name)
VALUES 
('Kitty Song Covey');

SELECT * FROM student; -- работает

-- 10. Удалить ограничение "по умолчанию" из таблицы студентов

ALTER TABLE student
ALTER COLUMN course DROP DEFAULT;

-- 11. Подключиться к БД northwind и добавить ограничение на поле unit_price таблицы products (цена должна быть
-- больше 0)

ALTER TABLE products
ADD CONSTRAINT CHK_products_price CHECK (unit_price > 0);

-- 12. "Навесить" автоинкрементируемый счётчик на поле product_id таблицы products (БД northwind). Счётчик должен
-- начинаться с числа следующего за максимальным значением по этому столбцу.

CREATE SEQUENCE products_product_id_seq
OWNED BY products.product_id;

ALTER TABLE products
ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq');

SELECT setval('products_product_id_seq', (SELECT MAX(product_id)
                                          FROM products)) ;

--13. Произвести вставку в products (не вставляя идентификатор явно) и убедиться, что автоинкремент работает.
-- Вставку сделать так, чтобы в результате команды вернулось значение, сгенерированное в качестве идентификатора.

INSERT INTO products(product_name, discontinued)
VALUES ('book', '0')
