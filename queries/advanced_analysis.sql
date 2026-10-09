-- Mountain Peak Outfitters: (Advanced Analysis answers to the SQL Queries)

-- Q16. Sales amount and transaction count for every employee.
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.position,
    ROUND(COALESCE(SUM(sa.total_amount), 0), 2) AS total_sales,
    COUNT(sa.sale_id) AS transaction_count
FROM employees AS e
LEFT JOIN sales AS sa ON sa.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.position
ORDER BY total_sales DESC, employee_name;

-- Q17. Average transaction value for each employee.
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.position,
    ROUND(AVG(sa.total_amount), 2) AS average_transaction_value,
    COUNT(sa.sale_id) AS transaction_count
FROM employees AS e
LEFT JOIN sales AS sa ON sa.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.position
ORDER BY average_transaction_value DESC NULLS LAST, employee_name;

-- Q18. Store manager, employee count, and store sales without join fan-out.
WITH employee_counts AS (
    SELECT store_id, COUNT(*) AS employee_count
    FROM employees
    WHERE store_id IS NOT NULL
    GROUP BY store_id
),
store_sales AS (
    SELECT store_id, SUM(total_amount) AS total_sales
    FROM sales
    GROUP BY store_id
)
SELECT
    st.store_id,
    st.store_name,
    m.first_name || ' ' || m.last_name AS manager_name,
    COALESCE(ec.employee_count, 0) AS employee_count,
    ROUND(COALESCE(ss.total_sales, 0), 2) AS total_sales
FROM stores AS st
LEFT JOIN employees AS m
    ON m.store_id = st.store_id
   AND m.position = 'Store Manager'
LEFT JOIN employee_counts AS ec ON ec.store_id = st.store_id
LEFT JOIN store_sales AS ss ON ss.store_id = st.store_id
ORDER BY st.store_id;

-- Q19. Stores whose average employee salary exceeds the company-wide average.
SELECT
    st.store_id,
    st.store_name,
    ROUND(AVG(e.salary), 2) AS store_average_salary,
    ROUND((SELECT AVG(salary) FROM employees), 2) AS company_average_salary
FROM stores AS st
JOIN employees AS e ON e.store_id = st.store_id
GROUP BY st.store_id, st.store_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees)
ORDER BY store_average_salary DESC;

-- Q20. Product performance matrix.
-- High sales means at or above the median units sold among products with valid sales.
-- High margin means at or above the median list-price margin across all products.
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.price,
        p.cost,
        COALESCE(SUM(si.quantity) FILTER (WHERE sa.sale_id IS NOT NULL), 0) AS units_sold,
        100.0 * (p.price - p.cost) / NULLIF(p.price, 0) AS margin_pct
    FROM products AS p
    LEFT JOIN sale_items AS si ON si.product_id = p.product_id
    LEFT JOIN sales AS sa ON sa.sale_id = si.sale_id
    GROUP BY p.product_id, p.product_name, p.price, p.cost
),
thresholds AS (
    SELECT
        CAST(
            percentile_cont(0.5) WITHIN GROUP (ORDER BY units_sold::double precision)
                FILTER (WHERE units_sold > 0)
            AS numeric
        ) AS median_units_sold,
        CAST(
            percentile_cont(0.5) WITHIN GROUP (ORDER BY margin_pct::double precision)
            AS numeric
        ) AS median_margin_pct
    FROM product_sales
)
SELECT
    ps.product_id,
    ps.product_name,
    ps.units_sold,
    ROUND(ps.margin_pct, 2) AS margin_pct,
    CASE
        WHEN ps.units_sold >= t.median_units_sold
         AND ps.margin_pct >= t.median_margin_pct THEN 'Stars'
        WHEN ps.units_sold >= t.median_units_sold THEN 'Volume Drivers'
        WHEN ps.margin_pct >= t.median_margin_pct THEN 'Opportunities'
        ELSE 'Problems'
    END AS performance_group
FROM product_sales AS ps
CROSS JOIN thresholds AS t
ORDER BY performance_group, ps.product_name;
