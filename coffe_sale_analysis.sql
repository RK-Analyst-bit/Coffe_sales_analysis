-- Monday coffe -- Data analysis 

select * from city;
select * from customers;
select * from products;
select * from sales;



-- 1.Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

select city_name,
round((population*25/100)/1000000,2) as coffe_consumer_in_million,
city_rank 
from city
order by coffe_consumer_in_million desc;


-- 2. Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

select city.city_name,sum(sales.total) as coffe_sales,year(sales.sale_date) as year,
quarter(sales.sale_date) as quarter 
from sales
join customers on 
sales.customer_id = customers.customer_id
join
city on 
customers.city_id = city.city_id
where year(sales.sale_date)  = 2023 and
 quarter(sales.sale_date) = 4
group by city.city_name,year,quarter
order by coffe_sales  desc;


-- 3.Sales Count for Each Product
-- How many units of each coffee product have been sold?

select product_id, count(*) as total_sales_unit
from sales
group by product_id
order by total_sales_unit desc ;

-- 4. Average Sales Amount per City
-- What is the average sales amount per customer in each city?

select c.city_name as cities,round(sum(s.total),2) as total_sales_amount,
count(distinct s.customer_id) as no_of_customer_in_city,
round(round(sum(s.total),2)/count(distinct s.customer_id),2) as avg_amount_per_customer
from city as c
join customers cu on 
c.city_id = cu.city_id
join sales as s
on cu.customer_id = s.customer_id
group by cities
order by avg_amount_per_customer desc;

-- 5.City Population and Coffee Consumers
-- Provide a list of cities along with their populations and estimated coffee consumers.

select city.city_name as cities, round(city.population * 0.25/1000000,2) as population_in_million ,
 count(customers.customer_id) as city_customers 
from city 
join customers 
on city.city_id = customers.city_id 
group by 1,2
order by 3 desc; 


-- 6.Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
select city_name,product_name, ranking
from
(select  c.city_name,
p.product_name,
count(s.sale_id) as total_unit_sale ,
dense_rank() over(partition by c.city_name order by count(s.sale_id) desc ) as ranking
from city as c
join customers cu on 
c.city_id = cu.city_id
join sales as s
on cu.customer_id = s.customer_id 
join products as p
on p.product_id = s.product_id
group by 1,2) as ti
where ranking < 4;

-- 7.Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

select c.city_name, count(distinct cu.customer_id ) as distinct_customer
from city as c
join customers cu on 
c.city_id = cu.city_id
join sales as s
on cu.customer_id = s.customer_id
where product_id in (1,2,3,4,5,6,7,8,9,10,11,12,13,14) 
group by 1 ;

-- 8.Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
with city_amount as 
(select c.city_name as cities,round(sum(s.total),2) as total_sales_amount,
count(distinct s.customer_id) as no_of_customer_in_city,
round(round(sum(s.total),2)/count(distinct s.customer_id),2) as avg_amount_per_customer
from city as c
join customers cu on 
c.city_id = cu.city_id
join sales as s
on cu.customer_id = s.customer_id
group by cities),
city_rent
as(select city_name,estimated_rent from city)
select ca.cities,
cr.estimated_rent,
ca.no_of_customer_in_city,
ca.avg_amount_per_customer,
round(cr.estimated_rent/ca.no_of_customer_in_city,2) as avg_rent
from 
city_amount as ca join city_rent as cr
on ca.cities = cr.city_name






