
-- 01. Сколько продаж, заказов и проданных единиц?
SELECT COUNT(*) AS sales_rows,
       COUNT(DISTINCT order_no) AS orders,
       SUM(quantity) AS units,
       ROUND(SUM(sales_amount), 2) AS sales_amount
FROM sales;

-- 02. Как выглядят первые строки продаж?
SELECT order_no, order_date, product_code, quantity, sales_amount
FROM sales
LIMIT 10;

-- 03. Сколько строк без даты и без суммы?
SELECT SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_dates,
       SUM(CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END) AS missing_amounts
FROM sales;

-- 04. Как менялись суммы продаж по месяцам?
SELECT SUBSTR(order_date, 1, 7) AS month,
       COUNT(DISTINCT order_no) AS orders,
       ROUND(SUM(sales_amount), 2) AS sales_amount
FROM sales
WHERE order_date IS NOT NULL
GROUP BY SUBSTR(order_date, 1, 7)
ORDER BY month;

-- 05. Какие категории дают больше продаж?
SELECT c.category, SUM(s.quantity) AS units,
       ROUND(SUM(s.sales_amount), 2) AS sales_amount
FROM sales AS s
JOIN products AS p ON s.product_code = p.product_code
JOIN categories AS c ON p.category_code = c.category_code
GROUP BY c.category
ORDER BY sales_amount DESC;

-- 06. Какие десять продуктов дают наибольшую сумму?
SELECT p.product_name, SUM(s.quantity) AS units,
       ROUND(SUM(s.sales_amount), 2) AS sales_amount
FROM sales AS s
JOIN products AS p ON s.product_code = p.product_code
GROUP BY p.product_code, p.product_name
ORDER BY sales_amount DESC
LIMIT 10;

-- 07. Какие суммы приходятся на страны клиентов?
SELECT l.country, COUNT(DISTINCT s.order_no) AS orders,
       ROUND(SUM(s.sales_amount), 2) AS sales_amount
FROM sales AS s
JOIN customers AS c ON s.customer_id = c.customer_id
JOIN locations AS l ON c.customer_code = l.customer_code
GROUP BY l.country
ORDER BY sales_amount DESC;

-- 08. Кто входит в десять покупателей с наибольшей суммой?
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(DISTINCT s.order_no) AS orders,
       ROUND(SUM(s.sales_amount), 2) AS sales_amount
FROM customers AS c
JOIN sales AS s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY sales_amount DESC
LIMIT 10;

-- 09. Как соотносятся значения пола в CRM и ERP?
SELECT c.gender AS crm_gender, e.gender AS erp_gender,
       COUNT(*) AS customers
FROM customers AS c
LEFT JOIN customer_details AS e ON c.customer_code = e.customer_code
GROUP BY c.gender, e.gender
ORDER BY customers DESC;

-- 10. Какие клиенты не имеют продаж в этом наборе?
SELECT c.customer_id, c.first_name, c.last_name
FROM customers AS c
LEFT JOIN sales AS s ON c.customer_id = s.customer_id
WHERE s.order_no IS NULL;
