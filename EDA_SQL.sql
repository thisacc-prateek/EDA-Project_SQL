--DIMENSIONS EXPLORATION

SELECT DISTINCT country FROM [gold.dim_customers]
WHERE country !='n/a';

SELECT DISTINCT category FROM [gold.dim_products]
WHERE category IS NOT NULL;

SELECT DISTINCT country FROM [gold.dim_customers]
WHERE country != 'n/a';


--DATE exploration

--buiness operating duration
SELECT
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF(YEAR,MIN(order_date),MAX(order_date)) AS business_operating_years
FROM [gold.fact_sales]


SELECT 
MIN(DATEDIFF(DAY,order_date, shipping_date)) AS minimum_days_of_delivery,
MAX(DATEDIFF(DAY,order_date, shipping_date)) AS maximum_days_of_delivery
FROM [gold.fact_sales]

--MEASURE EXPLORATION

--total_sales
SELECT SUM(sales_amount) AS total_sales 
FROM [gold.fact_sales];

--total items sold
SELECT SUM(quantity) AS total_items_sold 
FROM [gold.fact_sales];

--average selling price
SELECT AVG(price) AS avg_selling_price 
FROM [gold.fact_sales];

--total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM [gold.fact_sales];

--total products
SELECT COUNT(DISTINCT product_name) AS total_products 
FROM [gold.dim_products];

--total number of customers
SELECT COUNT(DISTINCT customer_key) AS total_customers 
FROM [gold.dim_customers];

--KEY METRICS REPORT
SELECT 'total_sales' AS measure_name, SUM(sales_amount) AS measure_value FROM [gold.fact_sales]
UNION ALL
SELECT 'total_quantity' AS measure_name, SUM(quantity) AS measure_value FROM [gold.fact_sales]
UNION ALL 
SELECT 'average_price_per_product' AS average_price, AVG(price) AS measure_value FROM [gold.fact_sales]
UNION ALL 
SELECT 'number_of_orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM [gold.fact_sales]
UNION ALL 
SELECT 'total_products' AS measure_name, COUNT(DISTINCT product_name) AS measure_value FROM [gold.dim_products]
UNION ALL
SELECT 'total_customers' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM [gold.dim_customers]

--MAGNITUDE ANALYSIS

--total customers by country
SELECT
country,
COUNT(customer_id) AS total_customers
FROM [gold.dim_customers]
WHERE country !='n/a'
GROUP BY country
ORDER BY country DESC;

--total customer by gender
SELECT
gender,
COUNT(customer_id) AS total_customers
FROM [gold.dim_customers]
WHERE gender != 'n/a'
GROUP BY gender
ORDER BY gender;

--total products by category
SELECT
category,
COUNT(product_id) AS total_products
FROM [gold.dim_products]
WHERE category IS NOT NULL
GROUP BY category
ORDER BY category DESC;

--average cost in each category
SELECT
category,
AVG(cost) AS average_cost
FROM [gold.dim_products]
WHERE category IS NOT NULL
GROUP BY category
ORDER BY average_cost DESC;

--total revenue by category
SELECT
p.category,
SUM(s.sales_amount) AS total_revenue
FROM [gold.fact_sales] AS s
LEFT JOIN [gold.dim_products] AS p
ON s.product_key=p.product_key
WHERE category is not null
GROUP BY p.category
ORDER BY total_revenue DESC;



--distribution of sold items acccross countries
SELECT
c.country,
SUM(s.quantity) AS total_items_sold
FROM [gold.fact_sales] AS s
LEFT JOIN [gold.dim_customers] AS c
ON s.customer_key=c.customer_key
WHERE country != 'n/a'
GROUP BY c.country
ORDER BY total_items_sold  DESC;

--RANKING ANALYSIS

--top 5 highest revenue generating products
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM [gold.fact_sales] AS s
LEFT JOIN [gold.dim_products] AS p
ON s.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

--least 5 worst performing as per revenue
SELECT TOP 5
p.product_name,
SUM(s.sales_amount) AS total_revenue
FROM [gold.fact_sales] AS s
LEFT JOIN [gold.dim_products] AS p
ON s.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;


--top 3 most ordered products
SELECT TOP 3 COUNT(order_number) AS number_of_times_ordered, 
p.product_name  FROM [gold.fact_sales] AS s
INNER JOIN [gold.dim_products] as p
ON s.product_key=p.product_key
GROUP BY s.product_key, p.product_name
ORDER BY number_of_times_ordered DESC;

--total revenue generated by each customer
SELECT TOP 5
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount) AS total_revenue
FROM [gold.fact_sales] AS s
LEFT JOIN [gold.dim_customers] AS c
ON s.customer_key=c.customer_key
GROUP BY c.customer_key, c.first_name,c.last_name
ORDER BY total_revenue DESC;

