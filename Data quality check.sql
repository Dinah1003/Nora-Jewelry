select *
from orders_status_v2;

select *
from `csvjson (1)`;

RENAME TABLE `csvjson-13` TO customers;

RENAME TABLE `csvjson-14` TO order_status;

RENAME TABLE `csvjson-15` TO orders;

ALTER TABLE customers
  MODIFY COLUMN id VARCHAR(255),
  MODIFY COLUMN marketing_channel VARCHAR(255),
  MODIFY COLUMN account_creation_method VARCHAR(255),
  MODIFY COLUMN country_code VARCHAR(10),
  MODIFY COLUMN loyalty_program INT,
  MODIFY COLUMN created_on DATE;
  
ALTER TABLE orders
  MODIFY COLUMN customer_id VARCHAR(255),
  MODIFY COLUMN id VARCHAR(255),
  MODIFY COLUMN purchase_date DATE,
  MODIFY COLUMN product_id VARCHAR(255),
  MODIFY COLUMN product_name VARCHAR(255),
  MODIFY COLUMN price DECIMAL(10,2),
  MODIFY COLUMN purchase_platform VARCHAR(255);
  
  
ALTER TABLE order_status
  MODIFY COLUMN order_id VARCHAR(255),
  MODIFY COLUMN purchase_ts DATETIME,
  MODIFY COLUMN ships_ts DATETIME,
  MODIFY COLUMN delivery_ts DATETIME,
  MODIFY COLUMN refund_ts DATETIME;
  
  UPDATE order_status
SET refund_ts = NULL
WHERE refund_ts = '' OR refund_ts IS NULL;

ALTER TABLE geo_lookup
  MODIFY COLUMN country VARCHAR(255),
  MODIFY COLUMN region VARCHAR(255);
  

  
DESCRIBE customers;

DESCRIBE geo_lookup;

DESCRIBE orders;

DESCRIBE order_status;

-- LE SCRIPT FINAL COMMENCE LA
-- I°/ Queries to inspect & perform quality check
-- Verification de la structure des tables : customers; orders, et orders_status_V2

DESCRIBE customers;

DESCRIBE orders;

DESCRIBE orders_status_v2;

-- Verification du nombre total de lignes des 3 tables

SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM order_status;

-- a) Détection des valeurs null ou vides de la table customer

SELECT * 
FROM customers
WHERE id IS NULL OR id = ''
   OR marketing_channel IS NULL OR marketing_channel = ''
   OR account_creation_method IS NULL OR account_creation_method = ''
   OR country_code IS NULL OR country_code = ''
   OR loyalty_program IS NULL
   OR created_on IS NULL;
   
-- b) Détection des valeurs null ou vides de la table orders

SELECT * 
FROM orders
WHERE customer_id IS NULL OR customer_id = ''
   OR id IS NULL OR id = ''
   OR purchase_date IS NULL
   OR product_id IS NULL OR product_id = ''
   OR product_name IS NULL OR product_name = ''
   OR price IS NULL
   OR purchase_platform IS NULL OR purchase_platform = '';
   
-- c) Détection des valeurs null ou vides de la table orders_status

SELECT * 
FROM order_status
WHERE order_id IS NULL OR order_id = ''
   OR purchase_ts IS NULL
   OR ships_ts IS NULL
   OR delivery_ts IS NULL;
   
  -- QUALITY CHECK SUR LA TABLE CUSTOMER

-- Détection de doublon d'id
SELECT id, COUNT(*) 
FROM customers 
GROUP BY id 
HAVING COUNT(*) > 1;

   
-- Vérification des valeurs uniques dans la colonne marketing channel

SELECT DISTINCT marketing_channel, COUNT(*) 
FROM customers 
GROUP BY marketing_channel;

-- Vérification de la cohérence des dates

SELECT *
FROM customers
WHERE created_on > NOW();

   -- QUALITY CHECK SUR LA TABLE ORDERS

-- Vérification des valeurs unique des purchase platform dans la table order

SELECT DISTINCT purchase_platform, COUNT(*) 
FROM orders 
GROUP BY purchase_platform;

-- Vérification des cohérences des dates d'achat/de commande

SELECT *
FROM orders
WHERE purchase_date > NOW();

-- Vérification des commandes par clients

SELECT customer_id, COUNT(*) AS nb_orders
FROM orders
GROUP BY customer_id
ORDER BY nb_orders DESC
LIMIT 10;

-- Vérification des produits commandés

SELECT product_name, COUNT(*) AS nb_product
FROM orders
GROUP BY product_name
ORDER BY nb_product DESC
LIMIT 10;

  -- QUALITY CHECK SUR LA TABLE ORDER_STATUS


-- Détection de doublon d'ID

SELECT order_id, COUNT(*) 
FROM order_status
GROUP BY order_id 
HAVING COUNT(*) > 1;


-- Vérification de la cohérence des dates (purchase_ts, ships_ts, delivery_ts, refund_ts)

SELECT *
FROM order_status
WHERE ships_ts < purchase_ts 
   OR delivery_ts < ships_ts 
   OR (refund_ts IS NOT NULL AND refund_ts < delivery_ts);
   
-- Vérification du nombre de commande remboursées

SELECT COUNT(*) AS total_refunds
FROM order_status
WHERE refund_ts IS NOT NULL;


