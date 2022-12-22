use vehdb;

##What is the distribution of customers across states?

select state,count(customer_id) as no_customer
from customer_t
group by state
order by count(customer_id) desc
limit  10;

##Which are the top 5 vehicle makers preferred by the customer.
select vehicle_maker,count(customer_id) as total_customer
from veh_prod_cust_v
group by vehicle_maker
order by count(customer_id) desc
limit  5;

select * from veh_prod_cust_v;

##What is the most preferred vehicle make in each state?

with preferred_vehicle as
(select state,vehicle_maker,count(customer_id) as total_cust,
rank() over(partition by state order by count(customer_id) desc)  preferred_vehicle_maker
from veh_prod_cust_v
group by state,vehicle_maker)

select state,vehicle_maker, preferred_vehicle_maker
from preferred_vehicle
where preferred_vehicle_maker=1;


##What is the trend of number of orders by quarters?

select quarter_number,count(order_id) as total_order
from order_t
group by quarter_number
order by count(order_id) desc;


select * from veh_ord_cust_v;

## What is the trend of revenue and orders by quarters?
select quarter_number,((quantity*car_price)-discount*(quantity*car_price)) as revenue,count(order_id) as total_order 
from veh_ord_cust_v
group by quarter_number
order by 2 desc;

##What is the average discount offered for different types of credit cards?

select credit_card_Type,avg(discount) as average_dis from veh_ord_cust_v
group by credit_card_Type
order by avg(discount) desc;

##What is the average time taken to ship the placed orders for each quarters?

select quarter_number,avg(datediff(ship_date,order_date)) as avg_time_taken from veh_ord_cust_v
group by quarter_number
order by avg(datediff(ship_date,order_date)) desc;



select * from order_t;

##What is the average rating in each quarter?

with rating_cte as
(
	select quarter_number,
	(case 
	when customer_feedback ='Very Bad' then 1
	when customer_feedback = 'Bad' then 2
	when customer_feedback = 'Okay' then 3
	when customer_feedback = 'Good' then 4
	when customer_feedback = 'Very Good' then 5 end) as customer_rating
	from order_t)
	
	select quarter_number,avg(customer_rating) as average_rating from rating_cte
    group by quarter_number
    order by quarter_number desc;
    
##Are customers getting more dissatisfied over time?
    

with cust_feedback as
(
select quarter_number,
sum(case when customer_feedback ='Very Bad' then 1 else 0 end) as vb,
sum(case when customer_feedback ='Bad' then 1 else 0 end) as bd,
sum(case when customer_feedback ='Okay' then 1 else 0 end) as ok,
sum(case when customer_feedback ='Good' then 1 else 0 end) as gd,
sum(case when customer_feedback ='Very Good' then 1 else 0 end) as vg,
count(customer_feedback) as total_feedbacks
from veh_ord_cust_v 
group by 1)

select quarter_number,
(vb/total_feedbacks)*100 very_bad_per,
(bd/total_feedbacks)*100 bad_per,
(ok/total_feedbacks)*100 ok_per,
(gd/total_feedbacks)*100 gd_per,
(vg/total_feedbacks)*100 vg_per
from cust_feedback
order by 1;



/*  What is the quarter over quarter % change in revenue? */

with qoq as(
select quarter_number,sum((quantity*car_price)-discount*(quantity*car_price)) as total_revenue
from veh_ord_cust_v
group by 1)


select quarter_number,100*(lag(total_revenue) over(order by quarter_number)-total_revenue)/total_revenue as quarter_over_quarter_per_change_in_revenue
from qoq;

