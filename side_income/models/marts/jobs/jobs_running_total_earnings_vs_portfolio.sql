with portfolio as (
  select 
    * 
  from 
    {{ ref('portfolio_running_total_position') }}
),

earnings as (
  select 
    * 
  from 
    {{ ref('jobs_running_total_earnings') }}
),

profit_vs_portfolio as (
  select 
    portfolio.date_day
    , portfolio.total_position
    , earnings.running_total_earnings
  from 
    portfolio
  inner join 
    earnings on 
      portfolio.date_day = earnings.date_day
  order by 
    portfolio.date_day
)

select  
  * 
from 
  profit_vs_portfolio