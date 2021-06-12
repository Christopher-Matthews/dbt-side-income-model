with lyft_earning as (
  select 
      completed_date
    , total_earnings
  from 
    {{ ref('int_jobs_daily_earning_by_service') }}
  where 
    service_title = 'Lyft'
),

dates as (
  select
    *
  from 
    {{ ref('core_dim_date' ) }}
),

joined_earnings as (
  select 
    *
  from 
    dates 
  left join 
    lyft_earning on 
      dates.date_day = lyft_earning.completed_date
),

running_earning as ( 
select 
  *
  , coalesce(
      sum(total_earnings) 
        over (order by date_day), 0
    )                                                 as running_total_earnings
from 
  joined_earnings
)

select 
    date_day
  , day_of_week
  , 'Lyft'                                            as service_title
  , running_total_earnings
from 
  running_earning