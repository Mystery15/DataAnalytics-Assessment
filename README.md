# DataAnalytics-Assessment

# Approach(es) taken to solve the given problem
## Assesment Question 1
#### Question 1:  High-Value Customers with Multiple Products
Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

Approach: I joined the users table with both savings and investment plans, filtering for only funded accounts (confirmed_amount > 0). The query counts distinct savings and investment products per customer, sums their deposits, and only includes customers with at least one of each product type. I converted amounts from kobo to standard currency by dividing by 100.

## Assesment Question 2
#### Question 2:Transaction Frequency Analysis
Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
  - "High Frequency" (≥10 transactions/month)
  - "Medium Frequency" (3-9 transactions/month)
  - "Low Frequency" (≤2 transactions/month)

Approach: I created a CTE to calculate monthly transaction counts per customer, then another CTE to average these monthly counts. Finally, I categorized customers based on their average monthly transactions and aggregated the results. Only confirmed transactions (confirmed_amount > 0) were counted.

## Assesment Question 3
#### Question 3: Account Inactivity Alert
Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)

Approach: This query identifies inactive accounts by finding the most recent transaction date (either deposit or withdrawal) for each plan, then calculates how many days have passed since that transaction. I only considered funded accounts (confirmed_amount > 0) as "active" accounts that could become inactive.

## Assesment Question 4
#### Question 4: Customer Lifetime Value (CLV) Estimation
Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
  - Account tenure (months since signup)
  - Total transactions
  - Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
  - Order by estimated CLV from highest to lowest

Approach: I calculated customer tenure in months, total transactions, and total transaction value. For CLV, I used the formula provided, ensuring to handle division by zero cases with NULLIF. The profit per transaction is calculated as 0.1% of the average transaction value. Amounts were converted from kobo to standard currency.

## Challenges faced
1. Handling kobo-to-currency conversions consistently across all queries
2. Properly identifying "active" accounts in Q3 by checking both deposits and withdrawals
3. Avoiding division by zero in Q4's CLV calculation
4. Ensuring accurate frequency categorization in Q2 by first calculating monthly averages per customer