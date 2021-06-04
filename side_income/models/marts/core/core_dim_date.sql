
with date_spine as ( 
  select 
    date_day
  from 
    unnest(generate_date_array('2021-03-01', current_date())) as date_day
),

add_weekday as (
  select
    date_day
    , case 
        when extract(dayofweek from date_day) = 1 
          then 'Sunday'
        when extract(dayofweek from date_day) = 2
          then 'Monday'
        when extract(dayofweek from date_day) = 3
          then 'Tuesday'
        when extract(dayofweek from date_day) = 4
          then 'Wednesday'
        when extract(dayofweek from date_day) = 5
          then 'Thursday'
        when extract(dayofweek from date_day) = 6
          then 'Friday'
        when extract(dayofweek from date_day) = 7
          then 'Saturday'
      end as day_of_week
  from 
    date_spine
)

select 
  *
from 
  add_weekday