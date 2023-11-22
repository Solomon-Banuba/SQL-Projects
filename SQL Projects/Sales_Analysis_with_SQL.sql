# -- Sales Analysis Using SQL

## -- Business Requests:

---------------------------------------------------------------------------------------------

# 1: Finding the top-performing products and the states where the sales are coming from

SELECT
	product_name,
	region_state,
	SUM(order_quantity) AS total_sales
FROM sales s
INNER JOIN products p ON s.product_id = p.id
INNER JOIN stores st ON s.store_id = st.id
INNER JOIN regions r ON r.state_code = st.state_code
GROUP BY product_name, region_state
ORDER BY total_sales DESC LIMIT 10;


---------------------------------------------------------------------------------------------

# 2:  Which sales channel brings in the most sales

SELECT
	sale_channel,
	COUNT(order_quantity) orders_per_channel
FROM sales
GROUP BY sale_channel;


---------------------------------------------------------------------------------------------

# -- 3: Pull a table of all customers with total orders of less than 300 units in the year 2020

SELECT
	c.id,
	customer_name,
	SUM(order_quantity) AS total_sales
FROM sales s
INNER JOIN customers c ON s.customer_id = c.id
WHERE YEAR(order_date) = 2020
GROUP BY customer_name
HAVING SUM(order_quantity) < 300;


---------------------------------------------------------------------------------------------

# -- 4: Find the first orders and repeat order behavior of customers over time (Cohort analysis)

SELECT
	x.customer_id,
	x.product_id,
	x.store_id,
	p.product_name,
	st. city_name,
	x.FO_date,
	x. order_date,
	x. order_quantity,
	p1. product_name FO_product_name,
	st1. city_name FO_city_name,
	x.order_rank,
TIMESTAMPDIFF(MONTH, FO_date, order_date) cohort
FROM
(
SELECT
	customer_id,
	product_id,
	order_date,
	order_quantity,
	store_id,
FIRST_VALUE(order_date) OVER(partition by customer_id order by order_date) FO_date,
FIRST_VALUE(store_id) OVER(partition by customer_id order by order_date) FO_store_id, 
FIRST_VALUE(product_id) OVER(partition by customer_id order by order_date) FO_product, 
RANK() OVER(PARTITION BY customer_id ORDER BY order_date) order_rank

FROM sales s
)x
LEFT JOIN products p ON x.product_id = p.id
LEFT JOIN products p1 ON x.FO_product = p1.id
LEFT JOIN stores st ON x.store_id = st.id
LEFT JOIN stores st1 ON x.FO_store_id = st1.id;


---------------------------------------------------------------------------------------------

# -- 5: Print a table showing each day of the week and the respective order quantities.

SELECT
	DAYOFWEEK(order_date) day_of_week,
	DAYNAME(order_date) Day_name,
	SUM(order_quantity) order_quantity
FROM sales s
GROUP BY 
	Day_name, 
	day_of_week;


---------------------------------------------------------------------------------------------

# -- 6: Calculate the total order quantities for each month

SELECT
	Month(order_date) month_number,
	Monthname(order_date) name_of_month,
	Sum(order_quantity) order_per_month
FROM sales s
GROUP BY 
	month_number, 
	name_of_month;

---------------------------------------------------------------------------------------------

# --7: Analyse sales trends over time. Is there any growth in sales

SELECT
	YEAR(order_date) AS order_year,
	SUM(order_quantity) order_per_year
FROM sales
GROUP BY 
	order_year;

---------------------------------------------------------------------------------------------

-- Read detailed project blog here: https://medium.com/@solomonbanuba/exploratory-data-analysis-with-mysql-508b5d0171df
