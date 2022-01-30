
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


