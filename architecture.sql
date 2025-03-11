CREATE TABLE medicines (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    active_substance varchar(300) NOT NULL CHECK (active_substance != ''),
    amount decimal(10,2) NOT NULL CHECK (amount > 0),
    unit varchar(50) NOT NULL CHECK (unit != '')
);

CREATE TABLE pharmacies (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    phone VARCHAR(20) UNIQUE NOT NULL CHECK(phone ~ '^\+\d{1,3}\d{4,14}$'),
    city varchar(300) NOT NULL CHECK (city != ''),
    district varchar(300) NOT NULL CHECK (district != ''),
    street varchar(300) NOT NULL CHECK (street != ''),
    build_number int NOT NULL CHECK (build_number > 0)
);

CREATE TABLE users (
    id serial PRIMARY KEY,
    first_name varchar(300) NOT NULL CHECK (first_name != ''),
    last_name varchar(300) NOT NULL CHECK (last_name != ''),
    email varchar(300) NOT NULL CHECK (email != '')
);

CREATE TABLE orders (
    id serial PRIMARY KEY,
    user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    pharmacy_id INT NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE, 
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    total_price decimal(10,2) NOT NULL CHECK (total_price > 0),
    is_completed bool NOT NULL DEFAULT FALSE,
    UNIQUE (id, pharmacy_id) -- Гарантирует, что заказ привязан к одной аптеке
);

CREATE TABLE items (
    id serial PRIMARY KEY, 
    price decimal(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    pharmacy_id int NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE, -- товар может быть добавлен в заказ только из той аптеки, которая его продает
    medicine_id int NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
    UNIQUE (id, pharmacy_id),
    CONSTRAINT unique_item_pharmacy UNIQUE (medicine_id, pharmacy_id) -- Уникальность товара в аптеке
);

CREATE TABLE order_items (
    order_id int NOT NULL,
    item_id int NOT NULL,
    pharmacy_id int NOT NULL,
    quantity int NOT NULL CHECK (quantity > 0),
    sub_total decimal(10,2) NOT NULL CHECK (sub_total > 0),
    PRIMARY KEY (order_id, item_id), -- Гарантирует уникальность записей
    CONSTRAINT fk_order FOREIGN KEY (order_id, pharmacy_id) -- Проверяет, что заказ относится к аптеке
        REFERENCES orders(id, pharmacy_id) ON DELETE CASCADE,
    CONSTRAINT fk_item FOREIGN KEY (item_id, pharmacy_id) -- Проверяет, что товар в заказе относится к той же аптеке
        REFERENCES items(id, pharmacy_id) ON DELETE CASCADE
);




-- INSERT INTO users (first_name, last_name, email) 
-- VALUES ('Иван', 'Петров', 'ivan.petrov@example.com');

-- INSERT INTO pharmacies (name, phone, city, district, street, build_number) 
-- VALUES ('Аптека 1', '+380971234567', 'Киев', 'Шевченковский', 'Тарасовская', 5),
--        ('Аптека 2', '+380972345678', 'Киев', 'Дарницкий', 'Лесная', 12);

-- INSERT INTO medicines (name, active_substance, amount, unit) 
-- VALUES ('Парацетамол', 'Парацетамол', 500, 'мг');

-- INSERT INTO items (price, stock_quantity, pharmacy_id, medicine_id) 
-- VALUES (50.00, 100, 1, 1), -- Аптека 1
--        (55.00, 50, 2, 1);  -- Аптека 2 (тот же препарат)

-- -- Создаем заказ в первой аптеке
-- INSERT INTO orders (user_id, pharmacy_id, total_price, is_completed) 
-- VALUES (1, 1, 150.00, FALSE);

-- -- Добавляем товар из первой аптеки
-- INSERT INTO order_items (order_id, item_id, pharmacy_id, quantity, sub_total) 
-- VALUES (1, 1, 1, 3, 150.00);

-- -- Пробуем добавить товар из другой аптеки
-- INSERT INTO order_items (order_id, item_id, pharmacy_id, quantity, sub_total) 
-- VALUES (1, 2, 2, 2, 110.00);
