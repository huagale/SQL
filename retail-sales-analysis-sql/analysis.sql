
-- 01. Каковы общие показатели продаж?
SELECT COUNT(*) AS sales_rows, SUM(quantity) AS units,
       SUM(revenue) AS revenue, SUM(cost) AS cost,
       SUM(profit) AS profit,
       MIN(sale_date) AS first_date, MAX(sale_date) AS last_date
FROM sales;

-- 02. Пример фильтра: покупатели 25 лет в Германии 9 декабря 2013 года
SELECT sale_date, customer_age, country, product, quantity, revenue
FROM sales
WHERE sale_date = '2013-12-09' AND customer_age = 25 AND country = 'Germany';

-- 03. Пример поиска продуктов по части названия
SELECT sale_id, product, quantity, revenue
FROM sales
WHERE category = 'Bikes' AND product LIKE '%Road-150%'
LIMIT 10;

-- 04. Десять строк Австралии с самым большим количеством
SELECT sale_date, product, quantity, revenue
FROM sales
WHERE country = 'Australia'
ORDER BY quantity DESC
LIMIT 10;

-- 05. Какова сумма затрат в выбранном срезе?
SELECT COUNT(*) AS sales_rows, SUM(cost) AS total_cost
FROM sales
WHERE customer_gender = 'Female' AND customer_age = 43
  AND country = 'United States' AND product LIKE 'Road-150%';

-- 06. Сколько строк продаж приходится на каждый возраст?
SELECT customer_age, COUNT(*) AS sales_rows, SUM(quantity) AS units
FROM sales
GROUP BY customer_age
ORDER BY customer_age;

-- 07. Как менялись выручка и прибыль по годам?
SELECT year, SUM(revenue) AS revenue, SUM(cost) AS cost,
       SUM(profit) AS profit
FROM sales
GROUP BY year
ORDER BY year;

-- 08. Какие пять месяцев дали наибольшую прибыль?
SELECT SUBSTR(sale_date, 1, 7) AS month, SUM(profit) AS profit
FROM sales
GROUP BY SUBSTR(sale_date, 1, 7)
ORDER BY profit DESC
LIMIT 5;

-- 09. Как распределены строки продаж и количество по полу?
SELECT customer_gender, COUNT(*) AS sales_rows,
       SUM(quantity) AS units, SUM(revenue) AS revenue
FROM sales
GROUP BY customer_gender;

-- 10. Какие страны и регионы дают наибольшую выручку?
SELECT country, state, SUM(revenue) AS revenue
FROM sales
GROUP BY country, state
ORDER BY revenue DESC
LIMIT 10;

-- 11. Какие подкатегории дают наибольшую прибыль?
SELECT category, subcategory, SUM(profit) AS profit
FROM sales
GROUP BY category, subcategory
ORDER BY profit DESC
LIMIT 10;

-- 12. Как распределены выручка и прибыль по категориям?
SELECT category, SUM(revenue) AS revenue,
       SUM(profit) AS profit, SUM(quantity) AS units
FROM sales
GROUP BY category
ORDER BY revenue DESC;

-- 13. Как распределено количество по возрастным группам и полу?
SELECT age_group, customer_gender, SUM(quantity) AS units
FROM sales
GROUP BY age_group, customer_gender
ORDER BY age_group, customer_gender;

-- 14. Как выглядит помесячная динамика выручки и прибыли?
SELECT SUBSTR(sale_date, 1, 7) AS month,
       SUM(revenue) AS revenue, SUM(profit) AS profit
FROM sales
GROUP BY SUBSTR(sale_date, 1, 7)
ORDER BY month;
