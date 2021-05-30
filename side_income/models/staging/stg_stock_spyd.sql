
with clean_spyd as (
  select
      Symbol    as ticker_symbol
    , Date      as price_date
    , Open      as open_price
    , High      as high_price
    , Low       as low_price
    , Close     as close_price
    , Volume    as daily_volume
  from 
    {{source('stock_stats', 'raw_spyd_stock_data')}}
  where
    Date is not null 
)

select 
  *
from 
  clean_spyd