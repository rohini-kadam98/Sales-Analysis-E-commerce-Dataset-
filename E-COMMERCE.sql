USE ecommerce;
SELECT * FROM sales_target;
SELECT * FROM order_details; 
SELECT * FROM order_list;

-- rename the columns
ALTER TABLE order_details CHANGE `Sub-Category` sub_category VARCHAR(25);
ALTER TABLE order_details CHANGE `Order ID` order_id VARCHAR(25);
ALTER TABLE order_list CHANGE `Order Date` order_date VARCHAR(25);
ALTER TABLE order_list CHANGE `Order ID` order_id VARCHAR(25);
ALTER TABLE sales_target CHANGE `Month of Order Date` month_of_order VARCHAR(25);

-- combine the order_detail table with order_list table
CREATE VIEW combined_orders AS
SELECT d.order_id, d.Amount, d.Profit, d.Quantity, d.Category, d.sub_category, l.order_date, l.CustomerName, l.State, l.City
FROM order_details AS d
INNER JOIN order_list AS l
ON d.order_id = l.order_id;

SELECT * FROM combined_orders;

-- ********** Q U E R Y 1 **********
-- segment the customers into group based on RFM model
CREATE VIEW customer_grouping AS 
SELECT 
*,
CASE 
	WHEN (R>=4 AND R<=5) AND (((F+M)/2)>= 4 AND ((F+M)/2)<=5) THEN 'Champions'
	WHEN (R>=2 AND R<=5) AND (((F+M)/2)>= 3 AND ((F+M)/2)<=5) THEN 'Loyal Customers'
	WHEN (R>=3 AND R<=5) AND (((F+M)/2)>= 1 AND ((F+M)/2)<=3) THEN 'Potential Loyalist'
	WHEN (R>=4 AND R<=5) AND (((F+M)/2)>= 0 AND ((F+M)/2)<=1) THEN 'New Customers'
	WHEN (R>=3 AND R<=4) AND (((F+M)/2)>= 0 AND ((F+M)/2)<=1) THEN 'Promising'
	WHEN (R>=2 AND R<=3) AND (((F+M)/2)>= 2 AND ((F+M)/2)<=3) THEN 'Customers Needing Attention'
	WHEN (R>=2 AND R<=3) AND (((F+M)/2)>= 0 AND ((F+M)/2)<=2) THEN 'About to Sleep'
	WHEN (R>=0 AND R<=2) AND (((F+M)/2)>= 2 AND ((F+M)/2)<=5) THEN 'At Risk'
	WHEN (R>=0 AND R<=1) AND (((F+M)/2)>= 4 AND ((F+M)/2)<=5) THEN "Can't Lost Them"
	WHEN (R>=1 AND R<=2) AND (((F+M)/2)>= 1 AND ((F+M)/2)<=2) THEN 'Hibernating'
	WHEN (R>=0 AND R<=2) AND (((F+M)/2)>= 0 AND ((F+M)/2)<=2) THEN 'Lost'
		END AS customer_segment
FROM (
	SELECT 
	MAX(STR_TO_DATE(order_date, '%d-%m-%Y')) AS latest_order_date,
	CustomerName,
	DATEDIFF(STR_TO_DATE('31-03-2019', '%d-%m-%Y'), MAX(STR_TO_DATE(order_date, '%d-%m-%Y'))) AS recency,
	COUNT(DISTINCT order_id) AS frequency,
	SUM(Amount) AS monetary,
	NTILE(5) OVER (ORDER BY DATEDIFF(STR_TO_DATE('31-03-2019', '%d-%m-%Y'), MAX(STR_TO_DATE(order_date, '%d-%m-%Y'))) DESC) AS R,
	NTILE(5) OVER (ORDER BY COUNT(DISTINCT order_id) ASC)  AS F,
	NTILE(5) OVER (ORDER BY SUM(Amount) ASC) AS M
	FROM combined_orders
	GROUP BY CustomerName)rfm_table
GROUP BY CustomerName;

SELECT * FROM customer_grouping;

-- return the number & percentage of each customer segment
SELECT 
    customer_segment, 
    COUNT(DISTINCT CustomerName) AS num_of_customers,
    ROUND(COUNT(DISTINCT CustomerName) / (SELECT COUNT(*) FROM customer_grouping) *100,2) AS pct_of_customers
FROM customer_grouping
GROUP BY customer_segment
ORDER BY pct_of_customers DESC;

-- ********** Q U E R Y 2 **********
-- number of orders, customers, cities, states
SELECT COUNT(DISTINCT order_id) AS num_of_orders, # 500 distinct orders were made
       COUNT(DISTINCT CustomerName) AS num_of_customers, # 332 distinct customers
       COUNT(DISTINCT City) AS num_of_cities, # 24 distinct cities
       COUNT(DISTINCT State) AS num_of_states
FROM combined_orders;

-- ********** Q U E R Y 3 **********
-- top 5 new customers
SELECT CustomerName, State, City, SUM(Amount) AS sales
FROM combined_orders
WHERE CustomerName NOT IN (
	SELECT DISTINCT CustomerName 
	FROM combined_orders
	WHERE YEAR(STR_TO_DATE(order_date,"%d-%m-%Y"))=2018)
AND YEAR(STR_TO_DATE(order_date,"%d-%m-%Y"))=2019
GROUP BY CustomerName
ORDER BY sales DESC
LIMIT 5;

-- ********** Q U E R Y 4 **********
-- number of customers, quantities sold and profit made in top 10 profitable states & cities
SELECT 
    State,
    City,
    COUNT(DISTINCT CustomerName) AS num_of_custoemrs,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM combined_orders
GROUP BY State , City
ORDER BY total_profit DESC
LIMIT 10;

-- ********** Q U E R Y 5 **********
-- first order in each state
SELECT order_date, order_id, State, CustomerName
FROM (SELECT * , ROW_NUMBER() OVER (PARTITION BY State ORDER BY State, order_id) AS RowNumberPerState
FROM combined_orders)firstorder
WHERE RowNumberPerState = 1
ORDER BY order_id;

-- ********** Q U E R Y 6 **********
-- sales in different days
SELECT 
    day_of_order,
    LPAD('*', num_of_orders, '*') AS num_of_orders,
    sales
FROM
    (SELECT 
        DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS day_of_order,
		COUNT(DISTINCT order_id) AS num_of_orders,
        SUM(Quantity) AS quantity,
        SUM(Amount) AS sales
    FROM combined_orders
    GROUP BY day_of_order) sales_per_day
ORDER BY sales DESC;

-- ********** Q U E R Y 7 **********
-- profit made & quantity sold in each month
SELECT CONCAT(MONTHNAME(STR_TO_DATE(order_date,'%d-%m-%Y')), "-", YEAR(STR_TO_DATE(order_date,'%d-%m-%Y'))) AS month_of_year, 
SUM(Profit) AS total_profit, SUM(Quantity) AS total_quantity
FROM combined_orders
GROUP BY month_of_year
ORDER BY month_of_year= 'April-2018' DESC, 
	 month_of_year= 'May-2018' DESC,
	 month_of_year= 'June-2018' DESC,
	 month_of_year= 'July-2018' DESC,
         month_of_year= 'August-2018' DESC,
         month_of_year= 'September-2018' DESC,
         month_of_year= 'October-2018' DESC,
         month_of_year= 'November-2018' DESC,
         month_of_year= 'December-2018' DESC,
         month_of_year= 'January-2019' DESC,
         month_of_year= 'February-2019' DESC,
         month_of_year= 'March-2019' DESC;
         
-- ********** Q U E R Y 8 **********
-- find out the sales for each category in each month
CREATE VIEW sales_by_category AS
SELECT CONCAT(SUBSTR(MONTHNAME (STR_TO_DATE(order_date, '%d-%m-%Y')),1,3),"-",SUBSTR(YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')),3,2)) AS order_monthyear,
	Category, SUM(Amount) AS Sales
FROM combined_orders
GROUP BY order_monthyear,Category;

SELECT * FROM sales_by_category;
-- check if the sales hit the target set for each category in each month
CREATE VIEW sales_vs_target AS 
SELECT 
    *, 
    CASE
    	WHEN Sales >= Target THEN 'Hit'
        ELSE 'Fail'
		END AS hit_or_fail
FROM
    (SELECT s.order_monthyear, s.Category, s.Sales, t.Target
    FROM sales_by_category AS s
    INNER JOIN sales_target AS t ON s.order_monthyear = t.month_of_order 
    AND s.Category = t.Category) st;

SELECT * FROM sales_vs_target;

-- return the number of times that the target is met & the number of times that the target is not met
SELECT h.Category, h.Hit, f.Fail
FROM
    (SELECT Category, COUNT(*) AS Hit
    FROM sales_vs_target
    WHERE hit_or_fail LIKE 'Hit'
    GROUP BY Category) h
INNER JOIN
    (SELECT Category, COUNT(*) AS Fail
    FROM sales_vs_target
    WHERE hit_or_fail LIKE 'Fail'
    GROUP BY Category) f 
ON h.Category = f.Category;


-- ********** Q U E R Y 9 **********
-- find order quantity, profit, amount for each subcategory
-- electronic games & tables subcategories resulted in loss
CREATE VIEW order_details_by_total AS 
SELECT Category, sub_category, 
       SUM(Quantity) AS total_order_quantity, 
       SUM(Profit) AS total_profit, 
       SUM(Amount) AS total_amount 
FROM order_details
GROUP BY sub_category
ORDER BY total_order_quantity DESC;

SELECT * FROM order_details_by_total;

-- maximum cost per unit & maximum price per unit for each subcategory
CREATE VIEW order_details_by_unit AS 
SELECT Category, sub_category, MAX(cost_per_unit) AS max_cost, MAX(price_per_unit) AS max_price
FROM (SELECT *, round((Amount-Profit)/Quantity,2) AS cost_per_unit, round(Amount/Quantity,2) AS price_per_unit 
      FROM order_details)
GROUP BY sub_category      
ORDER BY max_cost DESC;

SELECT * FROM order_details_by_unit;
-- combine order_details_by_unit table and order_details_by_total table
SELECT t.Category, t.sub_category, t.total_order_quantity, t.total_profit, t.total_amount, u.max_cost, u.max_price
FROM order_details_by_total AS t
INNER JOIN order_details_by_unit AS u
ON t.sub_category=u.sub_category;

#Drop table if exists 'order_details_by_total';