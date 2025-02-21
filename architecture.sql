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
    is_completed bool NOT NULL DEFAULT FALSE,
    UNIQUE (id, pharmacy_id)
);

CREATE TABLE items (
    id serial PRIMARY KEY, 
    price decimal(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    pharmacy_id int NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE,
    medicine_id int NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
    UNIQUE (id, pharmacy_id),
    CONSTRAINT unique_item_pharmacy UNIQUE (medicine_id, pharmacy_id)
);

CREATE TABLE order_items (
    order_id int NOT NULL,
    item_id int NOT NULL,
    pharmacy_id int NOT NULL,
    quantity int NOT NULL CHECK (quantity > 0),
    sub_total decimal(10,2) NOT NULL CHECK (sub_total > 0),
    PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_order FOREIGN KEY (order_id, pharmacy_id) 
        REFERENCES orders(id, pharmacy_id) ON DELETE CASCADE,
    CONSTRAINT fk_item FOREIGN KEY (item_id, pharmacy_id) 
        REFERENCES items(id, pharmacy_id) ON DELETE CASCADE
);


INSERT INTO address (city, district, street, build_number) 
VALUES
('Kyiv', 'Shevchenkivskyi', 'Khreshchatyk', 12),
('Lviv', 'Halytskyi', 'Svobody', 10),
('Odesa', 'Primorskyi', 'Deribasivska', 5),
('Kharkiv', 'Centralnyi', 'Sumskaya', 1),
('Dnipro', 'Sverdlovskyi', 'Lenina', 2);

INSERT INTO doses (amount, unit) 
VALUES
(500, 'mg'),
(250, 'mg'),
(100, 'mg'),
(200, 'mg'),
(10, 'mg');

INSERT INTO medicines (name, active_substance, dosage_id) 
VALUES
('Paracetamol', 'Paracetamol', 1),
('Aspirin', 'Acetylsalicylic acid', 2),
('Ibuprofen', 'Ibuprofen', 3),
('Metformin', 'Metformin', 4),
('Amoxicillin', 'Amoxicillin', 5);

INSERT INTO pharmacies (name, address_id, phone) 
VALUES
('Pharmacy 1', 1, '+380501234567'),
('Pharmacy 2', 2, '+380501234568'),
('Pharmacy 3', 3, '+380501234569'),
('Pharmacy 4', 4, '+380501234570'),
('Pharmacy 5', 5, '+380501234575');

INSERT INTO items (price, stock_quantity, pharmacy_id, medicine_id) 
VALUES
(10.5, 100, 1, 1), 
(15.0, 50, 1, 2), 
(20.0, 80, 2, 3), 
(25.0, 30, 3, 4), 
(30.0, 60, 4, 5); 

INSERT INTO users (first_name, last_name, email) 
VALUES
('John', 'Doe', 'john.doe@email.com'),
('Jane', 'Smith', 'jane.smith@email.com'),
('Mark', 'Johnson', 'mark.johnson@email.com'),
('Emily', 'Davis', 'emily.davis@email.com'),
('Michael', 'Brown', 'michael.brown@email.com');

INSERT INTO orders (user_id, pharmacy_id, total_price, is_completed)
VALUES
(1, 1, 30.0, false), 
(2, 2, 35.0, false), 
(3, 3, 40.0, false), 
(4, 4, 45.0, false), 
(5, 5, 50.0, false); 


INSERT INTO order_items (order_id, item_id, pharmacy_id, quantity, sub_total)
VALUES
(1, 1, 1, 2, 21.0), 
(1, 2, 1, 1, 15.0), 
(2, 3, 2, 3, 60.0), 
(3, 4, 3, 1, 25.0), 
(4, 5, 4, 2, 60.0); 


INSERT INTO order_items (order_id, item_id, pharmacy_id, quantity, sub_total)
VALUES
(2, 1, 2, 1, 20.0); 