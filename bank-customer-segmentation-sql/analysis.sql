-- Учебный анализ на SQLite. Откройте data/analysis.sqlite.
-- Каждый SELECT можно выполнить отдельно. Номера соответствуют README.

-- 01. Сколько клиентов, счетов и операций?
SELECT COUNT(*) AS customers FROM customers;

-- 02. Какие типы счетов есть в наборе?
SELECT account_type, COUNT(*) AS accounts
FROM accounts
GROUP BY account_type;

-- 03. Как распределены статусы операций?
SELECT status, COUNT(*) AS transactions
FROM transactions
GROUP BY status;

-- 04. Кто входит в топ-10 по проведённым списаниям?
SELECT c.customer_id, c.region, ROUND(SUM(t.amount), 2) AS debit_rub
FROM customers AS c
JOIN accounts AS a ON c.customer_id = a.customer_id
JOIN transactions AS t ON a.account_id = t.account_id
WHERE t.status = 'posted' AND t.direction = 'debit'
GROUP BY c.customer_id, c.region
ORDER BY debit_rub DESC
LIMIT 10;

-- 05. Кто входит в топ-10 по поступлениям?
SELECT c.customer_id, c.region, ROUND(SUM(t.amount), 2) AS credit_rub
FROM customers AS c
JOIN accounts AS a ON c.customer_id = a.customer_id
JOIN transactions AS t ON a.account_id = t.account_id
WHERE t.status = 'posted' AND t.direction = 'credit'
GROUP BY c.customer_id, c.region
ORDER BY credit_rub DESC
LIMIT 10;

-- 06. Какие счета имеют больше всего проведённых операций?
SELECT account_id, COUNT(*) AS transactions,
       ROUND(SUM(amount), 2) AS turnover_rub
FROM transactions
WHERE status = 'posted'
GROUP BY account_id
ORDER BY transactions DESC
LIMIT 10;

-- 07. Как менялись поступления и списания по месяцам?
SELECT SUBSTR(occurred_at, 1, 7) AS month, direction,
       COUNT(*) AS transactions, ROUND(SUM(amount), 2) AS amount_rub
FROM transactions
WHERE status = 'posted'
GROUP BY SUBSTR(occurred_at, 1, 7), direction
ORDER BY month, direction;

-- 08. У каких открытых счетов не было операций в 2025 году?
SELECT a.account_id, a.customer_id
FROM accounts AS a
LEFT JOIN transactions AS t
  ON a.account_id = t.account_id AND t.status = 'posted'
  AND t.occurred_at BETWEEN '2025-01-01' AND '2025-12-31'
WHERE a.closed_at IS NULL OR a.closed_at > '2025-12-31'
GROUP BY a.account_id, a.customer_id
HAVING COUNT(t.transaction_id) = 0;

-- 09. У каких клиентов ровно один счёт?
SELECT c.customer_id, c.region, COUNT(a.account_id) AS accounts
FROM customers AS c
JOIN accounts AS a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.region
HAVING COUNT(a.account_id) = 1;

-- 10. Какие каналы используются чаще?
SELECT channel, COUNT(*) AS transactions,
       ROUND(SUM(amount), 2) AS turnover_rub
FROM transactions
WHERE status = 'posted'
GROUP BY channel
ORDER BY transactions DESC;

-- 11. Как распределён проведённый оборот по регионам?
SELECT c.region, COUNT(DISTINCT c.customer_id) AS active_customers,
       COUNT(*) AS transactions, ROUND(SUM(t.amount), 2) AS turnover_rub
FROM customers AS c
JOIN accounts AS a ON c.customer_id = a.customer_id
JOIN transactions AS t ON a.account_id = t.account_id
WHERE t.status = 'posted'
GROUP BY c.region
ORDER BY turnover_rub DESC;

-- 12. Сколько счетов открыто на дату среза?
SELECT COUNT(*) AS open_accounts
FROM accounts
WHERE opened_at <= '2025-12-31'
  AND (closed_at IS NULL OR closed_at > '2025-12-31');
