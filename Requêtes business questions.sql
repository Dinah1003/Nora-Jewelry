
-- Comment les ventes totales ont-elles évolué au cours des 12 derniers mois ?

SELECT DATE_FORMAT(purchase_date, '%Y-%m') AS month, SUM(price) AS total_sales
FROM orders
WHERE purchase_date >= CURDATE() - INTERVAL 12 MONTH  
GROUP BY month  
ORDER BY month DESC;

-- Quel est l'impact des différentes plateformes d'achat (mobile, desktop, tablette) sur les ventes globales ? (permet de déterminer quelles plateformes génèrent le plus de ventes et où il peut être nécessaire d'améliorer l'expérience client.)

SELECT purchase_platform, SUM(price) AS total_sales, COUNT(*) AS total_orders,  AVG(price) AS avg_order_value
FROM orders
GROUP BY purchase_platform
ORDER BY total_sales DESC;

-- Quel est le revenu moyen par commande (AOV - Average Order Value) et comment évolue-t-il au fil du temps ?

SELECT DATE_FORMAT(purchase_date, '%Y-%m') AS month, AVG(price) AS average_order_value, COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month ASC;

-- Quels sont les 10 produits les plus populaires en termes de volume de ventes ?

SELECT product_name, COUNT(*) AS total_sales
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC LIMIT 10;

-- Quels produits génèrent le plus de retours et quel est leur taux de retour ?


SELECT o.product_name, COUNT(o.id) AS total_sales, COUNT(DISTINCT os.order_id) AS total_returns, 
    ROUND(COUNT(DISTINCT os.order_id) / COUNT(o.id) * 100, 2) AS return_rate
FROM orders o
LEFT JOIN (SELECT DISTINCT order_id FROM order_status WHERE refund_ts IS NOT NULL) os
	ON o.id = os.order_id
GROUP BY o.product_name 
ORDER BY total_returns DESC LIMIT 10;

-- Quel est l'impact de chaque ligne de produit (par exemple, colliers, bracelets, bagues) sur le chiffre d'affaires global ?

SELECT 
    CASE 
        WHEN LOWER(product_name) LIKE '%collier%' THEN 'Colliers'
        WHEN LOWER(product_name) LIKE '%bracelet%' THEN 'Bracelets'
        WHEN LOWER(product_name) LIKE '%bague%' THEN 'Bagues'
        ELSE 'Autres'
    END AS product_category,
    SUM(price) AS total_revenue,
    ROUND(SUM(price) * 100 / (SELECT SUM(price) FROM orders), 2) AS revenue_percentage
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC;

-- Les clients inscrits au programme de fidélité génèrent-ils un revenu supérieur par rapport aux clients non inscrits ?

SELECT 
    CASE 
        WHEN c.loyalty_program = 1 THEN 'Programme Fidélité'
        ELSE 'Non Fidélité'
    END AS customer_type,
    COUNT(DISTINCT o.customer_id) AS total_clients,
    COUNT(o.id) AS total_orders,
    SUM(o.price) AS total_revenue,
    ROUND(AVG(o.price), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.id
GROUP BY customer_type
ORDER BY total_revenue DESC;

--


WITH first_order AS (
    SELECT customer_id, MIN(purchase_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
), retained_customers AS (
    SELECT o.customer_id
    FROM orders o
    JOIN first_order f ON o.customer_id = f.customer_id
    WHERE o.purchase_date > f.first_purchase_date
    GROUP BY o.customer_id
), retention_analysis AS (
  
    SELECT c.customer_id, c.loyalty_program,
           CASE 
               WHEN r.customer_id IS NOT NULL THEN 1 
               ELSE 0 
           END AS is_retained
    FROM customers c
    LEFT JOIN retained_customers r ON c.id = r.customer_id
);

-- Quel est le taux de rétention des clients ayant adhéré au programme de fidélité après leur première commande par rapport aux clients non fidélisés ?

SELECT 
    c.loyalty_program,
    COUNT(c.id) AS total_customers,
    SUM(CASE 
            WHEN o2.customer_id IS NOT NULL THEN 1 
            ELSE 0 
        END) AS retained_customers,
    ROUND(SUM(CASE 
                  WHEN o2.customer_id IS NOT NULL THEN 1 
                  ELSE 0 
              END) * 100.0 / COUNT(c.id), 2) AS retention_rate
FROM customers c
LEFT JOIN (
    SELECT o1.customer_id, MIN(o1.purchase_date) AS first_purchase_date
    FROM orders o1
    GROUP BY o1.customer_id
) first_order ON c.id = first_order.customer_id
LEFT JOIN orders o2 
    ON first_order.customer_id = o2.customer_id 
    AND o2.purchase_date > first_order.first_purchase_date
GROUP BY c.loyalty_program;

-- Comment les ventes et le volume des commandes varient-elles selon les régions ?

SELECT 
    g.region, COUNT(o.id) AS total_orders, SUM(o.price) AS total_revenue, ROUND(AVG(o.price), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN geo_lookup g ON c.country_code = g.country_code
GROUP BY g.region
ORDER BY total_revenue DESC;

SELECT *
FROM ORDER_STATUS;



SELECT 
    o.product_name, 
    COUNT(o.id) AS total_sales,  
    COUNT(CASE WHEN os.refund_ts IS NOT NULL THEN o.id END) AS total_returns, 
    ROUND((COUNT(CASE WHEN os.refund_ts IS NOT NULL THEN o.id END) / COUNT(o.id)) * 100, 2) AS return_rate
FROM orders o
LEFT JOIN order_status os ON o.id = os.order_id
GROUP BY o.product_name
ORDER BY total_returns DESC;



-- YOY GROWTH

SELECT 
    YEAR(purchase_date) AS year, 
    SUM(price) AS total_revenue, 
    LAG(SUM(price)) OVER (ORDER BY YEAR(purchase_date)) AS previous_year_revenue,
    ROUND(((SUM(price) - LAG(SUM(price)) OVER (ORDER BY YEAR(purchase_date))) / LAG(SUM(price)) OVER (ORDER BY YEAR(purchase_date))) * 100, 2) AS yoy_growth
FROM orders
GROUP BY year;

-- Évolution des ventes mensuelles

SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') AS month, 
    SUM(price) AS total_revenue, 
    COUNT(id) AS total_orders 
FROM orders
GROUP BY month
ORDER BY total_orders desc;

SELECT 
    DAYNAME(purchase_date) AS day_of_week, 
    SUM(price) AS total_revenue, 
    COUNT(id) AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

SELECT 
    purchase_date, 
    SUM(price) AS total_revenue, 
    COUNT(id) AS total_orders
FROM orders
GROUP BY purchase_date
ORDER BY total_revenue DESC
LIMIT 10;

SELECT 
    c.marketing_channel, 
    SUM(o.price) AS total_revenue, 
    COUNT(o.id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.id
GROUP BY c.marketing_channel
ORDER BY total_revenue DESC;

-- Revenue moyens par commande au fil du temps

SELECT 
    YEAR(purchase_date) AS year,
    MONTH(purchase_date) AS month,
    COUNT(DISTINCT id) AS total_orders,
    SUM(price) AS total_revenue,
    ROUND(SUM(price) / COUNT(DISTINCT id), 2) AS average_order_value
FROM orders
GROUP BY year, month
ORDER BY average_order_value DESC, month DESC;

SELECT 
    MONTH(purchase_date) AS month,
    COUNT(DISTINCT id) AS total_orders,
    SUM(price) AS total_revenue,
    ROUND(SUM(price) / COUNT(DISTINCT id), 2) AS average_order_value
FROM orders
GROUP BY month
ORDER BY total_orders DESC;

-- Top 10 des produits les plus vendus

SELECT 
    product_name,
    COUNT(id) AS total_sales,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_price
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Proportion des produits les + vendues
SELECT 
    product_name,
    COUNT(id) AS total_sales,
    SUM(price) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(COUNT(id) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS sales_percentage
FROM orders
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Identification des produits achetés ensemble

WITH order_pairs AS (
    SELECT 
        o1.product_name AS product_1, 
        o2.product_name AS product_2, 
        COUNT(DISTINCT o1.id) AS times_bought_together
    FROM orders o1
    JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.id <> o2.id
    GROUP BY product_1, product_2
)
SELECT * FROM order_pairs
ORDER BY times_bought_together DESC
LIMIT 10;

WITH order_pairs AS (
    SELECT 
        o1.product_name AS product_1, 
        o2.product_name AS product_2, 
        COUNT(DISTINCT o1.id) AS times_bought_together
    FROM orders o1
    JOIN orders o2 ON o1.customer_id = o2.customer_id AND o1.id <> o2.id
    GROUP BY product_1, product_2
),
total_orders AS (
    SELECT COUNT(DISTINCT id) AS total_orders
    FROM orders
)
SELECT 
    product_1,
    product_2,
    times_bought_together,
    (times_bought_together * 100.0 / total_orders) AS percentage
FROM order_pairs, total_orders
ORDER BY times_bought_together DESC
LIMIT 10;

-- Prdouit avec le plus haut taux de retour

SELECT 
    o.product_name, 
    COUNT(o.id) AS total_sales,  
    COUNT(CASE WHEN os.refund_ts IS NOT NULL THEN o.id END) AS total_returns, 
    ROUND((COUNT(CASE WHEN os.refund_ts IS NOT NULL THEN o.id END) / COUNT(o.id)) * 100, 2) AS return_rate
FROM orders o
LEFT JOIN order_status os ON o.id = os.order_id
GROUP BY o.product_name
ORDER BY return_rate DESC
LIMIT 10;

-- Les ventes par types de produits

WITH category_sales AS (
    SELECT 
        CASE 
            WHEN LOWER(product_name) LIKE '%collier%' THEN 'Colliers'
            WHEN LOWER(product_name) LIKE '%bracelet%' THEN 'Bracelets'
            WHEN LOWER(product_name) LIKE '%bague%' THEN 'Bagues'
            WHEN LOWER(product_name) LIKE '%boucles%' THEN 'Boucles d''oreilles'
            ELSE 'Autres'
        END AS product_category,
        SUM(price) AS total_revenue
    FROM orders
    GROUP BY product_category
)
SELECT 
    product_category,
    total_revenue,
    (total_revenue / (SELECT SUM(total_revenue) FROM category_sales)) * 100 AS revenue_percentage
FROM category_sales
ORDER BY total_revenue DESC;

-- Programme de fidélité

WITH total_spent_data AS (
    SELECT 
        CASE 
            WHEN c.loyalty_program = 1 THEN 'Membres du programme fidélité'
            ELSE 'Non-membres du programme fidélité'
        END AS loyalty_status,
        COUNT(o.id) AS total_orders,
        SUM(o.price) AS total_spent
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    GROUP BY loyalty_status
)
SELECT 
    loyalty_status,
    total_orders,
    total_spent,
    total_spent / total_orders AS AOV
FROM total_spent_data
ORDER BY total_spent DESC;


-- Est ce que les membres du programme de fidélité ont tendance à plus commander

WITH customer_orders AS (
    SELECT 
        c.loyalty_program,
        COUNT(o.id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS total_customers
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    GROUP BY c.loyalty_program
)
SELECT 
    CASE 
        WHEN loyalty_program = 1 THEN 'Membres du programme fidélité'
        ELSE 'Non-membres du programme fidélité'
    END AS loyalty_status,
    total_orders,
    total_customers,
    total_orders / total_customers AS avg_orders_per_customer
FROM customer_orders
ORDER BY avg_orders_per_customer DESC;

-- Marketing Channel qui génère le plus de revenue

SELECT 
    c.marketing_channel,
    COUNT(c.id) AS total_customers,
    (COUNT(c.id) * 100.0) / (SELECT COUNT(id) FROM customers) AS percentage_customers
FROM customers c
GROUP BY c.marketing_channel
ORDER BY total_customers DESC;

-- Les canaux qui génèrent le plus de retour


SELECT 
    c.marketing_channel, 
    COUNT(o.id) AS total_orders,
    COUNT(CASE WHEN os.refund_ts IS NOT NULL THEN o.id END) AS total_returns,
    ROUND((COUNT(CASE WHEN os.refund_ts IS NOT NULL THEN o.id END) / COUNT(o.id)) * 100, 2) AS return_rate
FROM orders o
JOIN customers c ON o.customer_id = c.id
LEFT JOIN order_status os ON o.id = os.order_id 
GROUP BY c.marketing_channel
ORDER BY return_rate DESC;

-- Analyse des produits les plus vendus paar canaux marketing

SELECT 
    c.marketing_channel,
    o.product_name,
    COUNT(o.id) AS total_sales,
    SUM(o.price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.id 
GROUP BY c.marketing_channel, o.product_name
ORDER BY c.marketing_channel, total_sales DESC;


-- Relance marketing - durée moyenne entre 2 commandes

WITH purchase_gaps AS (
    SELECT 
        customer_id,
        purchase_date,
        LAG(purchase_date) OVER (PARTITION BY customer_id ORDER BY purchase_date) AS previous_purchase_date
    FROM orders
)
SELECT 
    ROUND(AVG(DATEDIFF(purchase_date, previous_purchase_date)), 2) AS avg_days_between_orders
FROM purchase_gaps
WHERE previous_purchase_date IS NOT NULL;

-- quels canaux marketing amènent les clients les plus fidèles

WITH first_order AS (
    SELECT customer_id, MIN(purchase_date) AS first_purchase_date
    FROM orders
    GROUP BY customer_id
), 
retained_customers AS (
    SELECT o.customer_id
    FROM orders o
    JOIN first_order f ON o.customer_id = f.customer_id
    WHERE o.purchase_date > f.first_purchase_date
    GROUP BY o.customer_id
)
SELECT 
    c.marketing_channel,
    COUNT(c.id) AS total_customers,
    COUNT(r.customer_id) AS retained_customers,
    ROUND((COUNT(r.customer_id) * 100.0 / COUNT(c.id)), 2) AS retention_rate
FROM customers c
LEFT JOIN retained_customers r ON c.id = r.customer_id
GROUP BY c.marketing_channel
ORDER BY retention_rate DESC;


-- Client fidèles mais qui ne sont pas dans le loyalty program

WITH order_counts AS (
    SELECT customer_id, COUNT(id) AS total_orders
    FROM orders
    GROUP BY customer_id
),
retained_customers AS (
    SELECT customer_id
    FROM order_counts
    WHERE total_orders > 1
),
non_loyal_customers AS (
    SELECT c.id AS customer_id
    FROM customers c
    JOIN retained_customers r ON c.id = r.customer_id
    WHERE c.loyalty_program = 0  
)
SELECT 
    COUNT(nlc.customer_id) AS non_loyal_retained_customers,
    COUNT(r.customer_id) AS total_retained_customers,
    ROUND((COUNT(nlc.customer_id) * 100.0) / COUNT(r.customer_id), 2) AS non_loyal_retained_rate
FROM retained_customers r
LEFT JOIN non_loyal_customers nlc ON r.customer_id = nlc.customer_id;

-- Regional Sales

SELECT 
    g.country, 
    COUNT(o.id) AS total_orders, 
    SUM(o.price) AS total_revenue, 
    ROUND(AVG(o.price), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN geo_lookup g ON c.country_code = g.country_code
GROUP BY g.country
ORDER BY total_revenue DESC;


-- Loyalty program par région 

SELECT 
    g.country,
    COUNT(DISTINCT c.id) AS total_customers,
    COUNT(DISTINCT CASE WHEN c.loyalty_program = 'Yes' THEN c.id END) AS loyal_customers,
    ROUND((COUNT(DISTINCT CASE WHEN c.loyalty_program = 'Yes' THEN c.id END) * 100.0) / COUNT(DISTINCT c.id), 2) AS loyalty_program_rate
FROM customers c
JOIN geo_lookup g ON c.country_code = g.country_code
GROUP BY g.country
ORDER BY loyalty_program_rate DESC;

-- Canaux marketing les + performants par région

SELECT 
    g.country,
    c.marketing_channel,
    COUNT(o.id) AS total_orders,
    SUM(o.price) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN geo_lookup g ON c.country_code = g.country_code
GROUP BY g.country, c.marketing_channel
ORDER BY g.country, total_orders DESC;

-- Évolution des revenues par région et par année

WITH yearly_sales AS (
    SELECT 
        g.country, 
        YEAR(o.purchase_date) AS year, 
        SUM(o.price) AS total_revenue, 
        COUNT(o.id) AS total_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    JOIN geo_lookup g ON c.country_code = g.country_code
    GROUP BY g.country, YEAR(o.purchase_date)
)
SELECT 
    y1.country, 
    y1.year, 
    y1.total_revenue, 
    y2.total_revenue AS previous_year_revenue,
    ROUND(((y1.total_revenue - y2.total_revenue) / y2.total_revenue) * 100, 2) AS yoy_growth
FROM yearly_sales y1
LEFT JOIN yearly_sales y2 
    ON y1.country = y2.country AND y1.year = y2.year + 1
ORDER BY y1.country, y1.year;

-- Les produits les plus vendus par pays

WITH product_sales AS (
    SELECT 
        g.country, 
        o.product_name, 
        COUNT(o.id) AS total_sales, 
        SUM(o.price) AS total_revenue,
        RANK() OVER (PARTITION BY g.country ORDER BY SUM(o.price) DESC) AS sales_rank
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    JOIN geo_lookup g ON c.country_code = g.country_code
    GROUP BY g.country, o.product_name
),
country_revenue AS (
    SELECT 
        country, 
        SUM(total_revenue) AS total_country_revenue
    FROM product_sales
    GROUP BY country
)
SELECT 
    ps.country, 
    ps.product_name, 
    ps.total_sales, 
    ps.total_revenue, 
    cr.total_country_revenue,
    ROUND((ps.total_revenue * 100.0) / cr.total_country_revenue, 2) AS revenue_percentage
FROM product_sales ps
JOIN country_revenue cr ON ps.country = cr.country
WHERE ps.sales_rank = 1
ORDER BY ps.country;
