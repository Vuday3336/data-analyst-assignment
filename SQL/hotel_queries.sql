-- ===============================
-- DROP TABLES (to avoid errors)
-- ===============================
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS items;

-- ===============================
-- CREATE TABLES
-- ===============================
CREATE TABLE users (
    user_id VARCHAR(50),
    name VARCHAR(100),
    phone_number VARCHAR(15),
    mail_id VARCHAR(100),
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id VARCHAR(50),
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50)
);

CREATE TABLE booking_commercials (
    id VARCHAR(50),
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity FLOAT
);

CREATE TABLE items (
    item_id VARCHAR(50),
    item_name VARCHAR(100),
    item_rate INT
);

-- ===============================
-- INSERT DATA (IMPORTANT FIXED DATA)
-- ===============================
INSERT INTO users VALUES
('u1','John','9999999999','john@gmail.com','Address1'),
('u2','Mike','8888888888','mike@gmail.com','Address2');

INSERT INTO items VALUES
('i1','Paratha',20),
('i2','Veg Curry',100),
('i3','Rice',50);

INSERT INTO bookings VALUES
('b1','2021-11-10','r1','u1'),
('b2','2021-11-11','r2','u1'),
('b3','2021-11-12','r3','u2');

INSERT INTO booking_commercials VALUES
('c1','b1','bill1','2021-11-10','i1',5),
('c2','b1','bill1','2021-11-10','i2',2),
('c3','b2','bill2','2021-11-11','i3',10),
('c4','b3','bill3','2021-11-12','i2',20);

-- ===============================
-- Q1: Last booked room
-- ===============================
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) rn
    FROM bookings
) t
WHERE rn = 1;

-- ===============================
-- Q2: Total billing (Nov 2021)
-- ===============================
SELECT b.booking_id,
       SUM(bc.item_quantity * i.item_rate) total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date)=11 AND YEAR(b.booking_date)=2021
GROUP BY b.booking_id;

-- ===============================
-- Q3: Bills >1000 (Oct 2021)
-- ===============================
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) total
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date)=10 AND YEAR(bc.bill_date)=2021
GROUP BY bc.bill_id
HAVING total > 1000;

-- ===============================
-- Q4: Most & least ordered items
-- ===============================
WITH cte AS (
    SELECT MONTH(bill_date) m, item_id,
           SUM(item_quantity) qty,
           RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) DESC) r1,
           RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity) ASC) r2
    FROM booking_commercials
    GROUP BY MONTH(bill_date), item_id
)
SELECT * FROM cte WHERE r1=1 OR r2=1;

-- ===============================
-- Q5: Second highest bill
-- ===============================
WITH cte AS (
    SELECT MONTH(bill_date) m, bill_id,
           SUM(item_quantity * item_rate) total,
           RANK() OVER (PARTITION BY MONTH(bill_date) ORDER BY SUM(item_quantity * item_rate) DESC) rnk
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    GROUP BY MONTH(bill_date), bill_id
)
SELECT * FROM cte WHERE rnk=2;