-- create a database
create database mybank;
use mybank;

-- retrieve all table data
select * from customers;
select * from atms;
select * from accounts;
select * from transactions;
select * from loans;
select * from credit_cards;
select * from branches;

-- aggreegate queries
-- calculate total number of customers
select count(*) as totalcustomers from customers;

-- calculate total number of accounts
select count(*) as totalaccounts from accounts;

-- calculate total loan amount
select sum(amount) as totalloanamounts from loans;

-- calculate total credit limit across all credit cards
select sum(creditlimit) as totalcreditlimit from credit_cards;

-- find all active account
select * from accounts where status='active';

-- final all account made on 15 jan 2023
select * from transactions where transactiondate>'2023-01-15';

-- find loans with interst rate above 5.0
select * from loans where interestrate >5.0;

-- find credit cards with balance exceeding the credit limit
select * from credit_cards where balance>creditlimit;

-- join  queries
-- retreive coustomer details along with their accounts
select c.customerid,c.name,c.age,a.accountnumber,a.accounttype,a.balance
from customers c
join accounts a on c.customerid=a.customerid;

-- retrieve transaction details along with associated account and customer infromation
select t.transactionid,t.transactiondate,t.amount,t.type,t.description,a.accountnumber,a.accounttype,c.name as customername
from transactions t
join accounts a on t.accountnumber=a.accountnumber
join customers c on a.customerid=c.customerid;

-- top 10 coustomer with highest loan ammount
select c.name, i.amount as loanamount
from customers c
join loans i on c.customerid=i.customerid
order by i.amount desc
limit 10;

-- delete inactive accounts
set sql_safe_updates=0;
delete from accounts
where status='inactive';

-- find customers with multiple account
select c.customerid,c.name,count(a.accountnumber) as numaccounts
from customers c
join accounts a on c.customerid=a.customerid
group by c.customerid,c.name
having count(a.accountnumber)>1;

-- print first 3 characters of name from customers table
select substring(name,1,3) as firstthreecharactersofname
from customers;

-- print the name from coustomer table into two columns fristname and lastname
select
substring_index(name,' ',1)as firstname,
substring_index(name,' ',-1)as lastname
from customers;

-- sql query to show only odd rows from customers table
select * from customers
where mod(customerid,2)<>0;

-- sql query to determine the 5th highest loan amount without using limit keyword
select distinct amount
from loans l1
where 5=(
select count(distinct amount)
from loans l2
where l2.amount>=l1.amount);

-- sql query to show the secound highest loan from the loans table using sub-query
select max(amount) as secoundhighestloan
from loans
where amount<(
select max(amount)
from loans);

-- sql query to list customerid whose acount is inactive
select customerid
from accounts
where status ='inactive';

-- sql query to fetch the first row of the customer table
select * 
from customers
limit 1;

-- sql query to show the current date and time
select now()as currentdatetime;

-- sql query to create a new table which consists of data structure copied from the customers
create table customerclone like customers;
insert into customerclone select*from customers;

-- sql query to calculate how many days are remaing for customers to pay off the loans
select 
customerid,
datediff(enddate,curdate()) as daysremaining
from loans
where enddate>curdate();

-- query to find the latest transaction date for each account
select accountnumber,max(transactiondate) as latesttransactiondate
from transactions
group by accountnumber;

-- find the avergae age of customers
select avg(age) as averageage
from customers;

-- find accounts with less than miniumum amount for accounts opened before 1st jan 2022
select accountnumber,balance
from accounts
where balance<25000
and opendate<='2022-01-01';

-- find loan that are currently active
select*
from loans
where enddate>=curdate()
and status='active';

-- find the total amount of transactions for each account for a specific month
select accountnumber,sum(amount) as totalamount
from transactions
where month(transactiondate)=6
and year (transactiondate)=2023
group by accountnumber;

-- find the average credit card balance for each coustomer
select customerid,avg(balance) as averagecreditcardbalance
from credit_cards
group by customerid;

-- find the number of inactive atms per location
select location,count(*) as numberofactiveatms
from atms where status ='out of service'
group by location;

-- categorize customers into three agr groups
select name, age ,
case
when age<30 then'below 30'
when age between 30 and 60 then'30 to 60'
else 'above 60'
end as age_group 
from customers;





