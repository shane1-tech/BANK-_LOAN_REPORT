SELECT * FROM finance.financial_loan;
describe finance.financial_loan;
  SELECT count(*) FROM finance.financial_loan;
  alter table finance.financial_loan
  add column con_issue_date date;
  
  -- converting the date values in the  "issue date" column to a valid  date format 
  -- and adding the values into the column con_issue_date
  update finance.financial_loan
  set con_issue_date = case 
  when issue_date like '_/_/_' then str_to_date(issue_date,'%d/%m/%y') --DD/MM/YYYY
  when issue_date like '_-_-_' then str_to_date(issue_date,'%d-%m-%y') --DD-MM-YYYY
  when issue_date like '_-_-_' then str_to_date(issue_date,'%Y/%m/%d') --YYYY-MM-DD
  ELSE null
  END;
  SELECT * FROM finance.financial_loan;
  alter table finance.financial_loan
  drop column issue_date;
  
  alter table finance.financial_loan
  change column con_issue_date issue_date date;
  
  -- adding column 'con_last_credit_pull_date' to the table
    alter table finance.financial_loan
  add column con_last_credit_pull_date date;

update finance.financial_loan
  set con_last_credit_pull_date = case 
  when last_credit_pull_date like '_/_/_' then str_to_date( last_credit_pull_date,'%d/%m/%y') --DD/MM/YYYY
  when last_credit_pull_date like '_-_-_' then str_to_date( last_credit_pull_date,'%d-%m-%y') --DD-MM-YYYY
  when last_credit_pull_date like '_-_-_' then str_to_date( last_credit_pull_date ,'%Y/%m/%d') --YYYY-MM-DD
  ELSE null
  END;
  
   alter table finance.financial_loan
  drop column last_credit_pull_date;
  
   alter table finance.financial_loan
  change column con_last_credit_pull_date last_credit_pull_date date;
  
  -- repeating the same steps for the 'next_payment_date'
      alter table finance.financial_loan
  add column con_next_payment_date date;

update finance.financial_loan
  set con_next_payment_date = case 
  when next_payment_date like '_/_/_' then str_to_date( next_payment_date,'%d/%m/%y') --DD/MM/YYYY
  when next_payment_date like '_-_-_' then str_to_date( next_payment_date,'%d-%m-%y') --DD-MM-YYYY
  when next_payment_date like '_-_-_' then str_to_date( next_payment_date,'%Y/%m/%d') --YYYY-MM-DD
  ELSE null
  END;
  
   alter table finance.financial_loan
  drop column next_payment_date;
  
   alter table finance.financial_loan
  change column con_next_payment_date next_payment_date date;
  
  SELECT * FROM finance.financial_loan;
  describe finance.financial_loan;
  
  -- last_payment_date
   alter table finance.financial_loan
  add column con_last_payment_date date;
  
 update finance.financial_loan
  set con_last_payment_date = case 
  when last_payment_date like '_/_/_' then str_to_date( last_payment_date,'%d/%m/%y') --DD/MM/YYYY
  when last_payment_date like '_-_-_' then str_to_date( last_payment_date,'%d-%m-%y') --DD-MM-YYYY
  when last_payment_date like '_-_-_' then str_to_date( last_payment_date,'%Y/%m/%d') --YYYY-MM-DD
  ELSE null
  END;
  
   alter table finance.financial_loan
  drop column last_payment_date;
  
   alter table finance.financial_loan
  change column con_last_payment_date last_payment_date date; 
  
    SELECT * FROM finance.financial_loan;
  describe finance.financial_loan;
  
  #1a. calculating Total loan applications received
   SELECT count(id) as Total_loan_applications FROM finance.financial_loan;
   
   #1b.  calculating MTD Total loan applications
SELECT 
    COUNT(id) AS MTD_Total_loan_applications
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021; -- 4312
        
             #1.  calculating PMTD Total loan applications
SELECT 
    COUNT(id) AS PMTD_Total_loan_applications
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021; -- 4035
        
        
        with MTD_app as(
        select count(id) as PMTD_Total_loan_applications FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021),
        PMTD_app as (SELECT 
    COUNT(id) AS PMTD_Total_loan_applications
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021)
SELECT 
    ((MTD.MTD_Total_loan_applications - PMTD.PMTD_Total_loan_applications) / PMTD.PMTD_Total_loan_applications * 100) AS MOM_Total_loan_applications
FROM
    MTD_app MTD,
    PMTD_app PMTD;
        
        ##2a. CALCULATE TOTAL FUNDED AMOUNT
        
        SELECT sum(loan_amount) as loan_total_amount FROM finance.financial_loan;
        
	##2b. CALCULATE MTD TOTAL FUNDED AMOUNT
           SELECT 
    SUM(loan_amount) AS MTD_loan_total_amount
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;
        
 ##2c. CALCULATE PMTD TOTAL FUNDED AMOUNT
        SELECT 
    SUM(loan_amount) AS PMTD_loan_total_amount
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;
WITH MTD_funded as(
        select sum(loan_amount) as MTD_Total_funded_amount FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021),
        PMTD_funded as (
        SELECT 
   sum(loan_funded) AS PMTD_Total_funded_amount
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021)
SELECT 
    ((MTD.MTD_Total_funded_amount - PMTD.PMTD_Total_funded_amount) / PMTD.PMTD_Total_funded_amount * 100) AS MOM_Total_funded_amount
FROM
    MTD_funded MTD,
    PMTD_funded PMTD;
    
 ##3a calculate total amount received
  SELECT sum(total_payment) as total_amount_received FROM finance.financial_loan;
        
	##3b. CALCULATE MTD TOTAL AMOUNT RECEIVED        
    SELECT 
    SUM(total_payment) AS MTD_total_amount_received
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;
        
 ##3c. CALCULATE PMTD TOTAL AMOUNT RECEIVED
        SELECT 
    SUM(total_payment) AS PMTD_total_amount_received
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;
        
        ##3d  CALCULATE mom TOTAL AMOUNT RECEIVED
WITH MTD_payment as(
        select sum(total_payment) as MTD_Total_amount_received FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021),
        PMTD_funded as (
        SELECT 
   sum(total_payment) AS PMTD_Total_amount_received
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021)
SELECT 
    ((MTD.MTD_Total_amount_received - PMTD.PMTD_Total_amount_received) / PMTD.PMTD_Total_amount_received * 100) AS MOM_Total_amount_received
FROM
    MTD_payment MTD,
    PMTD_payment PMTD;
    
    #4a calculate avg int rate
    select avg(int_rate)*100 as avg_interest_rate FROM finance.financial_loan;
    
    #4b calculate MTD avg int rate
   SELECT 
    AVG(int_rate) * 100 AS avg_interest_rate
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;
        
         #4c calculate PMTD avg int rate
          SELECT 
    AVG(int_rate) * 100 AS avg_interest_rate
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;
        
                 #4d calculate MoM avg int rate
                 
            WITH MTD_avg_int as(
        select avg(int_rate)*100 as MTD_avg_int_rate FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021),
        PMTD_avg_int as (
       select avg(int_rate)*100 as PMTD_avg_int_rate FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021)
SELECT 
    ((MTD.MTD_avg_int_rate - PMTD.PMTD_avg_int_rate) / PMTD.PMTD_avg_int_rate * 100) AS MOM_avg_int_rate
FROM
    MTD_avg_int MTD,
    PMTD_avg_int PMTD;     
    
    
    ##5a. calculate avg debt to income ratio DTI
        SELECT avg(dti)*100 as MTD_avg_DTI FROM finance.financial_loan;
        
           #5b calculate MTD avg debt to income ratio DTI
   SELECT 
    AVG(dti) * 100 AS MTD_avg_DTI
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021;
        
              #5c calculate PMTD avg debt to income ratio DTI
   SELECT 
    AVG(dti) * 100 AS PMTD_avg_DTI
FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021;
        
       ##5d calculate MoM avg debt to income ratio DTI
          WITH MTD_DTI as(
        select avg(dti) as MTD_avg_DTI FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 12
        AND YEAR(issue_date) = 2021),
        PMTD_DTI as (
       select avg(dti) as PMTD_avg_DTI FROM
    finance.financial_loan
WHERE
    MONTH(issue_date) = 11
        AND YEAR(issue_date) = 2021)
SELECT 
    ((MTD.MTD_avg_DTI - PMTD.PMTD_avg_DTI) / PMTD.PMTD_avg_DTI * 100) AS MOM_avg_DTI
FROM
    MTD_DTI MTD,
    PMTD_DTI PMTD;     
    
    
    ## 6a calculating the GOOD loan application percentage
    
    select (count(case when loan_status = 'fully paid' or loan_status = 'current' then id end)*
    100)/ count(id) as good_loan_percentage from finance.financial_loan;
    
    ## 6b calculating the total GOOD loan applications
    
    select count(id) as good_loan_application
    FROM
    finance.financial_loan
    where loan_status = 'fully paid' or loan_status = 'current';
    
     ## 6c calculating the GOOD loan funded amount
     select sum(loan_amount) as good_loan_funded_amount
         FROM
    finance.financial_loan
    where loan_status = 'fully paid' or loan_status = 'current';
    
      ## 6d calculating the GOOD loan received amount
         select sum(total_payment) as good_loan_funded_amount
         FROM
    finance.financial_loan
    where loan_status = 'fully paid' or loan_status = 'current';
    
    ##7 Bad loan issued
       ## 7a calculating the BAD loan application percentage
       
    select (count(case when loan_status = 'charged off' then id end)*
    100)/ count(id) as bad_loan_percentage from finance.financial_loan;
    
      ## 7b calculating the total count of BAD loan applications
    
    select count(id) as bad_loan_application
    FROM
    finance.financial_loan
    where loan_status = 'charged off';
    
    ## 7c calculating the BAD loan funded amount
         select sum(loan_amount) as bad_loan_funded_amount
         FROM
    finance.financial_loan
    where loan_status = 'charged off';
    
    ## 7d calculating the GOOD loan received amount
         select sum(total_payment) as bad_loan_funded_amount
         FROM
    finance.financial_loan
    where loan_status = 'charged off';
    
    ## calculate the total loan count, total amount received,total funded amount,interest rate, DTI on the basis of loan payment
    
     select loan_status, 
     count(id) as loan_count,
sum(total_payment) as total_amount_received,
sum(loan_amount) as total_funded_amount,
avg(int_rate*100) as intrest_rate,
avg(dti*100) as DTI
  from finance.financial_loan
  group by loan_status;
  
  ##9 calculate MTD_total_amount_received, MTD_total_funded_amount on the basis of loan_status
       select loan_status, 
sum(total_payment) as MTD_total_amount_received,
sum(loan_amount) as MTD_total_funded_amount
from finance.financial_loan
where month(issue_date) = 12 and year(issue_date)=2021
group by loan_status;
    
    ## 10 calculating monthly total_loan_application, total_funded_amountand total_amount_received
    select
    month(issue_date) as month_number,
    monthname(issue_date) as month_name,
    count(id) as total_loan_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_amount_received
from finance.financial_loan
group by month(issue_date), monthname(issue_date)
order by month(issue_date);

## BANK LOAN REPORT & OVERVIEW-STATE

select
address_state as state,
    count(id) as total_loan_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_amount_received
from finance.financial_loan
group by address_state
order by address_state;
SELECT * FROM finance.financial_loan;