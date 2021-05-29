with clean_rh_transactions as (
  select 
      robinhoodID           as rh_id
    , symbol                as ticker_symbol
    , date_purchased        as purchase_date
    , quantity_purchased    as qt_share_purchased
    , average_price         as avg_price 
    , cum_quantity          as cum_quantity_owned
    , overall_avg_price     as cost_basis
  from
    {{source('stock_stats', 'raw_portfolio_holdings')}}
  where 
    robinhoodID is not null
)

select 
  *
from 
  clean_rh_transactions