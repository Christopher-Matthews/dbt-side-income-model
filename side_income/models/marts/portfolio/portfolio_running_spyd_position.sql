with prices as (
  select
    *
  from
    {{ ref('int_portfolio_spyd_price') }}
),

cumulative_holdings as (
  select 
      date_day
    , running_quantity_owned
  from 
    {{ ref('int_portfolio_cum_spyd_holding') }}
),

total_position as (
  select 
    prices.date_day
    , prices.day_of_week
    , prices.ticker_symbol
    , round(
        coalesce(
          prices.close_price * cumulative_holdings.running_quantity_owned
          , 0)
        , 2
      ) as total_running_position
  from 
    prices 
  left join 
    cumulative_holdings on 
      prices.date_day = cumulative_holdings.date_day
  order by 
    prices.date_day
)

select 
  *
from 
  total_position
