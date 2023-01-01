DROP DATABASE IF EXISTS vehdb;
CREATE DATABASE vehdb;
USE vehdb;
CREATE TABLE TEMP_T (
shipper_id INTEGER,
shipper_name VARCHAR(50),
shipper_contact_details VARCHAR(30),
product_id INTEGER,
vehicle_maker VARCHAR(60),
vehicle_model VARCHAR(60),
vehicle_color VARCHAR(60),
car_model_year INTEGER,
car_price DECIMAL(14,2),
quantity INTEGER,
discount DECIMAL(4,2),
customer_id VARCHAR(25),
customer_name VARCHAR(25),
gender VARCHAR(15),
job_title VARCHAR(50),
phone_number VARCHAR(20),
email_address VARCHAR(50),
city VARCHAR(25),
country VARCHAR(40),
state VARCHAR(40),
customer_address VARCHAR(50),
order_date DATE,
order_id VARCHAR(25),
ship_date DATE,
ship_mode VARCHAR(25),
shipping VARCHAR(30),
postal_code INTEGER,
credit_card_type VARCHAR(40),
credit_card_number BIGINT,
customer_feedback VARCHAR(20),
quarter_number INTEGER,
PRIMARY KEY(SHIPPER_ID,PRODUCT_ID,ORDER_ID,CUSTOMER_ID)
);
USE vehdb;
CREATE TABLE vehicles_t(
shipper_id INTEGER,
shipper_name VARCHAR(50),
shipper_contact_details VARCHAR(30),
product_id INTEGER,
vehicle_maker VARCHAR(60),
vehicle_model VARCHAR(60),
vehicle_color VARCHAR(60),
car_model_year INTEGER,
car_price DECIMAL(14,2),
quantity INTEGER,
customer_id VARCHAR(25),
customer_name VARCHAR(25),
gender VARCHAR(15),
job_title VARCHAR(50),
phone_number VARCHAR(20),
email_address VARCHAR(50),
city VARCHAR(25),
country VARCHAR(40),
state VARCHAR(40),
customer_address VARCHAR(50),
order_date DATE NOT NULL,
order_id VARCHAR(25),
ship_date DATE NOT NULL,
ship_mode VARCHAR(25),
shipping VARCHAR(30),
postal_code INTEGER,
discount DECIMAL(4,2),
credit_card_Type VARCHAR(40),
credit_card_number BIGINT,
customer_feedback VARCHAR(20),
quarter_number INTEGER,
PRIMARY KEY (order_id,customer_id,shipper_id,product_id)
);
select * from vehicles_t;
USE vehdb;
CREATE TABLE customer_t(
customer_id VARCHAR(25),
customer_name VARCHAR(25),
gender VARCHAR(15),
job_title VARCHAR(50),
phone_number VARCHAR(20),
email_address VARCHAR(50),
city VARCHAR(25),
country VARCHAR(40),
state VARCHAR(40),
customer_address VARCHAR(50),
postal_code INTEGER,
credit_card_Type VARCHAR(40),
credit_card_number BIGINT,
PRIMARY KEY (customer_id)
);
USE vehdb;
CREATE TABLE order_t(
order_id VARCHAR(25),
customer_id VARCHAR(25),
shipper_id INTEGER,
product_id INTEGER,
quantity INTEGER,
car_price DECIMAL(14,2),
order_date DATE NOT NULL,
ship_date DATE NOT NULL,
discount DECIMAL(4,2),
ship_mode VARCHAR(25),
shipping VARCHAR(30),
customer_feedback VARCHAR(20),
quarter_number INTEGER,
PRIMARY KEY (order_id)
);
USE vehdb;
CREATE TABLE product_t(
product_id INTEGER,
vehicle_maker VARCHAR(60),
vehicle_model VARCHAR(60),
vehicle_color VARCHAR(60),
car_model_year INTEGER,
car_price DECIMAL(14,2),
PRIMARY KEY (product_id)
);
USE vehdb;
CREATE TABLE shipper_t(
shipper_id INTEGER,
shipper_name VARCHAR(50),
shipper_contact_details VARCHAR(30),
PRIMARY KEY (shipper_id)
);
DELIMITER $$
CREATE PROCEDURE vehicles_p()
BEGIN
INSERT INTO vehdb.vehicles_t (
shipper_id,
shipper_name,
shipper_contact_details,
product_id,
vehicle_maker,
vehicle_model,
vehicle_color,
car_model_year,
car_price,
quantity,
customer_id,
customer_name,
gender,
job_title,
phone_number,
email_address,
city,
country,
state,
customer_address,
order_date,
order_id,
ship_date,
ship_mode,
shipping,
postal_code,
discount,
credit_card_Type,
credit_card_number,
customer_feedback,
quarter_number
)
SELECT DISTINCT
shipper_id,
shipper_name,
shipper_contact_details,
product_id,
vehicle_maker,
vehicle_model,
vehicle_color,
car_model_year,
car_price,
quantity,
customer_id,
customer_name,
gender,
job_title,
phone_number,
email_address,
city,
country,
state,
customer_address,
order_date,
order_id,
ship_date,
ship_mode,
shipping,
postal_code,
discount,
credit_card_Type,
credit_card_number,
customer_feedback,
quarter_number
FROM vehdb.temp_t;
END;
CALL vehicles_p();
select * from vehicles_t;
DELIMITER $$
CREATE PROCEDURE customer_p()
BEGIN
INSERT INTO vehdb.customer_t (
customer_id ,
customer_name ,
gender ,
job_title ,
phone_number ,
email_address ,
city ,
country ,
state ,
customer_address ,
postal_code ,
credit_card_Type,
credit_card_number
)
SELECT DISTINCT
customer_id ,
customer_name ,
gender ,
job_title ,
phone_number ,
email_address ,
city ,
country ,
state ,
customer_address ,
postal_code ,
credit_card_Type,
credit_card_number
FROM vehdb.vehicles_t;
END;
CALL customer_p();
select * from customer_t;
DELIMITER $$
CREATE PROCEDURE order_p()
BEGIN
INSERT INTO vehdb.order_t (
order_id ,
customer_id ,
shipper_id ,
product_id ,
quantity,
car_price ,
order_date ,
ship_date ,
discount,
ship_mode ,
shipping ,
customer_feedback ,
quarter_number
)
SELECT DISTINCT
order_id ,
customer_id ,
shipper_id ,
product_id ,
quantity,
car_price ,
order_date ,
ship_date ,
discount,
ship_mode ,
shipping ,
customer_feedback ,
quarter_number
FROM vehdb.vehicles_t;
END;
CALL order_p();
select * from order_t;
DELIMITER $$
CREATE PROCEDURE product_p()
BEGIN
INSERT INTO vehdb.product_t (
product_id,
vehicle_maker,
vehicle_model,
vehicle_color,
car_model_year,
car_price
)
SELECT DISTINCT
product_id,
vehicle_maker,
vehicle_model,
vehicle_color,
car_model_year,
car_price
FROM vehdb.vehicles_t;
END;
CALL product_p();
select * from product_t;
DELIMITER $$
CREATE PROCEDURE shipper_p()
BEGIN
INSERT INTO vehdb.shipper_t (
shipper_id,
shipper_name,
shipper_contact_details
)
SELECT DISTINCT
shipper_id,
shipper_name,
shipper_contact_details
FROM vehdb.vehicles_t;
END;
CALL shipper_p();
select * from shipper_t;
SELECT
ct.customer_id,
ct.customer_name,
ct.city,
ct.state,
ct.credit_card_Type,
ord.order_id,
ord.shipper_id,
ord.product_id,
ord.quantity,
ord.car_price,
ord.order_date,
ord.ship_date,
ord.discount,
ord.customer_feedback,
ord.quarter_number
FROM customer_t ct
left JOIN order_t ord
ON ct.customer_id = ord.customer_id;
use vehdb;
CREATE VIEW veh_prod_cust_v AS
SELECT
ct.customer_id,
ct.customer_name,
ct.credit_card_Type,
ct.state,
ord.order_id,
ord.customer_feedback,
prod.product_id,
prod.vehicle_maker,
prod.vehicle_model,
prod.vehicle_color,
prod.car_model_year
FROM product_t prod
INNER JOIN order_t ord
ON prod.product_id=ord.product_id
INNER JOIN customer_t ct
ON ord.customer_id=ct.customer_id;
select * from veh_prod_cust_v;