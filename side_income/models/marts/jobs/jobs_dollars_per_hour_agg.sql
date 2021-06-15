with lifetime_earnings as (
  select 
    total_lifetime_earnings
  from 
    {{ ref('jobs_total_earnings') }}
),

hours_worked as (
  select 
    sum(total_time_worked)                      as total_time_worked 
  from 
    {{ ref('stg_job_hours_worked') }}
)

select 
  round(
    lifetime_earnings.total_lifetime_earnings/hours_worked.total_time_worked
    , 2
  )                                             as lifetime_dollars_per_hour
from 
  lifetime_earnings
join 
  hours_worked on 1=1