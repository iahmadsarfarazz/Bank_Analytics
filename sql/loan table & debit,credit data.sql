USE project_debitcredit;

SHOW TABLES;

select * from debit_credit_data;

DESCRIBE debit_credit_data;

SELECT DISTINCT `Transaction Type`
FROM debit_credit_data;

SELECT SUM(Amount) AS total_debit_amount
FROM debit_credit_data
WHERE TRIM(`Transaction Type`) = 'Debit'; # TOTAL Debit Amount

SELECT SUM(Amount) AS total_debit_amount
FROM debit_credit_data
WHERE TRIM(`Transaction Type`) = 'Credit';# TOTAL Credit Amount

SELECT(SELECT SUM(Amount) FROM debit_credit_data 
WHERE TRIM(`Transaction Type`) = 'Credit') /
(SELECT SUM(Amount) FROM debit_credit_data 
WHERE TRIM(`Transaction Type`) = 'Debit') 
AS credit_to_debit_ratio;                  # Credit to Debit Ratio

SELECT SUM(CASE WHEN `Transaction Type` = 'Credit' THEN amount ELSE 0 END) -
SUM(CASE WHEN `Transaction Type` = 'Debit' THEN amount ELSE 0 END) AS net_transaction_amount
FROM debit_credit_data;                    # Net Transaction Amount

SELECT Branch, SUM(CASE WHEN `Transaction Type` IN ('Credit','Debit') THEN amount ELSE 0 END) 
AS total_transaction_amount
FROM debit_credit_data
GROUP BY Branch;                           # Total Transaction Amount By Branch 

SELECT `Bank Name`, SUM(CASE WHEN `Transaction Type` IN ('Credit','Debit') THEN amount ELSE 0 END)
AS total_transaction_amount
FROM debit_credit_data
GROUP BY `Bank Name`;                      # Transaction volume By Bank

SELECT `Transaction Method`,
COUNT(*) AS transaction_count,
ROUND(COUNT(*) / (SELECT COUNT(*) FROM debit_credit_data) * 100, 2) AS transaction_percentage
FROM debit_credit_data
GROUP BY `Transaction Method`;             # Transaction Method Distribution

SELECT `Transaction Date`
FROM debit_credit_data
WHERE STR_TO_DATE(`Transaction Date`, '%d-%m-%Y') IS NULL;

SELECT Branch,DATE_FORMAT(STR_TO_DATE(`Transaction Date`, '%d-%m-%Y'), '%Y-%m') AS month,
SUM(amount) AS total_transaction_amount
FROM debit_credit_data
WHERE `Transaction Date` IS NOT NULL AND `Transaction Date` <> ''
GROUP BY Branch, DATE_FORMAT(STR_TO_DATE(`Transaction Date`, '%d-%m-%Y'), '%Y-%m')
ORDER BY Branch, month;                    # Branch Transaction Growth

SELECT *, CASE WHEN amount > 500 THEN 'High-Risk' ELSE 'Normal' END AS risk_flag
FROM debit_credit_data;                    # High-Risk Transaction Flag

SELECT 
    COUNT(*) AS high_risk_transaction_count
FROM debit_credit_data
WHERE amount > 500;                        # Suspicious Transaction Frequency

select * from debit_credit_data;

/*-------------------********************_______________________*******************------------------------*/

select * from loan_table;

SELECT SUM(`Funded Amount`) AS Total_Loan_Amount_Funded
FROM loan_table;                           # Total loan Amount Funded

SELECT COUNT(*) AS Total_Loans
FROM loan_table;                           # Total loans Issued

SELECT SUM(`Total Rec Prncp`+ `Total Rrec int`+ `Recoveries`) 
AS Total_Collection
FROM loan_table;                           # Total Collection

SELECT SUM(`Total Rrec int`) AS Total_Interest
FROM loan_table;                           # Toatl Interest

SELECT `Branch Name`,
       SUM(`Total Rrec int`) AS Interest_Revenue,
       SUM(`Total Fees`) AS Fees_Revenue,
       SUM(`Total Rrec int` + `Total Fees`) AS Total_Revenue
FROM loan_table
GROUP BY `Branch Name`;                    # Branch-Wise Revenue

SELECT Grrade AS Grade, COUNT(*) AS Loan_Count
FROM loan_table
GROUP BY Grrade;                           # Grade-Wise Loan Count

SELECT COUNT(*) AS Default_Loan_Count
FROM loan_table
WHERE `Is Default Loan` = 'Y';             # Default Loan

SELECT COUNT(*) AS Delinquent_Clients
FROM loan_table
WHERE `Is Delinquent Loan` = 'Y';          # Delinquent Clients

SELECT 
    (SUM(CASE WHEN `Is Delinquent Loan` = 'Y' THEN 1 ELSE 0 END) / COUNT(*)) * 100
    AS Delinquent_Loan_Rate
FROM loan_table;                           # Delinquent Loan Rate

SELECT 
    (SUM(CASE WHEN `Is Default Loan` = 'Y' THEN 1 ELSE 0 END) / COUNT(*)) * 100
    AS Default_Loan_Rate
FROM loan_table;                            # Default Loan Rate

SELECT `Loan Status`, COUNT(*) AS Loan_Count
FROM loan_table
GROUP BY `Loan Status`;                     # Loan Status-Wise Loan Count

SELECT `Age`, COUNT(*) AS Loan_Count
FROM loan_table
GROUP BY `Age`;                             # Age Group-Wise Loan

SELECT COUNT(*) AS No_Verified_Loan
FROM loan_table
WHERE `Verification Status` = 'Not Verified'; # No Verified Loan (Verification Status)

SELECT AVG(Term) AS Avg_Loan_Maturity
FROM loan_table;                              # Loan Maturity (Term)

SELECT `Disbursement Date (Years)` AS Year, COUNT(*) AS Loans_Disbursement
FROM loan_table
GROUP BY `Disbursement Date (Years)`
ORDER BY Year;                                # Loan Disbursement Trend (Year-Wise)

SELECT COUNT(*) AS not_verified_loan_count
FROM loan_table
WHERE `Verification Status` = 'Not Verified'; # No Verified Loan

SELECT CAST(REPLACE(Term,' months','') AS UNSIGNED) 
AS maturity_months,COUNT(*) AS loan_count
FROM loan_table
GROUP BY maturity_months
ORDER BY maturity_months;                     # Loan Maturity