-- Учебный анализ на SQLite. Откройте data/analysis.sqlite.
-- Каждый SELECT можно выполнить отдельно. Номера соответствуют README.

-- 01. Сколько клиентов в наборе и какая доля ушла?
SELECT COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers;

-- 02. В каких основных полях есть пропуски?
SELECT SUM(CASE WHEN tenure_months IS NULL THEN 1 ELSE 0 END) AS missing_tenure,
       SUM(CASE WHEN order_count IS NULL THEN 1 ELSE 0 END) AS missing_orders,
       SUM(CASE WHEN days_since_last_order IS NULL THEN 1 ELSE 0 END) AS missing_last_order
FROM customers;

-- 03. Какая доля ухода у пользователей телефона и компьютера?
SELECT login_device, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY login_device
ORDER BY churn_rate_pct DESC;

-- 04. Как отличается доля ухода по типу города?
SELECT city_tier, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY city_tier
ORDER BY churn_rate_pct DESC;

-- 05. Как отличаются способы оплаты?
SELECT payment_mode, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY payment_mode
ORDER BY churn_rate_pct DESC;

-- 06. Как различается доля ухода по полу?
SELECT gender, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY gender
ORDER BY churn_rate_pct DESC;

-- 07. Как распределён уход по оценке удовлетворённости?
SELECT satisfaction, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY satisfaction
ORDER BY churn_rate_pct DESC;

-- 08. Как различается доля ухода по семейному статусу?
SELECT marital_status, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY marital_status
ORDER BY churn_rate_pct DESC;

-- 09. Как связаны жалобы и доля ухода?
SELECT complaint, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY complaint
ORDER BY churn_rate_pct DESC;

-- 10. Как связаны число устройств и доля ухода?
SELECT registered_devices, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY registered_devices
ORDER BY churn_rate_pct DESC;

-- 11. В каких категориях больше уходов?
SELECT order_category, COUNT(*) AS customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY order_category
ORDER BY churn_rate_pct DESC;

-- 12. Как отличается доля ухода по стажу?
SELECT CASE WHEN tenure_months IS NULL THEN 'Unknown'
            WHEN tenure_months <= 3 THEN '0-3 months'
            WHEN tenure_months <= 12 THEN '4-12 months'
            ELSE '13+ months' END AS tenure_group,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY tenure_group;

-- 13. Как отличается доля ухода по расстоянию до склада?
SELECT CASE WHEN warehouse_distance IS NULL THEN 'Unknown'
            WHEN warehouse_distance <= 10 THEN '0-10'
            WHEN warehouse_distance <= 20 THEN '11-20'
            ELSE '21+' END AS distance_group,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn), 2) AS churn_rate_pct
FROM customers
GROUP BY distance_group;

-- 14. Чем в среднем отличаются ушедшие и оставшиеся?
SELECT churn, COUNT(*) AS customers,
       ROUND(AVG(hours_on_app), 2) AS avg_app_hours,
       ROUND(AVG(coupons_used), 2) AS avg_coupons,
       ROUND(AVG(address_count), 2) AS avg_addresses,
       ROUND(AVG(days_since_last_order), 2) AS avg_days_without_order,
       ROUND(AVG(cashback_amount), 2) AS avg_cashback
FROM customers
GROUP BY churn;
