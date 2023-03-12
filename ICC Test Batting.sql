# Part - A	
# ICC Test Cricket
create database project4_part1;
use project4_part1;


#1.	Import the csv file to a table in the database.
SHOW TABLES;
select * from `icc test batting figures (1)`;
# 2.	Remove the column 'Player Profile' from the table.

alter table `icc test batting figures (1)`
drop `Player Profile`;

#3.	Extract the country name and player names from the given data and store it in separate columns for further usage.

#----create colunm player_name 
ALTER TABLE`icc test batting figures (1)`
ADD COLUMN PLAYER_NAME VARCHAR(25) AFTER PLAYER;

#----create colunm country
ALTER TABLE`icc test batting figures (1)`
ADD COLUMN COUNTRY VARCHAR(25) AFTER PLAYER_NAME;

#----inserting values in columns
UPDATE `icc test batting figures (1)` SET PLAYER_NAME = SUBSTRING_INDEX(PLAYER,'(',1);
UPDATE `icc test batting figures (1)` SET COUNTRY = REPLACE(SUBSTRING_INDEX(PLAYER,'(',-1),')',' ');

#4.	From the column 'Span' extract the start_year and end_year and store them in separate columns for further usage.

#---- create table start_year
ALTER TABLE`icc test batting figures (1)`
ADD COLUMN start_year int AFTER span;

ALTER TABLE`icc test batting figures (1)`
ADD COLUMN end_year int AFTER start_year;

#----- update values in column
select substring_index(span,'-',1),substring_index(span,'-',-1) from `icc test batting figures (1)`;
update `icc test batting figures (1)` set start_year= substring_index(span,'-',1);
update `icc test batting figures (1)` set end_year= substring_index(span,'-',-1);


# 5.	The column 'HS' has the highest score scored by the player so far in any given match. 
#The column also has details if the player had completed the match in a NOT OUT status. 
#Extract the data and store the highest runs and the NOT OUT status in different columns.
select * from `icc test batting figures (1)`;

#-----CREATE TABLE HIGHEST SCORER
ALTER TABLE`icc test batting figures (1)`
ADD COLUMN HIGHEST_SCORE int AFTER HS;

#----CREATE TABLE NOT_OUT_STATUS
ALTER TABLE`icc test batting figures (1)`
ADD COLUMN STATUS VARCHAR(25) AFTER HIGHEST_SCORE;

#--- UPDATE VALUES IN COLUMN
UPDATE `icc test batting figures (1)` SET HIGHEST_SCORE=substring_index(HS,'*',1);
update `icc test batting figures (1)` set STATUS= if(HS LIKE '%*','NOT_OUT','OUT') ;

#6.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.

SELECT ROW_NUMBER()OVER() BATTING_ORDER,PLAYER_NAME,START_YEAR,END_YEAR, COUNTRY,AVG
FROM `icc test batting figures (1)`
WHERE start_year<=2019 and end_year>=2019 AND  COUNTRY LIKE '%INDIA%'
ORDER BY AVG DESC LIMIT 6;



#7.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have the highest number of 100s across all matches for India.

SELECT ROW_NUMBER()OVER() BATTING_ORDER,PLAYER_NAME,START_YEAR,END_YEAR, COUNTRY,`100`
FROM `icc test batting figures (1)`
WHERE start_year<=2019 and end_year>=2019 AND  COUNTRY LIKE '%INDIA%'
ORDER BY `100` DESC LIMIT 6;



#8.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using 2 selection criteria of your own for India.

SELECT PLAYER_NAME,START_YEAR , END_YEAR ,`100`,AVG,COUNTRY,ROW_NUMBER()OVER() BATTING_ORDER
FROM `icc test batting figures (1)`
WHERE (2019 BETWEEN START_YEAR AND END_YEAR) AND COUNTRY LIKE '%INDIA%'
ORDER BY `100` DESC,AVG DESC
LIMIT 6;


#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
#considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.

CREATE VIEW Batting_Order_GoodAvgScorers_SA AS
(SELECT ROW_NUMBER()OVER() BATTING_ORDER,PLAYER_NAME,START_YEAR,END_YEAR, COUNTRY,AVG
FROM `icc test batting figures (1)`
WHERE start_year<=2019 and end_year>=2019 AND  COUNTRY LIKE '%SA%'
ORDER BY AVG DESC LIMIT 6);

SELECT * FROM Batting_Order_GoodAvgScorers_SA;

#10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given,
# considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

CREATE VIEW ‘Batting_Order_HighestCenturyScorers_SA’ AS
(SELECT ROW_NUMBER()OVER() BATTING_ORDER,PLAYER_NAME,START_YEAR,END_YEAR, COUNTRY,`100`
FROM `icc test batting figures (1)`
WHERE start_year<=2019 and end_year>=2019 AND  COUNTRY LIKE '%SA%'
ORDER BY `100` DESC LIMIT 6);

SELECT * FROM ‘Batting_Order_HighestCenturyScorers_SA’;

# 11.Using the data given, Give the number of player_played for each country.


SELECT COUNTRY, COUNT(PLAYER_NAME) 
FROM `icc test batting figures (1)`
GROUP BY COUNTRY;

# 12.Using the data given, Give the number of player_played for Asian and Non-Asian continent


SELECT COUNT(PLAYER_NAME),
CASE 
WHEN COUNTRY LIKE '%INDIA%' THEN "ASIAN CONTINENT"
WHEN COUNTRY LIKE '%PAK%' THEN "ASIAN CONTINENT"
WHEN COUNTRY LIKE '%AFG%' THEN "ASIAN CONTINENT"
WHEN COUNTRY LIKE '%BDESH%' THEN "ASIAN CONTINENT"
WHEN COUNTRY LIKE '%SL%' THEN "ASIAN CONTINENT"
ELSE "NON-ASIAN CONTINENT"
END CONTINENTS FROM `ICC TEST BATTING FIGURES (1)`
GROUP BY CONTINENTS;

/*
SELECT IF(COUNTRY IN ("INDIA","PAK","AFG","BDESH","SL"),"ASIAN CONTINENT","NON-ASIAN CONTINENT") CONTINENTS,COUNT(PLAYER_NAME)
FROM `ICC TEST BATTING FIGURES (1)`
GROUP BY CONTINENTS;
*/

# Part – B
#1.	Company sells the product at different discounted rates.
# Refer actual product price in product table and selling price in the order item table.
# Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved. 

select t.orderid, t.actual_price,t.selling_price,(t.actual_price-t.selling_price) saved_amount from (
select o.orderid orderid, (o.quantity*p.unitprice) actual_price,(o.quantity*o.unitprice) selling_price
from orderitem o join product p
on o.productid=p.id)t
group by orderid
order by saved_amount desc;

/*
2.	Mr. Kavin want to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
a. List few products that he should choose based on demand.
b. Who will be the competitors for him for the products suggested in above questions.
*/

select productid , sum(quantity) demand
from orderitem
group by productid
order by demand desc;

select productid,productname,companyname, count(productid) cnt
from product p join orderitem oi
on p.id=oi.productid
join supplier s
on p.supplierid = s.id
group by productid
order by cnt desc limit 10;

#b. Who will be the competitors for him for the products suggested in above questions.

select oi.productid , sum(oi.quantity) demand,p.SupplierId
from orderitem oi join product p
on oi.productid=p.id
group by productid
order by demand desc;



/*
3.	Create a combined list to display customers and suppliers details considering the following criteria 
●	Both customer and supplier belong to the same country
●	Customer who does not have supplier in their country
●	Supplier who does not have customer in their country
*/
SELECT c.id, c.firstname,c.lastname,c.country,s.id,s.contactname
from customer c join supplier s
using (country)
union 
select c.id,c.firstname,c.lastname,c.country,s.id,s.contactname
from customer c  left join supplier s
using (country)
union 
select c.id,c.firstname,c.lastname,c.country,s.id,s.contactname
from customer c right join supplier s
using (country);


#4.	Every supplier supplies specific products to the customers. 
#Create a view of suppliers and total sales made by their products and write a query on this view to 
#find out top 2 suppliers (using windows function) in each country by total sales done by the products.

create view total_sale as(
select s.country,s.companyname,p.productname, 
sum(oi.unitprice*oi.quantity) total_sale, 
dense_rank() over(partition by country order by sum(oi.unitprice*oi.quantity) desc) country_RANK
from supplier s join product p on s.id=p.SupplierId 
join orderitem oi on p.id=oi.productid
group by p.ProductName
order by total_sale desc);
select * from total_sale;

# 5.Find out for which products, UK is dependent on other countries for the supply. List the countries which are supplying these products in the same list.

SELECT * FROM supplier
WHERE Country!="UK" AND ID IN (SELECT supplierID FROM product WHERE ID IN (
select PRODUCTID FROM orderitem OI JOIN orders O 
ON OI.OrderId=O.ID
JOIN customer C
ON C.ID=O.CustomerId
WHERE COUNTRY="UK"));


