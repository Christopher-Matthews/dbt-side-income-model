with latest_position as (
  select 
    total_position
  from 
    {{ ref('portfolio_running_total_position') }}
order by 
  date_day desc
limit 1
)

select 
  total_position            as current_position
from 
  latest_position