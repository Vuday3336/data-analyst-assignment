DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;

CREATE TABLE clinics (
    cid VARCHAR(50),
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer (
    uid VARCHAR(50),
    name VARCHAR(100),
    mobile VARCHAR(15)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50),
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount INT,
    datetime DATETIME,
    sales_channel VARCHAR(50)
);

CREATE TABLE expenses (
    eid VARCHAR(50),
    cid VARCHAR(50),
    description TEXT,
    amount INT,
    datetime DATETIME
);

INSERT INTO clinics VALUES
('c1','Clinic1','Hyderabad','Telangana','India'),
('c2','Clinic2','Hyderabad','Telangana','India');

INSERT INTO customer VALUES
('u1','John','9999999999'),
('u2','Mike','8888888888');

INSERT INTO clinic_sales VALUES
('o1','u1','c1',2000,'2021-09-10','online'),
('o2','u2','c2',5000,'2021-09-12','offline');

INSERT INTO expenses VALUES
('e1','c1','supplies',500,'2021-09-10'),
('e2','c2','rent',2000,'2021-09-12');

-- Revenue by channel
SELECT sales_channel, SUM(amount)
FROM clinic_sales
GROUP BY sales_channel;

-- Top customers
SELECT uid, SUM(amount) total
FROM clinic_sales
GROUP BY uid
ORDER BY total DESC;

-- Monthly profit
SELECT MONTH(cs.datetime) month,
       SUM(cs.amount) revenue,
       SUM(e.amount) expense,
       SUM(cs.amount) - SUM(e.amount) profit
FROM clinic_sales cs
JOIN expenses e ON cs.cid = e.cid
GROUP BY MONTH(cs.datetime);