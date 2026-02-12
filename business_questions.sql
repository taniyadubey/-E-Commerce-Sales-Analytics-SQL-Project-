/* Top 2 Products by Revenue */
SELECT item, SUM(amount) AS revenue
FROM Orders
GROUP BY item
ORDER BY revenue DESC
LIMIT 2;


/* Customers Without Orders */
SELECT 
    c.first_name,
    c.last_name
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


/* % Revenue from Delivered Orders */

SELECT 
    ROUND(
        SUM(CASE WHEN s.status = 'Delivered' THEN o.amount ELSE 0 END) * 100.0
        / SUM(o.amount),
        2
    ) AS delivered_revenue_pct
FROM Orders o
JOIN Shippings s
ON o.customer_id = s.customer;
