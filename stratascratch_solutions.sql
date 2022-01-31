
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
