with rolling_stats as ( 
  select 
    row_number() over (
        partition by service_title 
        order by completed_date
        )                                           as day_index 
    , service_title
    , avg(dollars_per_hour) over (
        partition by service_title 
        order by completed_date 
        rows between 4 preceding and current row
        )                                           as rolling_4_dph_avg
    , avg(dollars_per_mile) over (
        partition by service_title 
        order by completed_date 
        rows between 4 preceding and current row
        )                                           as rolling_4_dpm_avg
  from 
    {{ ref('jobs_hourly_stats_by_service') }}
)

select 
  *
from 
  rolling_stats
