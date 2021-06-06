with dates as (
  select 
    * 
  from 
    {{ ref('core_dim_date') }}
),

positions as (
  select 
    * 
  from 
    {{ ref('int_portfolio_cum_holding') }}
  where 
    ticker_symbol = 'ARCC'
),

joined_positions as ( 
    select 
      *    
    from 
      dates 
    left join 
      positions on 
        dates.date_day = positions.purchase_date
    order by 
      dates.date_day
),

running_position as ( 
  select 
    *
    , LAST_VALUE(cum_quantity_owned IGNORE NULLS) 
        OVER(ORDER BY date_day)                   as running_quantity_owned
  from 
    joined_positions 
)

select 
    date_day 
  , day_of_week
  , 'ARCC'                                        as ticker_symbol 
  , running_quantity_owned
from 
  running_position
where 
  running_quantity_owned is not null