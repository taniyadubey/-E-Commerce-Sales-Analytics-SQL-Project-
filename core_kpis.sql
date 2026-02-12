/* ================================
   CORE BUSINESS KPIs
================================ */

/* Total Revenue */
SELECT SUM(amount) AS total_revenue
FROM Orders;


/* Total Orders */
SELECT COUNT(order_id) AS total_orders
FROM Orders;


/* Average Order Value */
SELECT ROUND(AVG(amount),2) AS avg_order_value
FROM Orders;


/* Revenue by Country */
SELECT 
    c.country,
    SUM(o.amount) AS revenue
FROM Orders o
JOIN Customers c 
ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;


/* Revenue by Product */
SELECT 
    item,
    SUM(amount) AS revenue
FROM Orders
GROUP BY item
ORDER BY revenue DESC;
