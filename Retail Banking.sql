# part-A Retail Banking Case Study

# 1.Create DataBase BANK and Write SQL query to create above schema with constraints

Create database bank_project3;
use bank_project3;


#-------TABLE CREATION----------

# CUSTOMER TABLE
Create table customer(
custid int not null,
fname char(30) not null,
mname char(30) not null,
lname char(30) not null,
occupation char(10),
DOB date,
primary key (custid));

# BRANCH TABLE
Create table Branch_mstr(
Branch_no int,
name char(50) not null,
primary key(branch_no));

# ACCOUNT TABLE
Create table account(
acnumber int not null,
custid int not null,
bid int not null,
curbal int,
Atype char(10),
opndt date,
astatus char(10),
primary key(acnumber),
foreign key(custid) references customer(custid),
foreign key(bid) references branch_mstr(branch_no));

# Employee table
create table Employee(
Emp_no int not null,
branch_no int,
fname char(20),
mname char(20),
lname char(20),
dept char(20),
desig char(10),
mngr_no int not null,
primary key(Emp_no),
Foreign key(branch_no) references branch_mstr(branch_no));

#2.	Inserting Records into created tables Branch

#INSERT VALUES IN BRANCH_MSTR
insert into branch_mstr values
(1,'delhi'),
(2,'mumbai');

select * from branch_mstr;

# INSERT VALUES IN CUSTOMER TABLE
INSERT INTO CUSTOMER VALUES
(1,'Ramesh','Chandra','Sharma','service','1976-12-06'),
(2,'Avinash','Sunder','Minha','Business','1974-10-16');

select * from customer;

# INSERT VALUES IN ACCOUNT TABLE
Insert into account values
(1,1,1,10000,'Saving','2012-12-15','Active'),
(2,2,2,5000,'Saving','2012-06-12','Active');

select * from account;

#INSERT VALUE IN EMPLOYEE
Insert into employee values
(1,1,'Mark','steve','Lara','Account','Accountant',2),
(2,2,'Bella','James','Ronald','Loan','Manager',1);
select * from employee;

# 3.Select unique occupation from customer table

select distinct occupation from customer;

# 4.Sort accounts according to current balance 
select * from account order by curbal;

# 5.Find the Date of Birth of customer name ‘Ramesh’
select fname,dob from customer where fname = 'Ramesh';

#6.Add column city to branch table 
alter table branch_mstr add column city varchar(25);

select * from branch_mstr;

#7.	Update the mname and lname of employee ‘Bella’ and set to ‘Karan’, ‘Singh’
update employee set mname = 'karan',lname='Singh' where fname='Bella';

select * from employee;

#8.	Select accounts opened between '2012-07-01' AND '2013-01-01'
select * from account where opndt between '2012-07-01' and '2013-01-01';

#9.	List the names of customers having ‘a’ as the second letter in their names
 
select * from customer where fname like '_a%';

#10.Find the lowest balance from customer and account table
select * 
from customer c join account a 
on c.custid = a.custid
order by curbal asc limit 1;


#11.Give the count of customer for each occupation
select occupation,count(*) from customer
group by occupation;
#12.	Write a query to find the name (first_name, last_name) of the employees who are managers.

select fname,lname from employee
where desig = 'manager';

#13.	List name of all employees whose name ends with a
select * from employee where fname like '%a';

#14.Select the details of the employee who work either for department ‘loan’ or ‘credit’
select * from employee where dept = 'loan' or dept = 'credit';

# 15.Write a query to display the customer number, customer firstname, account number for the 
select c.custid,c.fname,a.acnumber
from customer c join account a 
on c.custid=a.custid;

#16.Write a query to display the customer’s number, customer’s firstname, branch id and balance amount for people using JOIN.

select c.custid,c.fname,b.branch_no,a.curbal
from account a join customer c
on a.custid =c.custid
join branch_mstr b
on b.branch_no =a.bid;

#17.Create a virtual table to store the customers who are having the accounts in the same city as they live


create view cust_city as
(select * 
from account a join branch b
using (b_id)
join customer c
using(custid)
where b.city = c.city);


/*
18.	A. Create a transaction table with following details 
TID – transaction ID – Primary key with autoincrement 
Custid – customer id (reference from customer table
account no – acoount number (references account table)
bid – Branch id – references branch table
amount – amount in numbers
type – type of transaction (Withdraw or deposit)
DOT -  date of transaction

a. Write trigger to update balance in account table on Deposit or Withdraw in transaction table
b. Insert values in transaction table to show trigger success
*/

create table transaction(
TID INT NOT NULL AUTO_INCREMENT,
CUSTID INT NOT NULL,
ACCOUNT_NO INT NOT NULL,
BID INT NOT NULL,
AMOUNT INT NOT NULL,
TYPE CHAR(20) CHECK(TYPE IN ("WITHDRAW","DEPOSIT")),
DOB DATE,
PRIMARY KEY(TID),
FOREIGN KEY(CUSTID) REFERENCES CUSTOMER(CUSTID),
FOREIGN KEY(ACCOUNT_NO) references ACCOUNT(ACNUMBER),
foreign key (BID) references BRANCH_MSTR(BRANCH_NO)
);
select * from transaction;
#19.Write a query to display the details of customer with second highest balance 

select  *  from customer c join account a
on c.custid = a.custid
order by curbal desc limit 1,1;

#20.Take backup of the databse created in this case study

create view backup as
(select c.custid, b.branch_no, b.name, b.city, e.emp_no, e.fname emp_fname, e.mname emp_mname, e.lname emp_lname,
dept,desig,mngr_no,acnumber, curbal, atype, opndt,astatus, c.fname cus_fname, c.mname cus_mname, c.lname cus_lname,
occupation,dob
from branch_mstr b join employee e
on b.branch_no=e.branch_no
join account a
on a.bid=b.branch_no
join customer c
on c.custid=a.custid
);

select * from backup;


#B Create customer schema with following commands
use casestudy;

/*
1. Display the product details as per the following criteria and sort them in descending order of category:
   #a.  If the category is 2050, increase the price by 2000
   #b.  If the category is 2051, increase the price by 500
   #c.  If the category is 2052, increase the price by 600
 */
 
 select product_class_code,product_price, if(product_class_code = 2050,product_price+2000,
 if(product_class_code=2051,product_price+500,
 if(product_class_code=2052,product_price+600,product_price))) revised_product_price
 from product
 order by product_class_code desc;
 
   
#2.List the product description, class description and price of all products which are shipped. 

select oh.order_id,product_desc,product_class_desc,product_price,oh.order_status
from product_class pc join  product p
on pc.product_class_code = p.product_class_code
join order_items oi
on oi.product_id = p.product_id
join order_header oh
on oh.order_id = oi.order_id
where order_status='shipped';


/*
3. Show inventory status of products as below as per their available quantity:
#a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
#b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#For all categories, if available quantity is 0, show 'Out of stock'.
*/
select pc.product_class_desc,p.product_quantity_avail,
case
when product_class_desc in ('Electronics','computer') then 
	if(product_quantity_avail = 0,'out of stock',if(product_quantity_avail < 10,'Low stock', 
    if(product_quantity_avail between 11 and 30 ,'In stock','Enough stock')))
when product_class_desc in ('stationery','clothes') then 
	if(product_quantity_avail = 0,'out of stock',if(product_quantity_avail < 20,'Low stock',
    if(product_quantity_avail between 21 and 80,'In stock','Enough stock')))
else
   if(product_quantity_avail =0,'out of stock',if(product_quantity_avail < 15,'Low Stock',
   if(product_quantity_avail between 16 and 50,'In Stock','Enough stock')))
end inventory_status
from product p join product_class pc
using(product_class_code);



#4. List customers from outside Karnataka who haven’t bought any toys or books

SELECT DISTINCT OC.CUSTOMER_ID,OC.CUSTOMER_FNAME,OC.CUSTOMER_LNAME,A.STATE
FROM online_customer OC JOIN address A
ON OC.ADDRESS_ID=A.ADDRESS_ID
JOIN order_header OH
ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
JOIN order_items OI
ON OH.ORDER_ID=OI.ORDER_ID
JOIN product P
ON OI.PRODUCT_ID=P.PRODUCT_ID
JOIN product_class PC
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
WHERE A.STATE!="Karnataka" 
AND OC.CUSTOMER_ID NOT IN 
	(SELECT OC.CUSTOMER_ID
		FROM online_customer OC JOIN address A
		ON OC.ADDRESS_ID=A.ADDRESS_ID
		JOIN order_header OH
		ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
		JOIN order_items OI
		ON OH.ORDER_ID=OI.ORDER_ID
		JOIN product P
		ON OI.PRODUCT_ID=P.PRODUCT_ID
		JOIN product_class PC
		ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
        WHERE PRODUCT_CLASS_DESC IN ("TOYS","BOOKS"));
        
        



