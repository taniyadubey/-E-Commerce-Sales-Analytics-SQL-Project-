/* ===========================================
   1️⃣ Customer Lifetime Value (CLV)
=========================================== */

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.amount) AS lifetime_value,
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY lifetime_value DESC;


/* ===========================================
   2️⃣ Customer Ranking by Revenue
=========================================== */

SELECT
    c.first_name,
    c.last_name,
    SUM(o.amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(o.amount) DESC) AS revenue_rank
FROM Orders o
JOIN Customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id;


/* ===========================================
   3️⃣ Repeat Purchase Rate
=========================================== */

WITH customer_orders AS (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM Orders
    GROUP BY customer_id
)

SELECT
    COUNT(CASE WHEN order_count > 1 THEN 1 END) * 100.0 
    / COUNT(*) AS repeat_purchase_rate_pct
FROM customer_orders;


/* ===========================================
   4️⃣ Contribution % by Country
=========================================== */

SELECT
    c.country,
    SUM(o.amount) AS revenue,
    ROUND(
        SUM(o.amount) * 100.0 /
        (SELECT SUM(amount) FROM Orders),
        2
    ) AS contribution_percentage
FROM Orders o
JOIN Customers c
ON o.customer_id = c.customer_id
GROUP BY c.country;


/* ===========================================
   5️⃣ Delivered vs Pending Revenue
=========================================== */

SELECT
    s.status,
    SUM(o.amount) AS revenue
FROM Orders o
JOIN Shippings s
ON o.customer_id = s.customer
GROUP BY s.status;


/* ===========================================
   6️⃣ High Value Customers with Pending Shipments
=========================================== */

SELECT
    c.first_name,
    c.last_name,
    SUM(o.amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Shippings s ON c.customer_id = s.customer
WHERE s.status = 'Pending'
GROUP BY c.customer_id
HAVING SUM(o.amount) > 500
ORDER BY total_spent DESC;


/* ===========================================
   7️⃣ Revenue by Age Group
=========================================== */

SELECT
    CASE
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 30 THEN '25-30'
        ELSE '30+'
    END AS age_group,
    SUM(o.amount) AS revenue
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY age_group;
