-- Учебный анализ на SQLite. Откройте data/analysis.sqlite.
-- Каждый SELECT можно выполнить отдельно. Номера соответствуют README.

-- 01. Сколько записей и какова средняя длительность пребывания?
SELECT COUNT(*) AS admissions, COUNT(billing_amount) AS valid_bills,
       ROUND(AVG(stay_days), 2) AS avg_stay_days,
       ROUND(AVG(billing_amount), 2) AS avg_bill,
       MIN(admission_date) AS first_date, MAX(admission_date) AS last_date
FROM admissions;

-- 02. Какие состояния встречаются в записях чаще?
SELECT medical_condition, COUNT(*) AS admissions,
       ROUND(AVG(stay_days), 2) AS avg_stay_days
FROM admissions
GROUP BY medical_condition
ORDER BY admissions DESC;

-- 03. Как распределены состояния по годам?
SELECT SUBSTR(admission_date, 1, 4) AS year,
       medical_condition, COUNT(*) AS admissions
FROM admissions
GROUP BY SUBSTR(admission_date, 1, 4), medical_condition
ORDER BY year, medical_condition;

-- 04. Как распределены состояния по возрастным группам?
SELECT CASE WHEN age < 20 THEN 'Under 20'
            WHEN age < 40 THEN '20-39'
            WHEN age < 65 THEN '40-64'
            ELSE '65+' END AS age_group,
       medical_condition, COUNT(*) AS admissions
FROM admissions
GROUP BY age_group, medical_condition
ORDER BY age_group, medical_condition;

-- 05. Как распределены записи по полу и годам?
SELECT SUBSTR(admission_date, 1, 4) AS year, gender,
       COUNT(*) AS admissions
FROM admissions
GROUP BY SUBSTR(admission_date, 1, 4), gender
ORDER BY year, gender;

-- 06. Как распределены состояния по полу?
SELECT gender, medical_condition, COUNT(*) AS admissions
FROM admissions
GROUP BY gender, medical_condition
ORDER BY medical_condition, gender;

-- 07. Какова средняя сумма счёта по состояниям?
SELECT medical_condition, COUNT(billing_amount) AS valid_bills,
       ROUND(AVG(billing_amount), 2) AS avg_bill
FROM admissions
GROUP BY medical_condition
ORDER BY avg_bill DESC;

-- 08. Как различаются суммы по страховым группам и состояниям?
SELECT insurance_provider, medical_condition,
       COUNT(billing_amount) AS valid_bills,
       ROUND(AVG(billing_amount), 2) AS avg_bill
FROM admissions
GROUP BY insurance_provider, medical_condition
ORDER BY insurance_provider, medical_condition;

-- 09. Как распределены записи по группе крови и состояниям?
SELECT blood_type, medical_condition, COUNT(*) AS admissions
FROM admissions
GROUP BY blood_type, medical_condition
ORDER BY blood_type, medical_condition;

-- 10. Как распределены типы госпитализации?
SELECT admission_type, COUNT(*) AS admissions,
       ROUND(AVG(stay_days), 2) AS avg_stay_days
FROM admissions
GROUP BY admission_type;

-- 11. Как менялось число госпитализаций по годам?
SELECT SUBSTR(admission_date, 1, 4) AS year, COUNT(*) AS admissions
FROM admissions
GROUP BY SUBSTR(admission_date, 1, 4)
ORDER BY year;
