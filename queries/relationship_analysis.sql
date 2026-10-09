-- Mountain Peak Outfitters: (Relationship Analysis answers to the SQL Queries)

-- Q11. Total amount spent by every customer, highest spend first.
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    ROUND(COALESCE(SUM(sa.total_amount), 0), 2) AS total_spent
FROM customers AS c
LEFT JOIN sales AS sa ON sa.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC, customer_name;

-- Q12. Average customer rating by loyalty tier.
-- The left join retains tiers whose customers have not submitted reviews.
SELECT
    c.loyalty_tier,
    ROUND(AVG(pr.rating), 2) AS average_rating,
    COUNT(pr.review_id) AS review_count
FROM customers AS c
LEFT JOIN product_reviews AS pr ON pr.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY c.loyalty_tier;

-- Q13. Customers who purchased something but have never submitted a review.
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email
FROM customers AS c
WHERE EXISTS (
    SELECT 1
    FROM sales AS sa
    WHERE sa.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM product_reviews AS pr
    WHERE pr.customer_id = c.customer_id
)
ORDER BY customer_name;

-- Q14. Customers whose Q2 2023 spending exceeded their Q1 2023 spending.
WITH quarterly_spending AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(CASE
                WHEN sa.sale_date >= TIMESTAMP '2023-01-01'
                 AND sa.sale_date <  TIMESTAMP '2023-04-01'
                THEN sa.total_amount ELSE 0
            END) AS q1_spend,
        SUM(CASE
                WHEN sa.sale_date >= TIMESTAMP '2023-04-01'
                 AND sa.sale_date <  TIMESTAMP '2023-07-01'
                THEN sa.total_amount ELSE 0
            END) AS q2_spend
    FROM customers AS c
    LEFT JOIN sales AS sa ON sa.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    ROUND(q1_spend, 2) AS q1_spend,
    ROUND(q2_spend, 2) AS q2_spend
FROM quarterly_spending
WHERE q2_spend > q1_spend
ORDER BY customer_name;

-- Q15. Most-purchased categories for Gold-tier customers.
-- "Favorite" is measured by total units purchased; ties are retained.
WITH category_units AS (
    SELECT
        c.customer_id,
        cat.category_name,
        SUM(si.quantity) AS units_purchased
    FROM customers AS c
    JOIN sales AS sa ON sa.customer_id = c.customer_id
    JOIN sale_items AS si ON si.sale_id = sa.sale_id
    JOIN products AS p ON p.product_id = si.product_id
    JOIN categories AS cat ON cat.category_id = p.category_id
    WHERE c.loyalty_tier = 'Gold'
    GROUP BY c.customer_id, cat.category_name
),
ranked_categories AS (
    SELECT
        category_name,
        SUM(units_purchased) AS total_units,
        DENSE_RANK() OVER (ORDER BY SUM(units_purchased) DESC) AS category_rank
    FROM category_units
    GROUP BY category_name
)
SELECT category_name, total_units
FROM ranked_categories
WHERE category_rank = 1
ORDER BY category_name;
