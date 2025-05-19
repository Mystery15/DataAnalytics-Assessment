-- Assessment_Q3.sql
-- Find active accounts with no transactions in the last 365 days
WITH last_transactions AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_a_fund = 1 THEN 'Investment'
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            ELSE 'Other'
        END AS type,
        GREATEST(
            COALESCE((SELECT MAX(s.transaction_date) FROM savings_savingsaccount s WHERE s.plan_id = p.id AND s.confirmed_amount > 0), '1970-01-01'),
            COALESCE((SELECT MAX(w.transaction_date) FROM withdrawals_withdrawal w WHERE w.plan_id = p.id AND w.amount_withdrawn > 0), '1970-01-01')
        ) AS last_transaction_date
    FROM 
        plans_plan p
    WHERE 
        p.is_deleted = 0 
        AND p.is_archived = 0
        AND (p.is_a_fund = 1 OR p.is_regular_savings = 1)
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE(), last_transaction_date) AS inactivity_days
FROM 
    last_transactions
WHERE 
    last_transaction_date < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
    AND last_transaction_date > '1970-01-01' -- Exclude never-transacted accounts
ORDER BY 
    inactivity_days DESC;