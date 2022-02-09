
-- Highest Energy Consumption
with date_consumption as (
select * from fb_eu_energy
UNION ALL
select * from fb_asia_energy
UNION ALL
select * from fb_na_energy
), day_wise_energy as (
select date, sum(consumption) as total_energy
from date_consumption
group by date
order by total_energy desc)
select date, total_energy
from day_wise_energy
where total_energy = (select max(total_energy) from day_wise_energy);
;

SELECT date, total_energy FROM
(SELECT date, SUM(consumption) AS total_energy, DENSE_RANK() OVER (ORDER BY SUM(consumption) DESC) AS r
FROM
(SELECT * FROM fb_eu_energy
UNION ALL
SELECT * FROM fb_asia_energy
UNION ALL
SELECT * FROM fb_na_energy) fb_energy
GROUP BY date) fb_energy_ranked
WHERE r = 1
;

-- Finding User Purchases

select distinct user_id from (
select user_id,
       lead(created_at, 1) over (partition by  user_id order by created_at) - created_at as "date_diff"
from amazon_transactions) s
where date_diff <= 7 ;


-- Users By Avg Session time

with page_load as (
    select user_id,DATE(timestamp) as date, timestamp, action,
           dense_rank() over(partition by user_id, DATE(timestamp) order by timestamp desc) as rank
    FROM facebook_web_log
    WHERE action = 'page_load'
), page_exit as (
    select user_id,DATE(timestamp) as date, timestamp, action,
           dense_rank() over(partition by user_id, DATE(timestamp) order by timestamp) as rank
    FROM facebook_web_log
    WHERE action = 'page_exit'
), user_activity as (
    select pl.date, pl.user_id as user_id, EXTRACT(EPOCH FROM (pe.timestamp - pl.timestamp)) as session_duration
    from page_load pl inner join page_exit pe
    on pl.date = pe.date and pl.user_id = pe.user_id
    where pl.rank = 1 and pe.rank = 1)
select user_id, avg(session_duration)
from user_activity
group by user_id;


-- Customer Revenue In March
select cust_id, sum(total_order_cost) as revenue
from orders
where order_date >= '2019-03-01' AND order_date < '2019-04-01'
group by cust_id;


-- Classify Business Type
select distinct business_name,
       CASE
            WHEN business_name ILIKE '%restuarant%' THEN 'restaurant'
            WHEN business_name ILIKE '%cafe%' OR business_name ILIKE '%coffee%' THEN 'cafe'
            WHEN business_name ILIKE '%school%' THEN 'school'
            ELSE 'other'
        END AS business_type
from sf_restaurant_health_violations;

-- Top Cool Votes
select business_name, review_text
from (
    select business_name, review_text, cool,
           dense_rank() over(order by cool desc) as rank
    from yelp_reviews) s
where rank = 1;

-- Order details
select first_name, order_date, order_details, total_order_cost
from customers c inner join orders o
on c.id = o.cust_id
where first_name in ('Jill', 'Eva')
order by c.id;


-- Workers with Highest Salaries
with cte as (
select worker_id, worker_title, dense_rank() over(order by salary desc) as rank
from worker w inner join  title t
on w.worker_id = t.worker_ref_id)
select worker_title as best_paid_title
from cte
where rank = 3;


SELECT *
FROM
  (SELECT CASE
              WHEN salary =
                     (SELECT max(salary)
                      FROM worker) THEN worker_title
          END AS best_paid_title

   FROM worker a
   INNER JOIN title b ON b.worker_ref_id=a.worker_id
   ORDER BY best_paid_title) sq
WHERE best_paid_title IS NOT NULL;

select b.worker_title
from worker inner join title b
    on worker.worker_id=b.worker_ref_id
Where salary=(select max(salary) from worker);

-- Review of Categories
select UNNEST(string_to_array(categories,';')) as category, SUM(review_count) from yelp_business
group by category
order by 2 desc;

-- Highest Salary in Department
select department, first_name, salary
from (
     select department, first_name, salary,
            dense_rank() over(partition by department order by salary desc) as rank
     from employee
         ) s
where rank = 1;

-- Employee and Manager Salaries
select e.first_name as employee_name, e.salary as employee_salary
from employee e inner join employee m
on e.manager_id = m.id
where e.salary > m.salary;

-- Number of violations
select EXTRACT(YEAR from inspection_date) as year, COUNT(violation_id) as n_inspections
from sf_restaurant_health_violations
where business_name = 'Roxanne Cafe'
group by year
order by year;

-- Highest Target Under Manager
select first_name, target
from (
    select first_name, target, dense_rank() over(order by target desc) rank
    from salesforce_employees
    where manager_id = 13) s
where rank = 1;

-- Popularity Percentage
with cte1 as (
select user1, user2
from facebook_friends
UNION DISTINCT
select user2, user1
from facebook_friends)
select user1, (100*count(1)::float/(select count(distinct user1) from cte1)) as popularity
from cte1
group by user1
order by user1;

-- Highest Cost Orders
with customer_per_day as (
select first_name, sum(total_order_cost) as per_day_spent,
       o.order_date
from orders o inner join customers c
on o.cust_id = c.id
group by c.first_name, o.order_date)
select first_name, per_day_spent as total_order_cost, order_date
from customer_per_day
where per_day_spent = (select max(per_day_spent) from customer_per_day);

-- Monthly Percentage Difference
with monthly_sales as (
    select to_char(created_at, 'YYYY-MM') as month, SUM(value) as total
    from sf_transactions
    group by to_char(created_at, 'YYYY-MM')
)
select month, round((total - (lag(total,1) over(order by month)))::decimal / (lag(total,1) over(order by month)) * 100, 2) as percent_change
from monthly_sales
;

select to_char(created_at,'YYYY-MM') as year_month,
       ROUND(((SUM(value) - LAG(SUM(value),1) over w) / (LAG(SUM(value),1) over w)) * 100,2) as revenue_diff_pct
from sf_transactions
group by year_month
window w AS (ORDER BY to_char(created_at,'YYYY-MM'));



-- Premium vs Freemium
with day_downloads as (
select date, SUM(CASE WHEN paying_customer='no' THEN downloads ELSE 0 END) as non_paying,
       SUM(CASE WHEN paying_customer='yes' THEN downloads ELSE 0 END) as paying
from ms_download_facts d inner join ms_user_dimension u on d.user_id = u.user_id
inner join ms_acc_dimension mad on u.acc_id = mad.acc_id
group by date
)
select *
from day_downloads
where non_paying > paying
order by date
;


-- Top 5 States with 5 Star Businesses
select state, n_businesses
from (
select state, count(1) as n_businesses,
       rank() over(order by count(1) desc) as r
from yelp_business
where stars = 5
group by state
order by 2 desc,1) s
where r < 6;

--Finding Updated Records
--(assuming salaries only increase)
with temp as (
select *, row_number() over (partition by id order by salary desc) r
from ms_employee_salary)
select id, first_name, last_name, department_id, salary as max
from temp
where r = 1;


--Marketing Campaign Success [Advanced]

select count(distinct user_id)
from
    (select
        dense_rank() over (partition by user_id order by created_at) as rnk1,
        dense_rank() over (partition by user_id , product_id order by created_at) as rnk2,
        -- edited according to suggestion
        -- dense_rank() over (partition by user_id , created_at order by product_id) as rnk3,
         user_id,
         product_id,
         created_at
    from marketing_campaign) foo
where rnk1>1 and rnk2=1; -- and rnk3=1

select count(distinct user_id)
from
    (SELECT user_id,
            min(created_at) over(partition by user_id ) as m1,
            min(created_at) over(partition by user_id,product_id ) as m2
    FROM marketing_campaign) c
where m1<>m2;


-- Average Salaries
select department, first_name, salary,
       avg(salary) over(partition by department)
from employee;

-- Popularity of Hack
select location, avg(popularity)
from facebook_hack_survey fhs inner join facebook_employees fe
    on fhs.employee_id = fe.id
group by location;

-- Host Popularity Rental Prices
with host_ratings as (
    select CONCAT_WS('|',price::varchar, room_type, host_since::varchar, zipcode::varchar, number_of_reviews::varchar) as host_id,
           CASE
               WHEN number_of_reviews > 40 THEN 'Hot'
               WHEN number_of_reviews >= 16 THEN 'Popular'
               WHEN number_of_reviews >= 6 THEN 'Trending Up'
               WHEN number_of_reviews >= 1 THEN 'Rising'
               ELSE 'New'
           END as host_pop_rating,
           price
    from airbnb_host_searches
    group by price, room_type, host_since, zipcode, number_of_reviews
    )
select host_pop_rating,
       min(price) as min_price,
       avg(price) as avg_price,
       max(price) as max_price
from host_ratings
group by host_pop_rating;

-- Customer Details
select c.first_name, c.last_name, c.city, o.order_details
from customers c left join orders o
on c.id = o.cust_id
order by c.first_name, o.order_details;

-- Number of Bathrooms and Bedrooms
WITH distinct_hosts as (
select CONCAT_WS('|',price::varchar, room_type, host_since::varchar, zipcode::varchar, number_of_reviews::varchar) as host_id,
        min(property_type) as property_type,
        min(city) as city,
        min(bedrooms) as bedroooms,
        min(bathrooms) as bathrooms
from airbnb_host_searches
group by price, room_type, host_since, zipcode, number_of_reviews
    )
select city, property_type,
       avg(bathrooms) as n_bathrooms_avg,
       avg(bedroooms) as n_bedrooms_avg
from distinct_hosts
group by city, property_type;