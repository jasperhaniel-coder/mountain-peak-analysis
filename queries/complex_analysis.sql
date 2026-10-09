-- Mountain Peak Outfitters: (Complex Analysis answers to the SQL Queries)

-- Q21. Recursive reporting hierarchy for each store with a store manager.
WITH RECURSIVE hierarchy AS (
    SELECT
        st.store_id,
        st.store_name,
        e.employee_id,
        e.first_name,
        e.last_name,
        e.position,
        e.manager_id,
        0 AS hierarchy_level,
        ARRAY[e.employee_id] AS employee_path
    FROM stores AS st
    JOIN employees AS e ON e.store_id = st.store_id
    WHERE e.position = 'Store Manager'
      AND e.manager_id IS NULL

    UNION ALL

    SELECT
        h.store_id,
        h.store_name,
        e.employee_id,
        e.first_name,
        e.last_name,
        e.position,
        e.manager_id,
        h.hierarchy_level + 1,
        h.employee_path || e.employee_id
    FROM hierarchy AS h
    JOIN employees AS e
      ON e.manager_id = h.employee_id
     AND e.store_id = h.store_id
    WHERE NOT (e.employee_id = ANY(h.employee_path))
)
SELECT
    store_name,
    hierarchy_level,
    REPEAT('  ', hierarchy_level) || first_name || ' ' || last_name AS employee,
    position,
    m.first_name || ' ' || m.last_name AS reports_to
FROM hierarchy AS h
LEFT JOIN employees AS m ON m.employee_id = h.manager_id
ORDER BY store_id, employee_path;

-- Q22. Loyalty-tier analysis: average transaction value, most-purchased categories,
-- and distinct products reviewed. Category popularity is measured by units purchased.
WITH tier_transactions AS (
    SELECT
        c.loyalty_tier,
        AVG(sa.total_amount) AS average_transaction_value
    FROM customers AS c
    LEFT JOIN sales AS sa ON sa.customer_id = c.customer_id
    GROUP BY c.loyalty_tier
),
tier_category_units AS (
    SELECT
        c.loyalty_tier,
        cat.category_name,
        SUM(si.quantity) AS units_purchased
    FROM customers AS c
    JOIN sales AS sa ON sa.customer_id = c.customer_id
    JOIN sale_items AS si ON si.sale_id = sa.sale_id
    JOIN products AS p ON p.product_id = si.product_id
    JOIN categories AS cat ON cat.category_id = p.category_id
    GROUP BY c.loyalty_tier, cat.category_name
),
ranked_categories AS (
    SELECT
        loyalty_tier,
        category_name,
        units_purchased,
        DENSE_RANK() OVER (
            PARTITION BY loyalty_tier
            ORDER BY units_purchased DESC
        ) AS category_rank
    FROM tier_category_units
),
favorite_categories AS (
    SELECT
        loyalty_tier,
        STRING_AGG(category_name, ', ' ORDER BY category_name) AS most_purchased_categories
    FROM ranked_categories
    WHERE category_rank = 1
    GROUP BY loyalty_tier
),
tier_reviews AS (
    SELECT
        c.loyalty_tier,
        COUNT(pr.review_id) AS review_count,
        COUNT(DISTINCT pr.product_id) AS distinct_products_reviewed
    FROM customers AS c
    LEFT JOIN product_reviews AS pr ON pr.customer_id = c.customer_id
    GROUP BY c.loyalty_tier
)
SELECT
    tt.loyalty_tier,
    ROUND(COALESCE(tt.average_transaction_value, 0), 2) AS average_transaction_value,
    COALESCE(fc.most_purchased_categories, 'No purchases') AS most_purchased_categories,
    tr.distinct_products_reviewed,
    tr.review_count
FROM tier_transactions AS tt
LEFT JOIN favorite_categories AS fc ON fc.loyalty_tier = tt.loyalty_tier
JOIN tier_reviews AS tr ON tr.loyalty_tier = tt.loyalty_tier
ORDER BY tt.loyalty_tier;
