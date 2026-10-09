-- Mountain Peak Outfitters:(Basic Analysis answers to the SQL Queries)

-- Q1. Products with fewer than 20 items in stock.
SELECT product_id, product_name, stock_quantity
FROM products
WHERE stock_quantity < 20
ORDER BY stock_quantity ASC, product_name;

-- Q2. Products currently out of stock.
SELECT product_id, product_name
FROM products
WHERE stock_quantity = 0
ORDER BY product_name;

-- Q3. Profit margin percentage for every product, highest first.
SELECT
    product_id,
    product_name,
    ROUND(100.0 * (price - cost) / NULLIF(price, 0), 2) AS profit_margin_pct
FROM products
ORDER BY profit_margin_pct DESC, product_name;

-- Q4. Products missing either a category or a supplier.
SELECT product_id, product_name, category_id, supplier_id
FROM products
WHERE category_id IS NULL OR supplier_id IS NULL
ORDER BY product_id;

-- Q5. All products, retaining rows without a category or supplier.
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name,
    p.price,
    p.stock_quantity
FROM products AS p
LEFT JOIN categories AS c ON c.category_id = p.category_id
LEFT JOIN suppliers AS s ON s.supplier_id = p.supplier_id
ORDER BY p.product_id;
