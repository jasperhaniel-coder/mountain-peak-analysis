-- Mountain Peak Outfitters: (Aggregation Analysis answers to the SQL Queries)

-- Q6. Total sales for every store, including stores with no transactions.
SELECT
    st.store_id,
    st.store_name,
    st.region,
    ROUND(COALESCE(SUM(sa.total_amount), 0), 2) AS total_sales
FROM stores AS st
LEFT JOIN sales AS sa ON sa.store_id = st.store_id
GROUP BY st.store_id, st.store_name, st.region
ORDER BY total_sales DESC, st.store_name;

-- Q7. Monthly sales amount and transaction count for 2023.
SELECT
    DATE_TRUNC('month', sale_date)::date AS sales_month,
    ROUND(SUM(total_amount), 2) AS total_sales,
    COUNT(*) AS transaction_count
FROM sales
WHERE sale_date >= DATE '2023-01-01'
  AND sale_date < DATE '2024-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY sales_month;

-- Q8. Revenue by product category, based on actual sale-item quantities and prices.
-- Categories with no revenue remain visible with a total of zero.
SELECT
    c.category_id,
    c.category_name,
    ROUND(COALESCE(SUM(
        CASE WHEN sa.sale_id IS NOT NULL
             THEN si.quantity * si.price_sold
             ELSE 0
        END
    ), 0), 2) AS revenue
FROM categories AS c
LEFT JOIN products AS p ON p.category_id = c.category_id
LEFT JOIN sale_items AS si ON si.product_id = p.product_id
LEFT JOIN sales AS sa ON sa.sale_id = si.sale_id
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC, c.category_name;

-- Q9. Five most frequently purchased products by total units.
-- Product name is the deterministic tie-breaker when unit totals are equal.
SELECT
    p.product_id,
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM products AS p
JOIN sale_items AS si ON si.product_id = p.product_id
JOIN sales AS sa ON sa.sale_id = si.sale_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC, p.product_name
LIMIT 5;

-- Q10. Purchase count and most recent purchase for every customer.
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(sa.sale_id) AS purchase_count,
    MAX(sa.sale_date) AS most_recent_purchase
FROM customers AS c
LEFT JOIN sales AS sa ON sa.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY customer_name;
