-- Assessment_Q2.sql
-- Categorize customers by transaction frequency
WITH monthly_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS transaction_count,
        MONTH(s.transaction_date) AS month,
        YEAR(s.transaction_date) AS year
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0
        AND s.transaction_status = 'success' -- Assuming successful transactions only
    GROUP BY 
        s.owner_id, MONTH(s.transaction_date), YEAR(s.transaction_date)
),
customer_avg AS (
    SELECT 
        owner_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM 
        monthly_transactions
    GROUP BY 
        owner_id
)
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM 
    customer_avg
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;