create database project2part1;
use project2part1;
select * from cust_dimen;
select * from market_fact;
select * from orders_dimen;
select * from prod_dimen;
select * from shipping_dimen;
create database project2part2;
use project2part2;
select * from chefmozaccepts;
select * from chefmozcuisine;
select * from chefmozhours4;
select * from chefmozparking;
select * from geoplaces2;
select * from rating_final;
select * from userpayment;
select * from usercuisine;
select * from userprofile;

# Part 1 – Sales and Delivery:
# Question 1: Find the top 3 customers who have the maximum number of orders

select * from
(select cust_id, count(ord_id), dense_rank() over(order by count(ord_id) desc) rnk
from market_fact 
group by cust_id)T
where rnk <=3;

# Question 2: Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.

select o.order_id, o.order_date,s.ship_date,datediff(str_to_date(Ship_Date,'%d-%m-%Y'),str_to_date(Order_Date,'%d-%m-%Y')) DaysTakenforDelivery 
from orders_dimen o join shipping_dimen s
on o.order_id = s.order_id
order by o.order_id;

# Question 3: Find the customer whose order took the maximum time to get delivered.

select distinct  m.cust_id,o.order_id, o.order_date,s.ship_date,datediff(str_to_date(Ship_Date,'%d-%m-%Y'),str_to_date(Order_Date,'%d-%m-%Y')) DaysTakenforDelivery 
from orders_dimen o join shipping_dimen s
on o.order_id = s.order_id
join market_fact m
on m.ord_id = o.ord_id
order by DaysTakenforDelivery desc limit 1 ;

# Question 4: Retrieve total sales made by each product from the data (use Windows function)

select distinct prod_id, round(sum(sales) over(partition by prod_id),2) total_sales
from market_fact;

# Question 5: Retrieve the total profit made from each product from the data (use windows function)

select distinct prod_id, round(sum(profit) over(partition by prod_id),2) total_profit
from market_fact;

# Question 6: Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

select month(str_to_date(O.Order_Date,'%d-%m-%Y')) month, count(distinct m.Cust_id) total_no_customers
from orders_dimen o join market_fact m
on m.Ord_id=o.Ord_id
where year(str_to_date(O.Order_Date,'%d-%m-%Y'))= 2011 
and m.cust_id in 
(select distinct m.Cust_id
from orders_dimen o join market_fact m
on m.Ord_id=o.Ord_id
where month(str_to_date(O.Order_Date,'%d-%m-%Y'))= 1 )
group by month
order by month;

select month(str_to_date(O.Order_Date,'%d-%m-%Y')) month, count(distinct m.Cust_id) total_no_customers
from orders_dimen o join market_fact m
on m.Ord_id=o.Ord_id
where year(str_to_date(O.Order_Date,'%d-%m-%Y'))= 2011 
and m.cust_id in 
(select distinct m.Cust_id
from orders_dimen o join market_fact m
on m.Ord_id=o.Ord_id
where month(str_to_date(O.Order_Date,'%d-%m-%Y'))= 1 and year(str_to_date(O.Order_Date,'%d-%m-%Y'))= 2011 )
group by month
order by month;




# Part 2 – Restaurant:
# Question 1: - We need to find out the total visits to all restaurants under all alcohol categories available.

SELECT g.placeid, count(r.userid) total_visits,g.alcohol
FROM geoplaces2 g JOIN rating_final r
ON g.placeid = r.placeid
where alcohol != 'no_alcohol_served'
group by g.placeid;

# Question 2: -Let's find out the average rating according to alcohol and price so that we can understand the rating in respective price categories as well.

SELECT g.alcohol,g.price,avg(r.rating) avg_ratings
FROM geoplaces2 g JOIN rating_final r
ON g.placeid = r.placeid
where alcohol != 'no_alcohol_served'
group by g.alcohol,g.price
order by g.alcohol,g.price;

# Question 3:  Let’s write a query to quantify that what are the parking availability as well in different alcohol categories along with the total number of restaurants.

select g.alcohol,cp.parking_lot,count(g.placeid)
from geoplaces2 g join chefmozparking cp
on g.placeid = cp.placeid
group by alcohol,parking_lot
order by alcohol,parking_lot;

# Question 4: -Also take out the percentage of different cuisine in each alcohol type.

select *,(t.total_cuisine/sum(t.total_cuisine) over(partition by t.alcohol))*100 percentage
from(
select sc.rcuisine,g.alcohol,count(sc.Rcuisine) total_cuisine
from chefmozcuisine sc join geoplaces2 g
on sc.placeid = g.placeid
group by  g.alcohol,sc.rcuisine
order by  g.alcohol,sc.rcuisine)t;


# Let us now look at a different prospect of the data to check state-wise rating.
# Questions 5: - let’s take out the average rating of each state.

select g.state,avg(r.rating) 
from geoplaces2 g join rating_final r
on g.placeid = r.placeid
where state not like '%?%'
group by g.state;

# Questions 6: -' Tamaulipas' Is the lowest average rated state. 
# Quantify the reason why it is the lowest rated by providing the summary on the basis of State, alcohol, and Cuisine.

select g.state,g.alcohol,cc.rcuisine
from geoplaces2 g join chefmozcuisine cc
on g.placeid = cc.placeid
where state= 'tamaulipas'
group by rcuisine;

#Question 7:  - Find the average weight, food rating, and service rating of the customers who have visited KFC and 
# tried Mexican or Italian types of cuisine, and also their budget level is low.
# We encourage you to give it a try by not using joins.


select l.userid,food_rating,service_rating,name,rcuisine,avg(weight) over(partition by userid) average,budget 
from rating_final l, geoplaces2 m ,usercuisine uc,userprofile up
where l.placeid=m.placeid and l.userid=uc.userid  and l.userID=up.userid and name="kfc" and Rcuisine in("mexican","italian") and budget ="low" ;






