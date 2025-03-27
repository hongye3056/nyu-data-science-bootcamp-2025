#1

SELECT COUNT(DISTINCT Order_id) AS total_orders
FROM SALES
WHERE Date = '2023-03-18';

#2

SELECT COUNT(DISTINCT S.Order_id) AS total_orders_by_john_doe
FROM SALES S
JOIN CUSTOMERS C ON S.Customer_id = C.customer_id
WHERE S.Date = '2023-03-18'
  AND C.first_name = 'John'
  AND C.last_name = 'Doe';

#3

SELECT 
  COUNT(DISTINCT Customer_id) AS total_customers,
  AVG(customer_spending) AS avg_spend_per_customer
FROM (
  SELECT Customer_id, SUM(Revenue) AS customer_spending
  FROM SALES
  WHERE Date BETWEEN '2023-01-01' AND '2023-01-31'
  GROUP BY Customer_id
) AS spending;

#4

SELECT I.department, SUM(S.Revenue) AS total_revenue
FROM SALES S
JOIN ITEMS I ON S.Item_id = I.Item_id
WHERE S.Date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY I.department
HAVING total_revenue < 600;

#5

SELECT 
  MAX(total_revenue) AS max_revenue,
  MIN(total_revenue) AS min_revenue
FROM (
  SELECT Order_id, SUM(Revenue) AS total_revenue
  FROM SALES
  GROUP BY Order_id
) AS order_revenues;


#6

WITH order_revenues AS (
  SELECT Order_id, SUM(Revenue) AS total_revenue
  FROM SALES
  GROUP BY Order_id
),
max_order AS (
  SELECT Order_id
  FROM order_revenues
  ORDER BY total_revenue DESC
  LIMIT 1
)

SELECT S.Order_id, I.Item_id, I.Item_name, I.department, S.Quantity, S.Revenue
FROM SALES S
JOIN ITEMS I ON S.Item_id = I.Item_id
JOIN max_order M ON S.Order_id = M.Order_id;
