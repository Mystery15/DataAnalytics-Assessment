-- Assessment_Q1.sql
-- Find customers with at least one funded savings account AND one funded investment plan
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.confirmed_amount / 100.0) AS total_deposits
FROM 
    users_customuser u
INNER JOIN 
    savings_savingsaccount s ON u.id = s.owner_id 
    AND s.plan_id IN (SELECT id FROM plans_plan WHERE is_regular_savings = 1)
    AND s.confirmed_amount > 0
INNER JOIN 
    plans_plan p ON u.id = p.owner_id 
    AND p.is_a_fund = 1
    AND p.id IN (SELECT DISTINCT plan_id FROM savings_savingsaccount WHERE confirmed_amount > 0)
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT s.id) >= 1 AND COUNT(DISTINCT p.id) >= 1
ORDER BY 
    total_deposits DESC;