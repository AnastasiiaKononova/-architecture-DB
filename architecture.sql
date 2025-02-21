CREATE TABLE address (
    id serial PRIMARY KEY,
    city varchar(300) NOT NULL CHECK (city != ''),
    district varchar(300) NOT NULL CHECK (district != ''),
    street varchar(300) NOT NULL CHECK (street != ''),
    build_number int NOT NULL CHECK (build_number > 0)
);

CREATE TABLE doses (
    id serial PRIMARY KEY,
    amount decimal(10,2) NOT NULL CHECK (amount > 0),
    unit varchar(50) NOT NULL CHECK (unit != '')
);

CREATE TABLE medicines (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    active_substance varchar(300) NOT NULL CHECK (active_substance != ''),
    dosage_id int NOT NULL REFERENCES doses(id) ON DELETE CASCADE
);

CREATE TABLE pharmacies (
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL CHECK (name != ''),
    phone VARCHAR(20) UNIQUE NOT NULL CHECK(phone ~ '^\+\d{1,3}\d{4,14}$'),
    address_id int NOT NULL REFERENCES address(id) ON DELETE CASCADE
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
    is_completed bool NOT NULL DEFAULT FALSE
);
ALTER TABLE orders DROP COLUMN pharmacy_id;

CREATE TABLE items (
    id serial PRIMARY KEY, 
    price decimal(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    pharmacy_id int NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE,
    medicine_id int NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
    UNIQUE (id, pharmacy_id),
    CONSTRAINT unique_item_pharmacy UNIQUE (medicine_id, pharmacy_id)
);
ALTER TABLE items DROP CONSTRAINT unique_item_pharmacy;

CREATE TABLE order_items (
    order_id int NOT NULL,
    item_id int NOT NULL,
    quantity int NOT NULL CHECK (quantity > 0),
    sub_total decimal(10,2) NOT NULL CHECK (sub_total > 0),
    PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id) 
        REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_item FOREIGN KEY (item_id) 
        REFERENCES items(id) ON DELETE CASCADE
);

INSERT INTO address (city, district, street, build_number)
VALUES 
('Киев', 'Печерский', 'Грушевского', 9),
('Одесса', 'Приморский', 'Дерибасовская', 12);

INSERT INTO doses (amount, unit)
VALUES 
(5.0, 'mg'),
(10.0, 'mg');

INSERT INTO medicines (name, active_substance, dosage_id)
VALUES 
('Парацетамол', 'Парацетамол', 1),
('Ибупрофен', 'Ибупрофен', 2);

INSERT INTO pharmacies (name, phone, address_id)
VALUES 
('Аптека №1', '+380501234567', 1),
('Аптека №2', '+380504567890', 2);

INSERT INTO users (first_name, last_name, email)
VALUES 
('Иван', 'Иванов', 'ivanov@example.com'),
('Мария', 'Петрова', 'petrova@example.com');

INSERT INTO orders (user_id, pharmacy_id, total_price, is_completed)
VALUES 
(3, 2, 100.50, FALSE);
(4, 2, 200.00, TRUE);

INSERT INTO items (price, stock_quantity, pharmacy_id, medicine_id)
VALUES 
(10.0, 50, 2, 1),  
(20.0, 100, 2, 1); 
(25.0, 20, 2, 1),  
(35.0, 40, 2, 2); 

INSERT INTO order_items (order_id, item_id, quantity, sub_total)
VALUES 
(5, 16, 2, 40.00);  
(3, 10, 1, 30.00),  
(4, 11, 1, 25.00),  
(4, 12, 2, 70.00);  


SELECT o.user_id, i.pharmacy_id, COUNT(DISTINCT o.id) AS order_count
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN items i ON oi.item_id = i.id
GROUP BY o.user_id, i.pharmacy_id
HAVING COUNT(DISTINCT o.id) > 0;
